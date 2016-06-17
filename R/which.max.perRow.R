#' [!] Indices of maximum values in each row/column
#'
#' @param x A matrix
#' @inheritParams base::min
#'
#' @export
#' @author Vilmantas Gegzna
#' @family matrix operations in \pkg{spMisc}

which.max.perRow <- function(x, na.rm = FALSE) {
    M <- indMatrix(x)
    n <- nrow(x)
    ind <- vector("list", n)
    for (indR in 1:n) {
        indC      <- which.max.all(x[indR,], na.rm = na.rm)
        ind[[indR]] <- M[indR,indC]
    }
    return(unlist(ind))
}

#' @rdname which.max.perRow
#' @export
which.max.perCol <- function(x, na.rm = FALSE) {
    M <- indMatrix(x)
    n <- ncol(x)
    ind <- vector("list", n)
    for (indC in 1:n) {
        indR      <- which.max.all(x[,indC], na.rm = na.rm)
        ind[[indC]] <- M[indR,indC]
    }
    return(unlist(ind))
}
