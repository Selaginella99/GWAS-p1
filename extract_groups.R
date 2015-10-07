## To extract the population and divide into original, offspring and 3rd generations
## mix coding in R and shell 
awk '$4 == 0 {print}' phs000007.v22.pht000182.v10.p8.Framingham_Subject.MULTI.txt > subject_ori.txt
awk '$4 == 1 {print}' phs000007.v22.pht000182.v10.p8.Framingham_Subject.MULTI.txt > subject_off.txt 
awk '$4 == 3 {print}' phs000007.v22.pht000182.v10.p8.Framingham_Subject.MULTI.txt > subject_3rd.txt
awk '{print $1,"\t",$2}' IBCqc.ped > fid.txt # obtain the family ID and individual ID

fid=read.table("Z:/Project/Tools/Golden Helix/Training/Data_test_FRAM/IBC GRU + NPU/IBC49KQC/fid.txt",sep="\t",as.is=T)
ori=read.table("Z:/Project/Tools/Golden Helix/Training/Data_test_FRAM/IBC GRU + NPU/IBC49KQC/subject_ori.txt",sep='\t',header=T,as.is=T)
off=read.table("Z:/Project/Tools/Golden Helix/Training/Data_test_FRAM/IBC GRU + NPU/IBC49KQC/subject_off.txt",sep='\t',as.is=T)
third=read.table("Z:/Project/Tools/Golden Helix/Training/Data_test_FRAM/IBC GRU + NPU/IBC49KQC/subject_3rd.txt",sep='\t',as.is=T)
head(ori)
##  dbGap_Subject_ID IID Sex idtype pedno itwin geno_1212 consent_1212 subj_source source_subjid
## 1            16956   1   2      0    NA    NA        NA            2       SABRe      10013845
## 2            16958   3   2      0    NA    NA         1            2       SABRe      10011037
## 3            16959   4   2      0  1524    NA        NA            2       SABRe      10024850
## 4            16961   7   1      0    NA    NA        NA            2       SABRe      10010742
## 5            16966  16   2      0     1    NA        NA            2       SABRe      10023008
## 6            16967  20   2      0    40    NA        NA            2       SABRe      10017618
head(fid)
     V1    V2
## 1   31  14705
## 2 1492  14107
## 3  893  12888
## 4  288  20171
## 5 1022  12775
## 6  958   8399

ori_fid=fid[(fid$V2%in%ori$IID),]
nrow(ori_fid)
#[1] 636
off_fid=fid[(fid$V2%in%off$V2),]
nrow(off_fid)
#[1] 3062
third_fid=fid[(fid$V2%in%third$V2),]
nrow(third_fid)
#[1] 3960
nrow(third_fid)+nrow(off_fid)+nrow(ori_fid) ##check the number is right
#[1] 7658
nrow(fid)
#[1] 7658

write.table(ori_fid,file="Z:/Project/Tools/Golden Helix/Training/Data_test_FRAM/IBC GRU + NPU/IBC49KQC/ori.fid.txt",sep="\t",row.names=F,col.names=F,quote=F)
write.table(off_fid,file="Z:/Project/Tools/Golden Helix/Training/Data_test_FRAM/IBC GRU + NPU/IBC49KQC/off.fid.txt",sep="\t",row.names=F,col.names=F,quote=F)
write.table(third_fid,file="Z:/Project/Tools/Golden Helix/Training/Data_test_FRAM/IBC GRU + NPU/IBC49KQC/third.fid.txt",sep="\t",row.names=F,col.names=F,quote=F)

## extract the original, offspring and third generations from the total population
plink --file IBCqc --keep ori.fid.txt --make-bed --out IBCori
plink --file IBCqc --keep off.fid.txt --make-bed --out IBCoff
plink --file IBCqc --keep third.fid.txt --make-bed --out IBCthird

plink --bfile IBCori --recode --tab --out IBCori ## to check whether it is the right file...

grep("^[Bb]", names(datafile), value=T) # http://stackoverflow.com/questions/7562233/how-do-i-select-variables-in-an-r-dataframe-whose-names-contain-a-particular-str
grep("^POST", names(datafile), value=T) # http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_04_02.html
