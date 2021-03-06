#' GOTerm analysis functions
#'
#' @note \code{GOTerm}
#' 
#' @export
#' @import org.Hs.eg.db
#' @import annotate
#' @import AnnotationDbi
#' @importFrom DOSE enrichDO
#' 
#' @note \code{getGeneList}
#' symobol to ENTREZ ID conversion
#' @param genes, gene list
#' @return ENTREZ ID list
#' 
#' @examples
#'    x <- getGeneList(c('OCLN', 'ABCC2'))
#'    

getGeneList <- function(genes) {
    ll <- org.Hs.egSYMBOL2EG
    # Get the entrez gene identifiers that are mapped to a gene symbol
    mapped_genes <- mappedkeys(ll)
    upg <- unique(mapped_genes[toupper(mapped_genes) %in% toupper(genes)])
    # Convert to a list
    genelist <- rapply(cbind(as.list(ll[upg])), c)
}


#' getEnrichGO
#'
#' @note \code{getEnrichGO}
#' @param genelist, gene list
#' @param pvalueCutoff, p value cutoff
#' @param organism, the organism used
#' @param ont, the ontology used
#' @return Enriched GO
#' @examples
#'    genelist<-getGeneList(c('OCLN', 'ABCC2'))
#'    x <- getEnrichGO(genelist)
#'    
#' @export
#' 
 
getEnrichGO <- function(genelist, pvalueCutoff = 0.01,
    organism = "human", ont="CC") {
        res <- c()
        res$enrich_p <- enrichGO(gene = genelist, organism = organism,
            ont = ont, pvalueCutoff = pvalueCutoff,
            readable = TRUE)

        res$p <- barplot(res$enrich_p, title = paste("Enrich GO", ont),
            font.size = 12)
        res
}

#' getEnrichKEGG
#'
#' @note \code{getEnrichKEGG}
#' @param genelist, gene list
#' @param pvalueCutoff, the p value cutoff
#' @return Enriched KEGG
#' @examples
#'    genelist<-getGeneList(c('OCLN', 'ABCC2'))
#'    x <- getEnrichKEGG(genelist)
#'    
#' @export
#' 

getEnrichKEGG <- function(genelist, pvalueCutoff = 0.01) {
    res <- c()
    res$enrich_p <- enrichKEGG(gene = genelist, organism = "human",
        pvalueCutoff = pvalueCutoff, readable = TRUE,
        use_internal_data = TRUE)
    res$p <- barplot(res$enrich_p, title = paste("KEGG Enrichment: p-value=",
        pvalueCutoff))
    res
}

#' clusterData
#'
#' @note \code{clusterData}
#' @param dat, the data to cluster
#' @return clustered data
#' @examples
#'    mycluster <- clusterData(mtcars)
#'    
#' @export
#' 
clusterData <- function(dat) {
    ret <- list()
    itemlabels <- rownames(dat)
    norm_data <- getNormalizedMatrix(dat)
    mydata <- na.omit(norm_data)  # listwise deletion of missing
    mydata <- scale(mydata)  # standardize variables

    wss <- (nrow(mydata) - 1) * sum(apply(mydata, 2, var))
    for (i in 2:15) wss[i] <- sum(kmeans(mydata, centers = i)$withinss)
    plot(1:15, wss, type = "b",
         xlab = "Number of Clusters",
         ylab = "Within groups sum of squares")
    k <- 0
    for (i in 1:14) {
        if ( ( wss[i] / wss[i + 1] ) > 1.2 ) {
            k <- k + 1
        }
    }
    # K-Means Cluster Analysis
    fit <- kmeans(mydata, k)  # 5 cluster solution
    # get cluster means
    aggregate(mydata, by = list(fit$cluster), FUN = mean)
    # append cluster assignment
    mydata_cluster <- data.frame(mydata, fit$cluster)

    # distance <- dist(mydata, method = 'euclidean')
    # distance matrix fit <- hclust(distance,
    # method='ward.D2') plot(fit, cex = 0.1)
    # display dendogram groups <- cutree(fit, k=k) rect.hclust(fit,
    # k=k, border='red')
    return(mydata_cluster)
}


#' compareClust
#'
#' @note \code{compareClust}
#' @param dat, data to compare clusters
#' @param ont, the ontology to use
#' @param organism, the organism used
#' @param fun, fun
#' @param title, title of the comparison
#' @return compared cluster
#' @examples
#'    genelist<-getGeneList(c('OCLN', 'ABCC2'))
#'    x <- getEnrichDO(genelist)
#'    
#' @export
#' 

compareClust <- function(dat = NULL, ont = "CC", organism = "human",
    fun = "enrichGO", title = "Ontology Distribution Comparison") {
        if (is.null(dat)) return(NULL)
        genecluster <- list()
        k <- max(dat$fit.cluster)
        for (i in 1:k) {
            clgenes <- rownames(dat[dat$fit.cluster == i, ])
            genelist <- getGeneList(clgenes)
            genecl <- list()
            genecl <- push(genecl, genelist)
            genecluster[c(paste("X", i, sep = ""))] <- genecl
        }

        p <- tryCatch({
            title <- paste(fun, title)
            xx <- c()
            if (fun == "enrichKEGG" || fun == "enrichPathway")
                xx <- compareCluster(genecluster, fun = fun,
                                   organism = organism)
            else if (fun == "enrichDO")
                xx <- compareCluster(genecluster, fun = fun) 
            else {
                xx <- compareCluster(genecluster, fun = fun,
                    organism = organism, ont = ont)
                title <- paste(ont, title)
            }
            p <- plot(xx, title = title)
            p
        })
        p
}

#' getEnrichDO
#'
#' @note \code{getEnrichDO}
#' @param genelist, gene list
#' @param pvalueCutoff, the p value cutoff
#' @return enriched DO
#' @examples
#'    genelist<-getGeneList(c('OCLN', 'ABCC2'))
#'    x <- getEnrichDO(genelist)
#'    
#' @export
#' 
getEnrichDO <- function(genelist, pvalueCutoff = 0.01) {
    res <- c()
    res$enrich_p <- enrichDO(gene = genelist, ont = "DO",
        pvalueCutoff = pvalueCutoff, readable = TRUE)

    res$p <- barplot(res$enrich_p, title = "Enrich DO", font.size = 12)
    res
}
