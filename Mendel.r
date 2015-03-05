## Calculation of the mendel error rate from the .lmendel file

mendel.rate.50k=read.table("Z:/Project/Tools/Golden Helix/Training/Data_test_FRAM/550K GRU + NPU/GRU/fhs50k_mendel.txt", header=TRUE, sep="")
head(mendel.rate.50k)
mendel.rate.50k$rate=1-(mendel.rate.50k$N/nrow(mendel.rate.50k))
head(mendel.rate.50k)
## CHR        SNP  N      rate
## 1   0 ss74814415  2 0.9999594
## 2   0 ss74815978 17 0.9996545
## 3   0 ss74816412  5 0.9998984
## 4   0 ss74816313  2 0.9999594
## 5   0 ss74816251  0 1.0000000
## 6   0 ss74816791  0 1.0000000
write.csv(mendel.rate.50k,file="Z:/Project/Tools/Golden Helix/Training/Data_test_FRAM/550K GRU + NPU/GRU/fhs50k_mendel.csv")
