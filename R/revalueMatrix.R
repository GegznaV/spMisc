#' Create matrix of the same size just with new values
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
#'
#'  x
#'  revalueMatrix(x, 1:10)
#'
#' @family matrix operations in \pkg{spMisc}
#' @author Vilmantas Gegzna

revalueMatrix <- function(x, values = NA, byrow = FALSE,
                       dimnames = NULL) {
    x      <- as.matrix(x)
    dims   <- dim(x)
    m      <- matrix(values,nrow = dims[1],ncol = dims[2], byrow, dimnames)
    return(m)
}


# #' @rdname revalueMatrix
# #' @export
# newMatrix <- function(x, values = NA, byrow = FALSE,
#                       dimnames = NULL) {
#     .Deprecated("revalueMatrix")
#     revalueMatrix(x, values, byrow, dimnames)
# }
