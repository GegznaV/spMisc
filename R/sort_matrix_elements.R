#' @name sort_matrix_elements
#' @title Sort rows and columns of a matrix according to a criterion
#'
#' @description
#' \code{sort_descOnDiag()}  where possible, sort rows and columns of a matrix
#' to put the highest values on diagonal in a descending order. The highest
#' value is paced at the top left corner.
#'
#' \code{sort_colSums()} sorts columns of a matrix according to the values of column sums.\cr
#' \code{sort_colMax()} sorts columns of a matrix according to the maximum value in each column.\cr
#'
#' \code{sort_rowSums()} sorts rows of a matrix according to the values of row sums.\cr
#' \code{sort_rowMax()} sorts rows of a matrix according to the maximum value in each row.\cr
#'
#' Possible application: in a cluster analysis sort rows and columns of a cross
#' tablation by the best match (illustration in section "Expamples"). \cr
#'
#' @param M A matrix.
#' @param importance Numecic value (either 1 for rows or 2 for columns) which is used
#'        to resolve ties when 2 equally important matches are found (i.e., when
#'        absolute values are equal). If \code{importance = 1}, the element's
#'        importance is calculated by row-wise proportions, if \code{importance = 2}
#'        - by column-wise proportions.
#'         Element with higher proportional value is selected as having higher
#'         priority.
#' @param na.rm	Logical. Should missing values (including NaN) be omitted from
#'        the calculations?
#' @param decreasing Logical. Should the sort be decreasing?
#' @export
#'
#'
#' @seealso \code{\link[base]{order}}, \code{\link[base]{sort}}.
#' @examples
#' library(spMisc)
#'
#' # Create matrix
#' M0 <- matrix(c(0, 11,8, 0,
#'                12,0, 0, 0,
#'                0, 0, 0, 9,
#'                0, 0, 9, 0,
#'                0, 0, 1, 0),byrow=TRUE,nc=4)
#'
#' # Give names for rows and columns
#' M0 <- pkgmaker::addnames(M0)
#'
#' # Sort and print
#' M0
#' sort_descOnDiag(M0)
#' sort_colSums(M0)
#' sort_rowSums(M0)
#' sort_colMax(M0)
#' sort_rowMax(M0)
#'
#' # Application in cluster analysis ==========================================
#' set.seed(1)
#' Clusters <- kmeans(iris[,-5], 3)$cluster
#' Species <- iris$Species
#'
#' # Regular cross tabulation
#' TABLE <- table(Species, Clusters)
#' TABLE
#'
#' ##                Clusters
#' ##  Species       1  2  3
#' ##  setosa       50  0  0
#' ##  versicolor    0  2 48
#' ##  virginica     0 36 14
#'
#' # Arranged by the best match
#' TABLE_best_match <- sort_descOnDiag(TABLE)
#' TABLE_best_match
#'
#' ##              Clusters
#' ##  Species       1  3  2
#' ##  setosa       50  0  0
#' ##  versicolor    0 48  2
#' ##  virginica     0 14 36
#'
#' #------------------------------------------------------------------
#' # Parameter `importance` for proportional importance:
#'
#'  #>
#' Matrix <- matrix(c(3,0,0,2,3,0,0,0,5),3,3)
#' Matrix <- pkgmaker::addnames(Matrix)
#'  #>          col1 col2 col3
#'  #>   row1    3    2    0
#'  #>   row2    0    3    0
#'  #>   row3    0    0    5
#'
#' # Row-wise importance
#' Matrix_by_row <- sort_descOnDiag(Matrix, importance = 1)
#' Matrix_by_row
#'  #>          col3 col2 col1
#'  #>   row3    5    0    0
#'  #>   row2    0    3    0
#'  #>   row1    0    2    3  <---- 2 is in row 3
#'
#' # Column-wise importance
#' Matrix_by_col <- sort_descOnDiag(Matrix, importance = 2)
#' Matrix_by_col
#'  #>          col3 col1 col2
#'  #>   row3    5    0    0
#'  #>   row1    0    3    2  <---- 2 is in row 2
#'  #>   row2    0    0    3
#'
#'
#' @author Vilmantas Gegzna
#' @family matrix operations in \pkg{spMisc}
#'
sort_descOnDiag <- function(M, importance = which.min(dim(M)), na.rm = TRUE) {

    # Eliminate rows and columns by converting to `NA`
    RC.elim <- function(x) {
        x[mxRow,] <- NA;
        x[,mxCol] <- NA;
        return(x)
    }

    n    <- min(dim(M), na.rm = na.rm)
    iCol <- iRow <- rep(NA, n)
    iM   <- indMatrix(M)

    P <- prop.table(M, importance) # table of proportions

    Rows <- row(M)
    Cols <- col(M)
    y <- M

    # If NA exists, prevent function from crash:
    # Replace NA's with a value that is smaller than
    # the smallest non NA value

    # y_min <- min(y, na.rm = na.rm)
    y[is.na(y)] <- min(y, na.rm = na.rm)-1

    #In each cycle find best match and eliminate rows and columns of that match
    for (i in 1:n) {
        ind <- iM[y == max(y, na.rm = na.rm)]
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


#' @name sort_matrix_elements
#' @export
sort_colSums <- function(M, decreasing = TRUE, na.rm = TRUE){
    ind <- colSums(M, na.rm = na.rm) %>% order(decreasing = decreasing)
    M[,ind]
}

#' @name sort_matrix_elements
#' @export
sort_rowSums <- function(M, decreasing = TRUE, na.rm = TRUE){
    ind <- rowSums(M, na.rm = na.rm)  %>% order(decreasing = decreasing)
    M[ind,]
}

#' @name sort_matrix_elements
#' @export
sort_rowMax <- function(M, decreasing = TRUE, na.rm = TRUE){
    MAX <- function(x){base::max(x, na.rm = na.rm)}
    ind <- apply(M,1,MAX)  %>% order(decreasing = decreasing)
    M[ind,]
}

#' @name sort_matrix_elements
#' @export
sort_colMax <- function(M, decreasing = TRUE, na.rm = TRUE){
    MAX <- function(x){base::max(x, na.rm = na.rm)}
    ind <- apply(M,2,MAX) %>% order(decreasing = decreasing)
    M[,ind]
}


