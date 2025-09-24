#!/bin/bash
## group by sex and run regenie
outputPath="./ProgressionGWAS"
threads=5
memory="15G"

#params
chrDir=/pmaster/xutingfeng/dataset/ukb/dataset/snp/ukb_imputed_v3_qc/qc_pgen_hg19
covarFile=/pmaster/xutingfeng/dataset/ukb/phenotype/regenie.cov

threads=5

# Run Progression_part1 
step1=./step1/Progression_part1/_pred.list
DiseaseOutputPath=${outputPath}/Progression_part1
phenoFile=./Progression_part1.regenie
logfile=./Progression_part1/

mkdir -p ${logfile}
# old 
for sex in female male; do
    keep_files=/pmaster/xutingfeng/dataset/ukb/dataset/regenie/sex_diff/white_${sex}.tsv
    c_outputPath=${DiseaseOutputPath}/${sex}
    mkdir -p ${c_outputPath}

    for chr in {1..22}; do  # 22

        sbatch -J "${sex}_chr${chr}" -c ${threads} --mem=${memory} -o ${logfile}/${sex}_chr${chr}_gwas.log --wrap """
        regenie --step 2 \
        --threads=${threads} \
        --pgen ${chrDir}/ukb_imp_chr${chr}_v3_hg37_qc\
        --phenoFile ${phenoFile} \
        --keep ${keep_files} \
         --bt \
        --covarFile ${covarFile} \
        --covarColList genotype_array,age_visit,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,assessment_center,age_squared \
        --catCovarList genotype_array,assessment_center \
        --maxCatLevels 30 \
        --bsize 1000 \
        --out ${c_outputPath}/chr${chr} \
        --minMAC 10 \
        --firth \
        --approx \
        --pThresh 0.01 \
        --pred ${step1}"""
    done
done

