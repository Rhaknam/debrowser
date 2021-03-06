% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/all2all.R
\name{panel.smoothScatter}
\alias{panel.smoothScatter}
\title{Smoothes the scatterplot for the all2all plot.}
\usage{
panel.smoothScatter(x, y, ...)
}
\arguments{
\item{x, }{x coordinates}

\item{y, }{y coordinates}

\item{..., }{any additional params}
}
\value{
all2all smoothed scatter plots
}
\description{
Smoothes the scatterplot for the all2all plot.
}
\examples{
  n   <- 10000
  x1  <- matrix(rnorm(n), ncol = 2)
  x2  <- matrix(rnorm(n, mean = 3, sd = 1.5), ncol = 2)
  x   <- rbind(x1, x2)
  y   <- rbind(x2, x1)
  panel.smoothScatter(x, y)

}

