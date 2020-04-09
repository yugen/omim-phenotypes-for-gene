library(httr)

# Set the base url for the OMIM API
baseUrl = 'https://api.omim.org/api/'
#OMIM API KEY
omimKey = Sys.getenv("OMIM_KEY")

baseQueryParams = list(
    c('format', 'json')
)

# Function combine 1x2 vector into http request param
concatKeyVal = function (v) {
    return (paste(v,collapse="="))
}

# Function to create a function to build our url for us
buildUrl = function (endpoint, params=list()) {
    queryParams = append(baseQueryParams, params)
    if (length(queryParams) > 0) {
        paramStrings = lapply(queryParams, concatKeyVal)
        queryString = paste(paramStrings, collapse='&')
        return(paste(baseUrl, endpoint, '?', queryString, sep=""));
    }
    return(paste(baseUrl, endpoint, sep=""));
}

# Function to search for a gene by symbol and return the geneMap
getGeneMap = function (gene) {
    searchTerm = paste('approved_gene_symbol:', gene, sep="");
    url = buildUrl('entry/search', list(c('search',searchTerm), c('include','geneMap')))

    omimRsp = GET(url, add_headers('apiKey'=omimKey), accept_json())
    
    data = content(omimRsp, type="application/json");
    
    return(data$omim$searchResponse$entryList[[1]]$entry$geneMap);
}

geneList <- read.csv('./genes.csv')
v = as.vector(geneList[ ,1])

# initialize container list
genePhenoMaps = list()
# initialize counter
i = 1
for(gene in v) {
    geneMap = getGeneMap(gene)
    phenoMap = geneMap$phenotypeMapList;
    
    # For each phenotype in the phenotype map
    # assemble a list with the data we want
    # and add it to the container list
    for(pheno in phenoMap) {
        outputList = list(
            gene=gene,
            gene_mim_number=geneMap$mimNumber,
            phenotype=pheno$phenotype$phenotype,
            inheritance_pattern=pheno$phenotype$phenotypeInheritance
        )
        genePhenoMaps[[i]] = outputList
        i = i+1
    }
}

# Write the container list to a csv file; 
# omit column names b/c they get written with every line
lapply(genePhenoMaps, function(x) write.table( data.frame(x), 'phenotypes.csv'  , append= T, sep=',',col.names=FALSE ))