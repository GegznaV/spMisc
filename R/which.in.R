#' @name which.in
#' @aliases which.in
#' @aliases which.in.diag
#' @aliases which.in.offdiag
#' @aliases which.in.col
#' @aliases which.in.row
#' @aliases which.in.trilow
#' @aliases which.in.triupp
#'
#' @title [+] Get indices of certain matrix elements
#'
#' @description Get indices of certain (e.g., diagonal) matrix elements.
#' These elements can be in:
#' \enumerate{
#'  \item{\emph{diag} - diagonal;}
#'  \item{\emph{offdiag} - offdiagonal;}
#'  \item{\emph{col} - indicated columns;}
#'  \item{\emph{row} - indicated rows;}
#'  \item{\emph{trilow} - lower triangle (with or without diagonal);}
#'  \item{\emph{triupp} - upper triangle (with or without diagonal).}
#' }
#'
#' @param x A matrix or an object, which can be coerced to a marix.
#' @param type Either \code{diag}, \code{offdiag},
#'  \code{col}, \code{row}, \code{trilow} or \code{triupp}
#'  (just for \code{which.in()}).
#' @param ... Other appropriate parameters indicated below.
#'
#' @return Indices of indicated elements of a matrix.
#' @export
#'
#' @examples
#'
#' m1 <- matrix(NA, 5, 5)
#' m1
#'
#'  #>        [,1] [,2] [,3] [,4] [,5]
#'  #>  [1,]   NA   NA   NA   NA   NA
#'  #>  [2,]   NA   NA   NA   NA   NA
#'  #>  [3,]   NA   NA   NA   NA   NA
#'  #>  [4,]   NA   NA   NA   NA   NA
#'  #>  [5,]   NA   NA   NA   NA   NA
#'
#' which.in.diag(m1)
#'  #>  [1]  1  7 13 19 25
#'
#' m2 <- matrix(NA, 2, 5)
#' which.in.diag(m2)
#'  #>  [1]  1  4
#'
#' #================================
#'
#'  which.in(diag,    m1)
#'  which.in(offdiag, m1)
#'
#'  which.in(col, m1, col = 2)
#'  which.in(row, m1, row = 2)
#'
#'  which.in(trilow, m1)
#'  which.in(trilow, m1, diag = TRUE)
#'
#'  which.in(triupp, m1)
#'
#' @family matrix operations in \pkg{spHelper}
#' @author Vilmantas Gegzna

which.in <- function(type, x,  ...){
    type <- as.character(match.call()$type)
    ind  <- switch(type,
                 diag    = which.in.diag(x, ...) ,
                 offdiag = which.in.offdiag(x, ...) ,
                 col     = which.in.col(x, ...) ,
                 row     = which.in.row(x, ...) ,
                 trilow  = which.in.trilow(x, ...) ,
                 triupp  = which.in.triupp(x, ...)
    )
    return(ind)
}

# ========================================================================
#' @rdname which.in
#' @export
which.in.diag <- function(x){
    m      <- indMatrix(x)
    ind.d  <- diag(m)
    return(ind.d)
}

# ========================================================================
#' @rdname which.in
#' @export
which.in.offdiag <- function(x){
    m      <- indMatrix(x)
    ind.d  <- diag(m)
    ind.o  <- setdiff(m, ind.d)
    return(ind.o)
}


# ========================================================================
#' @rdname which.in
#' @export
#' @param col An index/Indices of columns that contain elements of interest.
which.in.col <- function(x, col){
    m      <- indMatrix(x)
    ind.c  <- as.vector(m[,col])
    return(ind.c)
}

# ========================================================================
#' @rdname which.in
#' @export
#' @param row An index/Indices of rows that contain elements of interest.
which.in.row <- function(x, row){
    m      <- indMatrix(x)
    ind.r  <- as.vector(m[row,])
    return(ind.r)
}

# ========================================================================
#' @rdname which.in
#' @export
#' @inheritParams base::lower.tri
which.in.trilow <- function(x, diag = FALSE){
    m      <- indMatrix(x)
    ind.l  <- m[lower.tri(m, diag = diag)]
    return(ind.l)
}

# ========================================================================
#' @rdname which.in
#' @export
which.in.triupp <- function(x, diag = FALSE){
    m      <- indMatrix(x)
    ind.u  <- m[upper.tri(m, diag = diag)]
    return(ind.u)
}

# ========================================================================
