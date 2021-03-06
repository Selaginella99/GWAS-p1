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

plink --bfile data1 --filter-males --make-bed --out males; 

plink --bfile data1 --filter-founders --make-bed --out founders (founders are fewer than non-founders)

### QC procedure 

plink --bfile datafile --missing --mind 0.05 --geno 0.05 --maf 0.05 --hwe 0.001 --make-bed --out outputfile

Order: --mind, --maf, --geno, --hwe, --me

missing rate per person, minor allele frequency, missing rate per SNP, HWE test, Mendel error rate

plink --bfile datafile --mendel --out datafile

[Inclusion thresholds](http://pngu.mgh.harvard.edu/~purcell/plink/thresh.shtml)

### Summary statistics 

[Summary statistics](http://pngu.mgh.harvard.edu/~purcell/plink/summary.shtml) of the individuals/sample, quality of the chips.

plink --bfile datafile --hardy --out ; plink --file datafile --freq --out ; plink --bfile datafile --check-sex --out  ; plink --bfile datafile --keep file.txt(famID, ID) --make-bed --out datafile2

### Association analysis

[Association analysis](http://pngu.mgh.harvard.edu/~purcell/plink/anal.shtml) based on different [phenotype files] (http://pngu.mgh.harvard.edu/~purcell/plink/data.shtml#pheno)

plink --bfile datafile --pheno pheno.txt --mpheno No.x/ --pheno-name bmi --assoc --out assoc.data

e.g.  plink --ped IBCqc_m.ped --map IBCqc.map --pheno lifespan_data.txt --pheno-name ls_bi --assoc --out assoc_m


### Epistasis
[Epistasis](http://pngu.mgh.harvard.edu/~purcell/plink/epi.shtml) without covariates.

[Association analysis](http://pngu.mgh.harvard.edu/~purcell/plink/anal.shtml#glm) & [Covariant regression](https://www.cog-genomics.org/plink2/assoc#linear)

### Reference commands

[Reference options](http://pngu.mgh.harvard.edu/~purcell/plink/reference.shtml)

### Distributed computation

[Parallelising plink](http://chrisladroue.com/2012/03/parallelising-plink-or-anything-else-the-easy-way/?nsukey), [Plink 2](https://www.cog-genomics.org/plink2/parallel) in BGI.

### LD calculations

plink --bfile datafile --ld rs1 rs2 --out ;

[LD calculations](http://pngu.mgh.harvard.edu/~purcell/plink/ld.shtml)

