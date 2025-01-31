# Load libraries
library(DESeq2)
library(ggplot2)
library(dplyr)
library(org.Hs.eg.db)
library(EnhancedVolcano)
library(clusterProfiler)
library(AnnotationDbi)

setwd("C:/Users/ASUS/Documents/Uni/Courses/Semester 3/RNA sequencing/")

# Read the data into a data frame
# -------------------------------
counts_data <- read.table("C:/Users/ASUS/Documents/Uni/Courses/Semester 3/RNA sequencing/featurecounts.Rmatrix.txt", header = TRUE, sep = "\t", quote = "")
head(counts_data)

# Create a DataFrame with metadata
# --------------------------------
sample_names <- colnames(counts_data)[-1] # Extract sample names from column headers

colData <- data.frame(
  sampleName = sample_names,
  group = c(rep("HER2", 3), rep("NonTNBC", 3), rep("Normal", 3), rep("TNBC", 3))
)

# Construct DESeqDataSet Object
# -----------------------------
dds <- DESeqDataSetFromMatrix(countData = counts_data,
                              colData = colData,
                              design = ~ group,
                              tidy = TRUE)

# Run DESeq function
# ------------------
dds <- DESeq(dds)
res <- results(dds)

# Look at the results table
summary(res)

# Plot PCA
# --------
# Perform variance stabilizing transformation (VST)
vsdata <- vst(dds, blind = TRUE)
plotPCA(vsdata, intgroup = "group")

# Save normalized counts
normalized_counts <- counts(dds, normalized = TRUE)

# Count total genes, upregulated, and downregulated genes
res <- as.data.frame(res)
total_genes <- sum(res$padj < 0.05, na.rm = TRUE)
upregulated_genes <- sum(res$log2FoldChange > 0 & res$padj < 0.05, na.rm = TRUE)
downregulated_genes <- sum(res$log2FoldChange < 0 & res$padj < 0.05, na.rm = TRUE)

# Print the counts
cat("Total genes:", total_genes, "\n")
cat("Upregulated genes:", upregulated_genes, "\n")
cat("Downregulated genes:", downregulated_genes, "\n")

# Differential expression analysis for specific contrasts
# -------------------------------------------------------
# TNBC vs HER2
TNBC_HER2 <- as.data.frame(results(dds, contrast = c("group", "TNBC", "HER2")))

# TNBC vs NonTNBC
TNBC_NonTNBC <- as.data.frame(results(dds, contrast = c("group", "TNBC", "NonTNBC")))

# TNBC vs Normal
TNBC_Normal <- as.data.frame(results(dds, contrast = c("group", "TNBC", "Normal")))

# Filter significant genes (adjusted p-value < 0.05)
filtered_TNBC_HER2 <- TNBC_HER2 %>% filter(padj < 0.05)
filtered_TNBC_NonTNBC <- TNBC_NonTNBC %>% filter(padj < 0.05)
filtered_TNBC_Normal <- TNBC_Normal %>% filter(padj < 0.05)

# Add gene symbols to the filtered results
filtered_TNBC_HER2$symbol <- mapIds(org.Hs.eg.db, keys = rownames(filtered_TNBC_HER2), keytype = "ENSEMBL", column = "SYMBOL")
filtered_TNBC_NonTNBC$symbol <- mapIds(org.Hs.eg.db, keys = rownames(filtered_TNBC_NonTNBC), keytype = "ENSEMBL", column = "SYMBOL")
filtered_TNBC_Normal$symbol <- mapIds(org.Hs.eg.db, keys = rownames(filtered_TNBC_Normal), keytype = "ENSEMBL", column = "SYMBOL")

# Save filtered results to CSV
write.csv(filtered_TNBC_HER2, "filtered_TNBC_HER2.csv")
write.csv(filtered_TNBC_NonTNBC, "filtered_TNBC_NonTNBC.csv")
write.csv(filtered_TNBC_Normal, "filtered_TNBC_Normal.csv")

# Volcano Plot for TNBC vs HER2
EnhancedVolcano(filtered_TNBC_HER2,
                lab = filtered_TNBC_HER2$symbol,
                x = 'log2FoldChange',
                y = 'padj',
                title = 'TNBC vs HER2')

# Volcano Plot for TNBC vs NonTNBC
EnhancedVolcano(filtered_TNBC_NonTNBC,
                lab = filtered_TNBC_NonTNBC$symbol,
                x = 'log2FoldChange',
                y = 'padj',
                title = 'TNBC vs NonTNBC')

# Volcano Plot for TNBC vs Normal
EnhancedVolcano(filtered_TNBC_Normal,
                lab = filtered_TNBC_Normal$symbol,
                x = 'log2FoldChange',
                y = 'padj',
                title = 'TNBC vs Normal')

# Functional enrichment analysis with clusterProfiler
# ----------------------------------------------------
enrichment_TNBC_NonTNBC <- enrichGO(
  gene = rownames(filtered_TNBC_NonTNBC),
  universe = rownames(res),
  OrgDb = org.Hs.eg.db,
  keyType = "ENSEMBL",
  ont = "BP",
  pvalueCutoff = 0.05,
  readable = TRUE
)

# Save enrichment results
write.csv(as.data.frame(enrichment_TNBC_NonTNBC), "enrichment_TNBC_NonTNBC.csv")

# Bar plot for enrichment results
barplot(enrichment_TNBC_NonTNBC, showCategory = 10, title = "TNBC vs NonTNBC")

# Save plots
ggsave("volcano_TNBC_HER2.png")
ggsave("volcano_TNBC_NonTNBC.png")
ggsave("volcano_TNBC_Normal.png")
ggsave("barplot_enrichment_TNBC_NonTNBC.png")
