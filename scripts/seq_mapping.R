# Auteur: Berend Veldthuis
# Functie: Dit script indexeert het humaan referentie genoom en alinged alle samples daarop.
# De output zijn een berg aan .BAM files. het creëerd ook sorted bams.
library(Rsubread)
library(Rsamtools)

# Build de index for de refSeq
# Uitgevoerd op 2025-06-02 17:12:58 UTC+1
buildindex(
  basename = './refSeqHomoSapiens/homoSapiens',
  reference = './refSeqHomoSapiens/GCF_000001405.40_GRCh38.p14_genomic.fna',
  memory = 16000, # use 16gig of ram
  indexSplit = TRUE)

## Aling alle monster (dit dynamisch handelen zouw beter zijn, maar ik ben lui)
# control group
align.ctrl1 <- align(index = "./refSeqHomoSapiens/homoSapiens", 
                    readfile1 = "./dataset/SRR4785819_1_ctrl1.fastq", 
                    readfile2 = "./dataset/SRR4785819_2_ctrl1.fastq", 
                    output_file = "./bams/ctrl1.BAM",
                    nthreads = 16)

align.ctrl2 <- align(index = "./refSeqHomoSapiens/homoSapiens", 
                    readfile1 = "./dataset/SRR4785820_1_ctrl2.fastq", 
                    readfile2 = "./dataset/SRR4785820_2_ctrl2.fastq", 
                    output_file = "./bams/ctrl2.BAM",
                    nthreads = 16)

align.ctrl3 <- align(index = "./refSeqHomoSapiens/homoSapiens", 
                    readfile1 = "./dataset/SRR4785828_1_ctrl3.fastq", 
                    readfile2 = "./dataset/SRR4785828_2_ctrl3.fastq", 
                    output_file = "./bams/ctrl3.BAM",
                    nthreads = 16)

align.ctrl4 <- align(index = "./refSeqHomoSapiens/homoSapiens", 
                    readfile1 = "./dataset/SRR4785831_1_ctrl4.fastq", 
                    readfile2 = "./dataset/SRR4785831_2_ctrl4.fastq", 
                    output_file = "./bams/ctrl4.BAM",
                    nthreads = 16)

# RA groep
align.ra1 <- align(index = "./refSeqHomoSapiens/homoSapiens", 
                   readfile1 = "./dataset/SRR4785979_1_ra1.fastq", 
                   readfile2 = "./dataset/SRR4785979_2_ra1.fastq", 
                   output_file = "./bams/ra1.BAM",
                   nthreads = 16)

align.ra2 <- align(index = "./refSeqHomoSapiens/homoSapiens", 
                   readfile1 = "./dataset/SRR4785980_1_ra2.fastq", 
                   readfile2 = "./dataset/SRR4785980_2_ra2.fastq", 
                   output_file = "./bams/ra2.BAM",
                   nthreads = 16)

align.ra3 <- align(index = "./refSeqHomoSapiens/homoSapiens", 
                   readfile1 = "./dataset/SRR4785986_1_ra3.fastq", 
                   readfile2 = "./dataset/SRR4785986_2_ra3.fastq", 
                   output_file = "./bams/ra3.BAM",
                   nthreads = 16)

align.ra4 <- align(index = "./refSeqHomoSapiens/homoSapiens", 
                   readfile1 = "./dataset/SRR4785988_1_ra4.fastq", 
                   readfile2 = "./dataset/SRR4785988_2_ra4.fastq", 
                   output_file = "./bams/ra4.BAM",
                   nthreads = 16)

# Pull de path van alle *.BAM files in ./bams/
samples <- list.files("./bams", pattern = "\\.BAM$", full.names = TRUE)
samples

# Voor elk monster: sorteer en indexeer de BAM-file
# Sorteer BAM-bestanden
lapply(samples, function(s) {sortBam(file = s, destination = paste0(s, '.sorted'))
})

# Index the bam files
samples <- list.files("./bams", pattern = "\\.sorted.bam$", full.names = TRUE) #Pak de juiste files
samples
lapply(samples, function(s) {indexBam(file = s, destination = paste0(s, '.sorted'))
})

df_list <- list(align.ctrl1, align.ctrl2, align.ctrl3, align.ctrl4,
                align.ra1, align.ra2, align.ra3, align.ra4)
Reduce(function(x, y) merge(x, y, all=TRUE), df_list)
