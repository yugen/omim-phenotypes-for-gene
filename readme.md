## Description
An R script for grabbing phenotype data for a list of genes from OMIM's API

## Setup & Usage
1. Add approved HGNC gene symbols to genes.csv (1 per row)
2. Set your OMIM API Key in your `.Renviron`: 
    1. on the command line enter `echo 'OMIM_KEY="your-api-key"' >> ~/.Renviron`, replacing "your-api-key" with yoru actual OMIM API key .  If you don't already have a .Renviron file this will create one; if you already have one it will add it to your file.
    2. Check that it worked: in R type `Sys.getenv("OMIM_KEY")`.  You should see your key.
3. On the command line (or wherever you run R scripts) run `Rscript getPhenotypesForGenes.r`