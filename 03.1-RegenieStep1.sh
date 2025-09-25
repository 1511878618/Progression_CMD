#!/bin/bash

hardCallPath=/pmaster/xutingfeng/dataset/ukb/dataset/snp/geneArray/ukb_cal_allChrs
threads=$1
input=$2
output=$3

input_name=$(basename "${input}")
PhenoPath=./

cat >&1 <<-EOF
Example code:
./step1.sh 30 step1/
EOF

mkdir -p ${output}

# step1
mkdir -p ${output}/${input_name}
sbatch -J "Diseases" -c ${threads} --mem=100G -o ${input_name}.log \
    --wrap """
regenie \
    --step 1 \
    --threads ${threads} \
    --bed ${hardCallPath} \
    --extract /pmaster/xutingfeng/dataset/ukb/dataset/snp/geneArray/qc_pass.snplist \
    --keep /pmaster/xutingfeng/dataset/ukb/dataset/snp/geneArray/qc_pass.id \
    --keep /pmaster/xutingfeng/dataset/ukb/phenotype/white.tsv \
    --bt \
    --phenoFile ${PhenoPath}/${2} \
    --covarFile /pmaster/xutingfeng/dataset/ukb/phenotype/regenie.cov \
    --covarColList genotype_array,inferred_sex,age_visit,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,assessment_center,age_squared \
    --catCovarList	genotype_array,inferred_sex,assessment_center \
    --maxCatLevels 30 \
    --firth \
    --approx \
    --pThresh 0.01 \
    --bsize 1000 \
    --lowmem \
    --lowmem-prefix /hwmaster/xutingfeng/${input_name} \
    --out ${output}/${input_name}/
    """

