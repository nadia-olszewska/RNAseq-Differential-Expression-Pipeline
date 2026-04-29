# RNA-seq Differential Expression Pipeline

## Opis Projektu
Automatyczny potok (pipeline) do analizy różnicowej ekspresji genów na podstawie danych RNA-seq. Projekt obejmuje kroki od surowych zliczeń (counts) po wizualizację wyników.

### Wykorzystane Technologie
* **R / Bioconductor** (DESeq2, AnnotationDbi)
* **Docker** (konteneryzacja środowiska)
* **WSL** (środowisko pracy)

## Struktura Projektu
* `data/` - dane wejściowe (w tym przypadku zestaw `airway`)
* `results/` - wyniki analizy (CSV z adnotacją, Volcano Plot)
* `scripts/` - skrypt analizy R
* `Dockerfile` - definicja środowiska

## Jak uruchomić projekt?
Projekt jest w pełni skonteneryzowany, co gwarantuje reprodukowalność wyników.

1. **Budowanie obrazu:**
   docker build -t rnaseq_env .

2. **Uruchomienie analizy**
    docker run --rm -v $(pwd):/home/analysis rnaseq_env Rscript scripts/analysis.R