#' [+] Matrix: calculate number of elements in a lower/upper triangle
#'
#' Calculate a number of elements in a lower/upper triangle of a symmetric
#' matrix of size n*n when n is given.
#'
#' @details
#' nCoeff = (n^2-n)/2, thus
#' n = (1+sqrt(1+8*nCoeff))/2
#'
#' @param n A number of diagonal elements in a symmetric matrix.
#'
#' @return A number of elements in a lower/upper triangle of a matrix
#'         (excluding the diagonal).
#' @export
#' @family matrix operations in \pkg{spHelper}
#' @examples
#'
#' nDiag2nTri(5)
#' nDiag2nTri(7)
#'
#' @author Vilmantas Gegzna
#'
nDiag2nTri <- function(n)  {nTri = (n ^ 2 - n)/2; return(nTri)}
# the same as #nTri = 0; for (i in (1:n)-1) nTri <- nTri + i;


# ================================================================================================

