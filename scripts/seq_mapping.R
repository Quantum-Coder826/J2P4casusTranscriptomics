library(Rsubread)
library(Rsamtools)

# Map de E.coli RefSeq
buildindex(
  basename = './RefSeqEColi/E_Coli',
  reference = './RefSeqEColi/GCF_000005845.2_ASM584v2_genomic.fna',
  memory = 8000, # use 8gig of ram
  indexSplit = TRUE)

# Ethanol monsters
align.eth1 <- align(index = "./RefSeqEColi/E_Coli", 
                    readfile1 = "./dataset/SRR8394576_ethanol_12h_1.fasta.gz", 
                    output_file = "./bams/eth1.BAM")

align.eth2 <- align(index = "./RefSeqEColi/E_Coli", 
                    readfile1 = "./dataset/SRR8394577_ethanol_12h_2.fasta.gz", 
                    output_file = "./bams/eth2.BAM")

align.eth2 <- align(index = "./RefSeqEColi/E_Coli", 
                    readfile1 = "./dataset/SRR8394578_ethanol_12h_3.fasta.gz",
                    output_file = "./bams/eth3.BAM")

# Control monsters
align.ctrl <- align(index = "./RefSeqEColi/E_coli",
                    readfile1 = "./dataset/SRR8394612_control_12h_1.fasta.gz",
                    output_file = "./bams/ctrl1.BAM")

align.ctrl <- align(index = "./RefSeqEColi/E_coli",
                    readfile1 = "./dataset/SRR8394613_control_12h_2.fasta.gz",
                    output_file = "./bams/ctrl2.BAM")

align.ctrl <- align(index = "./RefSeqEColi/E_coli",
                    readfile1 = "./dataset/SRR8394614_control_12h_3.fasta.gz",
                    output_file = "./bams/ctrl3.BAM")

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
