#' [!!!] Sort rows and columns of a matrix
#'
#' @param M A matrix.
#'
#' @export
#'
#' @examples
#' library(spMisc)
#'
#' M0 <- matrix(c(0, 11,8, 0,
#'                12,0, 0, 0,
#'                0, 0, 0, 9,
#'                0, 0, 9, 0),byrow=TRUE,nc=4)
#' M0 <- pkgmaker::addnames(M0)
#'
#' M0
#' sort_DescOnDiag(M0)
#' sort_colSums(M0)
#' sort_rowSums(M0)
#' sort_maxValueInRow(M0)
#' sort_maxValueInCol(M0)
#'
#'
#'
#' M1 <- sort_DescOnDiag(M0)
#' print(M0)
#' print(M1)
#'
#'
#'
#' @author Vilmantas Gegzna
#' @family matrix operations in \pkg{spHelper}
#'
sort_DescOnDiag <- function(M) {

    # Eliminate rows and columns by converting to `NA`
    RC.elim <- function(x) {
        x[mxRow,] <- NA;
        x[,mxCol] <- NA;
        return(x)
    }

    n    <- min(dim(M), na.rm = TRUE)
    iCol <- iRow <- rep(NA, n)
    iM   <- indMatrix(M)

    P <- prop.table(M, which.min(dim(M))) # table of proportions

    Rows <- row(M)
    Cols <- col(M)
    y <- M

    # If NA exists, prevent function from crash:
    # Replace NA's with a value that is smaller than
    # the smallest non NA value

    y_min <- min(y, na.rm = TRUE)
    y[is.na(y)] <- min(y, na.rm = TRUE)-1

    #In each cycle find best match and eliminate rows and columns of thar match
    for (i in 1:n) {
        ind <- iM[y == max(y, na.rm = T)]
        ind <- ind[!is.na(ind)]

        #if there are several maxima, chose (first) one with greater row/column values
        if (length(ind) > 1) {ind <- ind[which.max(P[ind])][1]}

        mxRow <- Rows[ind]
        mxCol <- Cols[ind]

        iRow[i] = mxRow
        iCol[i] = mxCol

        y <- RC.elim(y)
    }

    iRow <- c(iRow, setdiff(1:nrow(y), iRow))
    iCol <- c(iCol, setdiff(1:ncol(y), iCol))

    M1 <- M[iRow,iCol]

    return(M1)
}


#' @rdname sort_DescOnDiag
#' @export
sort_colSums <- function(M){
    ind <- colSums(M)  %>% order(decreasing = TRUE)
    M[,ind]
}

#' @rdname sort_DescOnDiag
#' @export
sort_rowSums <- function(M){
    ind <- rowSums(M)  %>% order(decreasing = TRUE)
    M[ind,]
}

#' @rdname sort_DescOnDiag
#' @export
sort_maxValueInRow <- function(M){
    ind <- apply(M,1,max)  %>% order(decreasing = TRUE)
    M[ind,]
}

#' @rdname sort_DescOnDiag
#' @export
sort_maxValueInCol <- function(M){
    ind <- apply(M,2,max) %>% order(decreasing = TRUE)
    M[,ind]
}


