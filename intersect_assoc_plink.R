## Find the overlap of SNPs of lifespan and right slope of weight between males and females by chi-sqaure test after using plink  

setwd("Z:/Project/Tools/Golden Helix/Training/Data_test_FRAM/IBC GRU + NPU/IBC49KQC/Plink")

ls_f = read.table('select_ls_f.txt', sep = '\t', header = TRUE, as.is = TRUE)
ls_m = read.table('select_ls_m.txt', sep = '\t', header = TRUE, as.is = TRUE)
rs_f = read.table('select_rs_f.txt', sep = '\t', header = TRUE, as.is = TRUE)
rs_m = read.table('select_rs_m.txt', sep = '\t', header = TRUE, as.is = TRUE)

names(ls_f)
names(ls_m)
names(rs_f)
names(ls_m)

snp_ls_f = ls_f$SNP
snp_ls_m = ls_m$SNP
snp_rs_f = rs_f$SNP
snp_rs_m = rs_m$SNP

## default row names are number for the row
row.names(ls_f) = snp_ls_f
row.names(ls_m) = snp_ls_m
row.names(rs_f) = snp_rs_f
row.names(rs_m) = snp_rs_m

# intersection cotains SNPs associated with lifespan and weight by chi-square 
inter_f_ls_rs = intersect(snp_ls_f, snp_rs_f) # get intersection of Female: LS and RS
inter_m_ls_rs = intersect(snp_ls_m, snp_rs_m) # get intersection of Male: LS and RS
inter_f_m_ls_rs = intersect(snp_rs_m, intersect(snp_ls_m, intersect(snp_ls_f, snp_rs_f))) # get intersection of Female and Male: LS and RS
inter_f_m_ls_rs_t = intersect(inter_f_ls_rs,inter_m_ls_rs) # get intersection of Female and Male: LS and RS

out_f_ls_rs = cbind(ls_f[inter_f_ls_rs, ], rs_f[inter_f_ls_rs, ])
out_m_ls_rs = cbind(ls_m[inter_m_ls_rs, ], rs_m[inter_m_ls_rs, ])
out_f_m_ls_rs = cbind(ls_f[inter_f_m_ls_rs, ], rs_f[inter_f_m_ls_rs, ], ls_m[inter_f_m_ls_rs, ], rs_m[inter_f_m_ls_rs, ])

names(out_f_ls_rs)
head(row.names(out_f_ls_rs)) ## check everything is fine

## rename the columns of the association analysis results
old_name = c("CHR","SNP","BP","P","OR","P.1","OR.1") 
new_name = c("CHR","SNP","Position","P_ls","OR_ls","P_rs","OR_rs")
## colnames(data)[colnames(data)=="old_name"] <- "new_name" from http://rprogramming.net/rename-columns-in-r/

sel_f_ls_rs = out_f_ls_rs[,c(1:3,9,10,19,20)]
colnames(sel_f_ls_rs)[colnames(sel_f_ls_rs)==old_name] <- new_name ## set up for females
sel_m_ls_rs = out_m_ls_rs[,c(1:3,9,10,19,20)]
colnames(sel_m_ls_rs)[colnames(sel_m_ls_rs)==old_name] <- new_name ## set up for males
sel_f_m_ls_rs = out_f_m_ls_rs[,c(1:3,9,10,19,20,29,30,39,40)]
colnames(sel_f_m_ls_rs)[colnames(sel_f_m_ls_rs)==c("CHR","SNP","BP","P","OR","P.1","OR.1","P.2","OR.2","P.3","OR.3")] <- c("CHR","SNP","Position","P_ls_f","OR_ls_f","P_rs_f","OR_rs_f","P_ls_m","OR_ls_m","P_rs_m","OR_rs_m")

## export intersection to .csv file
write.csv(sel_f_ls_rs, file = "Z:/Project/Tools/Golden Helix/Training/Data_test_FRAM/IBC GRU + NPU/IBC49KQC/Plink/Lifespan_rs_f.csv", quote = FALSE) #the first column is row.name
write.csv(sel_m_ls_rs, file = "Z:/Project/Tools/Golden Helix/Training/Data_test_FRAM/IBC GRU + NPU/IBC49KQC/Plink/Lifespan_rs_m.csv", quote = FALSE)
write.csv(sel_f_m_ls_rs, file = "Z:/Project/Tools/Golden Helix/Training/Data_test_FRAM/IBC GRU + NPU/IBC49KQC/Plink/Lifespan_rs_f_m.csv", quote = FALSE)
