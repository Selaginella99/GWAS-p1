### PLINK commands

#### Workflow of PLINK 
[Order of major operations in PLINK](http://pngu.mgh.harvard.edu/~purcell/plink/flow.shtml)

#### QC procedure 

plink --bfile datafile --missing --mind 0.05 --geno 0.05 --maf 0.05 --hwe 0.001 --make-bed --out outputfile

[Inclusion thresholds](http://pngu.mgh.harvard.edu/~purcell/plink/thresh.shtml)
