## set the right direcotry
cd Project/Tools/Golden\ Helix/Training/Data_test_FRAM/IBC\ GRU\ +\ NPU/IBC49K
## build up a better folder name to make everything easier 

## QC before any analysis
plink --bfile IBCwhole --missing --mind 0.05 --geno 0.05 --maf 0.01 --hwe 0.0000000001 --make-bed --out IBCqc

## .bed convert to .ped in order to devide the group into males and females
plink --bfile IBCqc --recode --out IBCqc
## seperate two gender groups, column 5 is sex coding, sex=1 is male, sex=2 is female
awk '$5==2 {print}' IBCqc.ped > IBCqc_f.ped 
awk '$5==1 {print}' IBCqc.ped > IBCqc_m.ped 

## association analysis in females and males, different .ped with the same map
## phenotype lifespan is coded as binary variable, normally coded as control = 1 (age<85), case = 2 (age>92). 
plink --ped IBCqc_f.ped --map IBCqc.map --pheno lifespan_data.txt --pheno-name ls_bi --assoc --out ls_assoc_f
plink --ped IBCqc_m.ped --map IBCqc.map --pheno lifespan_data.txt --pheno-name ls_bi --assoc --out ls_assoc_m

## keep the markers (lifespan) with P<0.05 in females and males
awk '$9 < 0.05 {print}' ls_assoc_f.assoc > select_ls_f.txt
awk '$9 < 0.05 {print}' ls_assoc_m.assoc > select_ls_m.txt

## binary variable right slope of the weight, coded as control = 1 (coeff<-0.12), case = 2 (coeff>-0.12)
plink --ped IBCqc_f.ped --map IBCqc.map --pheno rsweight_data.txt --pheno-name rs_bi --assoc --out rs_assoc_f
plink --ped IBCqc_m.ped --map IBCqc.map --pheno rsweight_data.txt --pheno-name rs_bi --assoc --out rs_assoc_m

## keep the markers (rs of weight) with P<0.05 in females and males
awk '$9 < 0.05 {print}' rs_assoc_f.assoc > select_rs_f.txt
awk '$9 < 0.05 {print}' rs_assoc_m.assoc > select_rs_m.txt


### R coding for recoding the phenotype data
lifespan=read.csv("Z:/Project/Framingham/Data/Phenotype/FHS/lifespan_data.csv",head=T,as.is=T)
lifespan$ls_binary[(lifespan$lifespan>92)]<-2 # http://www.cookbook-r.com/Manipulating_data/Recoding_data/
lifespan$ls_binary[(lifespan$lifespan<85)]<-1
write.csv(lifespan,file="Z:/Project/Framingham/Data/Phenotype/FHS/lifespan_b_data.csv",row.names=F)

rsweight=read.csv("Z:/Project/Framingham/Data/Phenotype/FHS/data/WEIGHT/RIGHT/Fhs22W4_all.csv",head=T,as.is=T)
fid_id=read.csv("Z:/Project/Framingham/Data/Phenotype/FHS/data/WEIGHT/RIGHT/FID_idtype_FRAM_ver22.csv",head=T,as.is=T)
fid_ids=fid_id[fid_id$ID%in%rsweight$ID,] ## get the sex variable
rsweights=merge(rsweight,fid_ids)
#head(rsweights)
rsweights$rsw_bi[rsweights$age1<(-0.12)&rsweights$Sex==1]<-1
rsweights$rsw_bi[rsweights$age1>(-0.12)&rsweights$Sex==1]<-2
rsweights$rsw_bi[rsweights$age1<(-0.15)&rsweights$Sex==2]<-1
rsweights$rsw_bi[rsweights$age1>(-0.15)&rsweights$Sex==2]<-2
write.csv(rsweights,file="Z:/Project/Framingham/Data/Phenotype/FHS/data/WEIGHT/RIGHT/rsweight.csv",row.names=F)
