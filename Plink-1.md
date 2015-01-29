## PLINK commands

### Workflow of PLINK 
[Order of major operations in PLINK](http://pngu.mgh.harvard.edu/~purcell/plink/flow.shtml)

###  Data manipulation
[Data management](http://pngu.mgh.harvard.edu/~purcell/plink/dataman.shtml)

#### Merge data

plink --bfile data1 --bmerge data2.bed data2.bim data2.fam --make-bed --out mergefile

#### randomly select 20% sample

plink --bfile data1 --thin 0.2 --make-bed --out random20

#### filter out a subset of individuals

plink --bfile data1 --filter-males --make-bed --out males

### QC procedure 

plink --bfile datafile --missing --mind 0.05 --geno 0.05 --maf 0.05 --hwe 0.001 --make-bed --out outputfile

Order: --mind, --maf, --geno, --hwe, --me

missing rate per person, minor allele frequency, missing rate per SNP, HWE test, Mendel error rate

[Inclusion thresholds](http://pngu.mgh.harvard.edu/~purcell/plink/thresh.shtml)

### Summary statistics 

[Summary statistics](http://pngu.mgh.harvard.edu/~purcell/plink/summary.shtml) of the individuals/sample, quality of the chips.

### Reference commands

[Reference options](http://pngu.mgh.harvard.edu/~purcell/plink/reference.shtml)


