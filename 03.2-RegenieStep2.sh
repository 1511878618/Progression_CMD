#!/bin/bash
## group by sex and run regenie


threads=$1
input=$2
output=$3
memory="15G"

chrDir=/pmaster/xutingfeng/dataset/ukb/dataset/snp/ukb_imputed_v3_qc/qc_pgen_hg19
covarFile=/pmaster/xutingfeng/dataset/ukb/phenotype/regenie.cov

founded_files=$(find ${input} -name "*derivation*")

for file in ${founded_files}
do
    traits_name=$(basename $(dirname "${file}"))
    # mkdir folder
    step1_folder=${output}/${traits_name}/step1
    step1_file=${step1_folder}/_pred.list
    # check file not exists
    if [ ! -f ${step1_file} ]; then
        echo "Step1 file not existed, skip"
        continue
    else
        step2_folder=${output}/${traits_name}/step2
        mkdir -p ${step2_fodler}

        step2_log_file=${step2_folder}/step2.log
        echo "Start running step2 for ${traits_name} and saveing the log file to ${step2_log_file}"
        # run step2
        for chr in {1..22}; do  # 22
            sbatch -J "chr${chr};${traits_name}" -c ${threads} --mem=${memory} -o ${step2_log_file} --wrap """
            regenie --step 2 \
            --threads=${threads} \
            --pgen ${chrDir}/ukb_imp_chr${chr}_v3_hg37_qc\
            --phenoFile ${file} \
            --bt \
            --covarFile ${covarFile} \
            --covarColList genotype_array,age_visit,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,assessment_center,age_squared \
            --catCovarList genotype_array,assessment_center \
            --maxCatLevels 30 \
            --bsize 1000 \
            --out ${step2_fodler}/chr${chr} \
            --minMAC 10 \
            --firth \
            --approx \
            --pThresh 0.01 \
            --pred ${step1_file}"""
        done
    fi
done

