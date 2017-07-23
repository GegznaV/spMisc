
#' Find rows and columns in which all values are NA's
#'
#' @param x A data frame or a matrix.
#'
#' @return A logical vector with rows/columns in which all values are
#' \code{NA} indicated as \code{TRUE}.
#' @export
#'
#' @examples
#'
#'  x <- matrix(c(NA, 1, 2, NA, 3, 4, NA, NA, NA), nrow = 3)
#'  x
#'  all_na_rows(x)
#'
#'  all_na_columns(x)
#'
#'
all_na_rows <- function(x) {
    rowSums(is.na(x)) == ncol(x)
}

#' @rdname all_na_rows
#' @export
all_na_columns <- function(x) {
    colSums(is.na(x)) == nrow(x)
}
