FROM rocker/tidyverse:4.3.0

RUN apt-get update && apt-get install -y     libxml2-dev     libxt-dev     zlib1g-dev     libbz2-dev     liblzma-dev

RUN R -e "install.packages('BiocManager', repos='http://cran.rstudio.com/')"
RUN R -e "BiocManager::install(c('DESeq2', 'pheatmap', 'ggplot2', 'EnhancedVolcano', 'AnnotationDbi', 'org.Hs.eg.db'))"
WORKDIR /home/analysis
