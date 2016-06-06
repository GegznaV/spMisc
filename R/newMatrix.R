#' Put new values to the old matrix
#'
#' A convenience function to create a matrix of the same size as the provided one,
#' just with new values.
#'
#' @param x An old matrix.
#' @param values The new values for matrix
#' @inheritParams base::matrix
#' @export
#' @examples
#'
#'  x <- matrix(NA, 2, 5)
#'  newMatrix(x, 1)
#'
#' @family matrix operations in \pkg{spMisc}
#' @author Vilmantas Gegzna
#'
newMatrix <- function(x, values = NA, byrow = FALSE,
                       dimnames = NULL) {
    x      <- as.matrix(x)
    dims   <- dim(x)
    m      <- matrix(values,nrow = dims[1],ncol = dims[2], byrow, dimnames)
    return(m)
}
