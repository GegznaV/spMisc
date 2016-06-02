#' [+] Matrix: length of diagonal when a number of elements in a lower/upper triangle is given
#'
#' Calculate a number of diagonal elements of a symmetric matrix when a number
#' elements in a lower/upper triangle is given.
#'
#' @details Dedived from equation nCoeff = (n^2-n)/2
#' @param nTri A number of elements in a lower/upper triangle of a matrix (excluding the diagonal).
#'
#' @return A number of rows/columns in a symmetric matrix. May be a fractional number.
#' @export
#' @family matrix operations in \pkg{spHelper}
#' @author Vilmantas Gegzna
#' @examples
#' nTri2nDiag(10)
#' nTri2nDiag(6)
#'
nTri2nDiag <- function(nTri) {n <- (1 + sqrt(1 + 8 * nTri)) / 2; return(n)}
