% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_props.R
\name{getToolTipText}
\alias{getToolTipText}
\title{Prepares tooltiptext for the second scatter plot in the plots page}
\usage{
getToolTipText(dat = NULL)
}
\arguments{
\item{dat, }{data need to have following columns; padj, average,
cond1 and cond2 values, log10padj, foldChange}
}
\value{
tooltip text
}
\description{
Prepares tooltiptext for the second scatter plot in the plots page
}
\examples{
 x <- getToolTipText()
 
}

