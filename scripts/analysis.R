# 0. Ładowanie bibliotek
library(DESeq2)
library(ggplot2)
library(EnhancedVolcano)
library(AnnotationDbi)
library(org.Hs.eg.db)

# 1. Pobieranie danych
message("Pobieranie danych...")
if (!requireNamespace("airway", quietly = TRUE)) BiocManager::install("airway")
data(airway, package="airway")

# 2. Przygotowanie obiektu DESeqDataSet
dds <- DESeqDataSet(airway, design = ~ dex)

# 3. Pre-filtering
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]

# 4. Główna analiza statystyczna (Normalizacja + Estymacja rozproszenia + Test Walda)
dds <- DESeq(dds)

# 5. Pobieranie wyników
res <- results(dds, contrast=c("dex", "trt", "untrt"))

# --- 6. ADNOTACJA ---
message("Adnotacja genów: Mapowanie Ensembl na Symbole...")

# Dodajemy kolumnę z czytelną nazwą genu
res$symbol <- mapIds(org.Hs.eg.db,
                     keys=rownames(res),
                     column="SYMBOL",
                     keytype="ENSEMBL",
                     multiVals="first")

# Dodajemy kolumnę Entrez ID
res$entrez <- mapIds(org.Hs.eg.db,
                     keys=rownames(res),
                     column="ENTREZID",
                     keytype="ENSEMBL",
                     multiVals="first")

# 7. Zapisywanie wyników do pliku CSV
write.csv(as.data.frame(res), file="/home/analysis/results/differential_expression_results.csv")

# 8. Tworzenie wykresu Volcano Plot (z użyciem nazw genów)
message("Generowanie wykresów...")
png("/home/analysis/results/volcano_plot.png", width=800, height=800)

EnhancedVolcano(res,
    lab = res$symbol,
    x = 'log2FoldChange',
    y = 'pvalue',
    title = 'Analiza ekspresji różnicowej: Airway dataset',
    subtitle = 'Porównanie: Lek (trt) vs Kontrola (untrt)',
    pCutoff = 10e-16,
    FCcutoff = 1.5,
    pointSize = 3.0,
    labSize = 6.0)

dev.off()

message("Analiza zakończona! Wyniki zapisano w folderze 'results'.")