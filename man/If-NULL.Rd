% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/4_operators.R
\name{If NULL}
\alias{If NULL}
\alias{\%if_null\%}
\title{Infix operator to insert default value if result is NULL}
\usage{
a \%if_null\% b
}
\arguments{
\item{a}{An expression.}

\item{b}{An alternative}
}
\value{
If \code{!is.null(a)} is \code{TRUE} returns \code{a} otherwise
        returns \code{b}.
}
\description{
The function is useful as a way of providing a default value
 in case the output of another function is \code{NULL}.
}
\examples{
a1 <- "Default value"
a2 <- NULL
b  <- "Alternative"

 a1 \%if_null\% b
#> [1] "Default value"

 a2 \%if_null\% b
#> "Alternative"

}
