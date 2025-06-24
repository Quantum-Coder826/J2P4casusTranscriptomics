# Auteur: Berend Veldthuis
# Functie: Dit script neemt de count_matrix en produceert de met een dds analyse de
# log2Foldanges + alle relevante informatie.
# Genereert wat metadata oever hoeveel significante genen gevonden zijn 
# En produceert de Volcanoplot

library(tidyverse)
library(readr)
library(DESeq2)
library(EnhancedVolcano)
library(pathview)

## Statestiek
#prep de data
countmatrix <- read.delim("./results/count_matrix_all_data.txt", row.names = 1, sep = "\t")
countmatrix <- round(countmatrix) # We willen geen decimalen

# Bouw het datastuctuure dat DESeq2 nodig heeft om data analyse uit te voeren
treatment <- c("Control","Control","Control","Control",
               "Reuma","Reuma","Reuma","Reuma") # Tot welke groep behoort de sample
treatment_table <- data.frame(treatment)
rownames(treatment_table) <- c("SRR4785819","SRR4785820","SRR4785828","SRR4785831",
                               "SRR4785979","SRR4785980","SRR4785986","SRR4785988") # Hoe de samples the heeten
# Maak DESeqDataSet aan
dds <- DESeqDataSetFromMatrix(countData = countmatrix,
                              colData = treatment_table,
                              design = ~ treatment)

# Voer analyse uit
dds <- DESeq(dds)
resultaten <- results(dds)

# Resultaten opslaan in een bestand
#Bij het opslaan van je tabel kan je opnieuw je pad instellen met `setwd()` of het gehele pad waar je de tabel wilt opslaan opgeven in de code.

write.table(resultaten, file = './results/dds_resultaten.csv', row.names = TRUE, col.names = TRUE)

## Restultaten sammenvatten
# Van hoeveel genen stijgt/daalt de expressie signifikant
sum(resultaten$padj < 0.05 & resultaten$log2FoldChange > 1, na.rm = TRUE)
sum(resultaten$padj < 0.05 & resultaten$log2FoldChange < -1, na.rm = TRUE)

# Welke zijn interesant
hoogste_fold_change <- resultaten %>%
  na.omit() %>% # Er zitten NA's in de data die zijn nutteloos.
  filter(padj < 0.05) %>%
  arrange(desc(log2FoldChange))
head(hoogste_fold_change, 10)

laagste_fold_change <- resultaten %>%
  na.omit() %>% # Er zitten NA's in de data die zijn nutteloos.
  filter(padj < 0.05) %>%
  arrange(log2FoldChange)
head(laagste_fold_change, 10)

laagste_p_waarde <- resultaten %>%
  na.omit() %>% # Er zitten NA's in de data die zijn nutteloos.
  arrange(padj)
head(laagste_p_waarde, 10)


# Volcano plots
EnhancedVolcano(resultaten,
                lab = rownames(resultaten),
                x = 'log2FoldChange',
                y = 'padj')

# save de data
dev.copy(png, './results/VolcanoplotWC.png',
         width = 8,
         height = 10,
         units = 'in',
         res = 500)
dev.off()

saveRDS(resultaten, "./results/dds_results.rds")
