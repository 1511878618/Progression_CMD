#!/bin/bash

hardCallPath=/pmaster/xutingfeng/dataset/ukb/dataset/snp/geneArray/ukb_cal_allChrs
threads=$1
input=$2
output=$3


"""
- Input, will found all `*derivation*` files in the folder
- Output, will be a folder with the same name as the parents name of founded input file and with a step1 file inside to save the result
- Note if step1 file is already existed, it will not run again

"""

founded_files=$(find ${input} -name "*derivation*")
for file in ${founded_files}
do
    # get parent folder name of file
    traits_name=$(basename $(dirname "${file}"))
    # mkdir folder
    step1_folder=${output}/${traits_name}/step1

    mkdir -p ${step1_folder}
    # check pred file exists or not 
    pred_file=${step1_folder}/_pred.list
    if [ -f ${pred_file} ]; then
        echo "Step1 file already existed, skip"
        continue
    else
        step1_log_file=${output}/${traits_name}/step1.log
        echo "Start running step1 for ${traits_name}"
        # run step1
        sbatch -J ${traits_name} -c ${threads} --mem=10G -o ${step1_log_file} \
            --wrap """
            regenie \
                --step 1 \
                --threads ${threads} \
                --bed ${hardCallPath} \
                --extract /pmaster/xutingfeng/dataset/ukb/dataset/snp/geneArray/qc_pass.snplist \
                --keep /pmaster/xutingfeng/dataset/ukb/dataset/snp/geneArray/qc_pass.id \
                --bt \
                --phenoFile ${file} \
                --covarFile /pmaster/xutingfeng/dataset/ukb/phenotype/regenie.cov \
                --covarColList genotype_array,inferred_sex,age_visit,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,assessment_center,age_squared \
                --catCovarList	genotype_array,inferred_sex,assessment_center \
                --maxCatLevels 30 \
                --firth \
                --approx \
                --pThresh 0.01 \
                --bsize 1000 \
                --lowmem \
                --lowmem-prefix /hwmaster/xutingfeng/${traits_name} \
                --out ${step1_folder}/${traits_name}/
                """
                
    fi
done
