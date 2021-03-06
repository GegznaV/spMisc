% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/class_add.R
\name{class_add}
\alias{class_add}
\title{Add new class attributes to an object}
\usage{
class_add(x, new_class)
}
\arguments{
\item{x}{An object}

\item{new_class}{(\code{character})\cr
A character vector with classes to add.}
}
\value{
The same object \code{x} with new classes added.
}
\description{
Add new class attributes to an object
}
\examples{
x <- data.frame()
y <- class_add(x, "meow")
class(y)

# The same class does not repeat if added several times
y2 <- class_add(x, c("meow" , "meow"))
class(y2)
}
