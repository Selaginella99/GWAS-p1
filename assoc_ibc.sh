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

rsweight=read.csv("Z:/Project/Framingham/Data/Phenotype/FHS/data/WEIGHT/RIGHT/weight_out.csv",head=T,as.is=T)
fid_id=read.csv("Z:/Project/Framingham/Data/Phenotype/FHS/data/WEIGHT/RIGHT/FID_idtype_FRAM_ver22.csv",head=T,as.is=T)
fid_ids=fid_id[fid_id$ID%in%rsweight$ID,] ## get the sex variable
rsweights=merge(rsweight,fid_ids)
#head(rsweights)
rsweights$rsw_bi[rsweights$slp_weight<(-0.12)&rsweights$Sex==1]<-1
rsweights$rsw_bi[rsweights$slp_weight>(-0.12)&rsweights$Sex==1]<-2
rsweights$rsw_bi[rsweights$slp_weight<(-0.15)&rsweights$Sex==2]<-1
rsweights$rsw_bi[rsweights$slp_weight>(-0.15)&rsweights$Sex==2]<-2
#head(rsweight)
write.csv(rsweights[,c(1,14,2,3,15:17,21,22)],file="Z:/Project/Framingham/Data/Phenotype/FHS/data/WEIGHT/RIGHT/rsweight.csv",row.names=F)
## only keep the useful columns

## plot the histograms of the right slope of weight
library(ggplot2)
library(epicalc)
rsweight=read.csv("Z:/Project/Framingham/Data/Phenotype/FHS/data/WEIGHT/RIGHT/rsweight.csv",head=T,as.is=T)
#head(rsweight)
rsweight$Sex <- cut(rsweight$Sex.1, breaks=c(-Inf, 1.1, Inf), labels=c("males","females"))
rsweight$c_rsw <- cut(rsweight$slp_weight, breaks=c(-Inf, -0.018, Inf), labels=c("controls","cases"))
#head(rsweight)
table(rsweight$Sex,rsweight$c_rsw)
#          controls cases
#  males       1090   954
#  females     1314  1246
ggplot(rsweight,aes(x=slp_weight,fill=Sex))+geom_histogram(fill="white",colour="black",binwidth=0.4,
position="identity",alpha=0.4)+geom_density(alpha=.3)+geom_vline(xintercep=-0.018)+facet_grid(Sex~.)

ind=read.csv("Z:/Project/Framingham/Data/Phenotype/FHS/data/WEIGHT/RIGHT/assoc_ind.csv",head=T,as.is=T)
rsweights=rsweight[rsweight$ID%in%ind$ID,]
#nrow(rsweights)
#[1] 636
rsweights$c_rsw <- cut(rsweights$slp_weight, breaks=c(-Inf, -0.005, Inf), labels=c("controls","cases"))
table(rsweights$Sex,rsweights$c_rsw)
#           controls cases
#  males        107   104
#  females      180   245
png("Rs_weight_FHSori.png",width=800,height=600)
ggplot(rsweights,aes(x=slp_weight,fill=Sex))+geom_histogram(fill="white",colour="black",binwidth=0.08)+
geom_density(alpha=.3)+geom_vline(xintercep=-0.005)+annotate("text",x=0.6,y=50,label="cutoff = - 0.005",size=6)+facet_grid(Sex~.)+
ggtitle("Histograms of the right slope of weight in FHSorig 626 (211+425)")+theme(plot.title=element_text(size=18))
###p=ggplot(rsweights,aes(x=slp_weight,fill=Sex))+geom_histogram(fill="white",colour="black",binwidth=0.08)+geom_density(alpha=.3)
###p+geom_vline(xintercep=-0.002)+facet_grid(Sex~.)+ggtitle("Histograms of the right slope of weight in FHSorig (636)")
##  https://github.com/mbostock/d3/wiki/Ordinal-Scales
dev.off()
write.csv(rsweights,file="Z:/Project/Framingham/Data/Phenotype/FHS/data/WEIGHT/RIGHT/rsw_assoc.csv",row.names=F)

rsweights_f=rsweights[rsweights$Sex=="females",]
summ(rsweights_f$slp_weight)
#  obs. mean   median  s.d.   min.   max.  
#  425  0.052  0.027   0.23   -0.86  1.012 
summary(rsweights_f$slp_weight)
#    Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
# -0.85970 -0.06737  0.02665  0.05202  0.16330  1.01200 

png("Rs_weight_FHSori_F.png",width=800,height=600)
p=ggplot(rsweights_f,aes(x=slp_weight,fill=Sex))+geom_histogram(fill="#d6616b",colour="black",binwidth=0.06)+geom_density(alpha=.3)
p+geom_vline(xintercep=-0.02665)+ggtitle("Histograms of the right slope of weight in FHSorig females (425)")+theme(plot.title=element_text(size=18))
+annotate("text",x=0.5,y=40,label="median = 0.02665",size=6)
dev.off()

rsweights_m=rsweights[rsweights$Sex=="males",]
summ(rsweights_m$slp_weight)
#  obs. mean   median  s.d.   min.   max.  
#  211  0.005  -0.008  0.21   -0.462 0.974 
summary(rsweights_m$slp_weight)
#     Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
# -0.461700 -0.130800 -0.008480  0.004596  0.132600  0.974000 

png("Rs_weight_FHSori_M.png",width=800,height=600)
q=ggplot(rsweights_m,aes(x=slp_weight,fill=Sex))+geom_histogram(fill="#6baed6",colour="black",binwidth=0.05)+geom_density(alpha=.3)
q+geom_vline(xintercep=-0.00848)+ggtitle("Histograms of the right slope of weight in FHSorig males (211)")+theme(plot.title=element_text(size=18))+
annotate("text",x=0.3,y=20,label="median = - 0.0085",size=6)
dev.off()

rsweight_p=read.csv("Z:/Project/Framingham/Data/Phenotype/FHS/data/WEIGHT/RIGHT/rsweight_p.csv",head=T,as.is=T)
rsweight_p_f=subset(rsweight_p,rsweight_p$Sex==2)
rsweight_p_m=subset(rsweight_p,rsweight_p$Sex==1)

ggplot(rsweight_p_m,aes(x=age2_weight2))+geom_histogram(fill="white",colour="black",binwidth=0.02)+xlim(-0.6,0.6)
ggplot(rsweight_p_f,aes(x=age2_weight2))+geom_histogram(fill="white",colour="black",binwidth=0.02)+xlim(-0.6,0.6)
ggplot(rsweight_p,aes(x=age2_weight2,fill=Sex))+geom_histogram(fill="white",colour="black",binwidth=0.05)
+facet_grid(Sex) ## but sex is an integer here...
ggplot(rsweight_p, aes(x=age2_weight2, y=age1_weight2, color=Sex)) + 
geom_point(shape=1) + geom_smooth(method=lm,se=FALSE,fullrange=TRUE) # Extend regression lines between coeffs of weight

## extract unique columns (6-15) in file (map)
uni_map=map[!duplicated(map[6:15]),]
