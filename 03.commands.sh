# step1 

./03.1-RegenieStep1.sh 50 step1

# step2 

./03.2-RegenieStep2.sh

# collect 

python P2.2.3-CollectData-NormalRegenie.py --tgtDir GWASResultV3_UKBWhiteTrainBalance/Diseases_20250819 -c hg19 hg38 --saveDir GWASResultV3_UKBWhiteTrainBalance/merged/Diseases_2025819  -t 4

# post GWAS