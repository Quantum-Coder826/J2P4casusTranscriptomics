libPath = "~/R/x86_64-pc-linux-gnu-library/4.5/"

options(Ncpus = 6)

if(!require(BiocManager)) {
  install.packages("BiocManager", lib = libPath)
}

if(!require(Rsubread)) {
  BiocManager::install("Rsubread", lib = libPath)
}

if(!require(Rsamtools)) {
  BiocManager::install("Rsamtools", lib = libPath)
}