#' Repeat object column-wise and row-wise
#'
#' @param obj An object to be repeated (a matrix, a vector, ...).
#' @param n (vector of 2 integers | integer) a number of repetitions
#'          row-wise and column-wise. If one integer may be indicated, it is
#'          treated as \code{nrows}.
#' @param ncols (integer) a number of repetitions column-wise. Ignored if
#'              second element of \code{n} is provided.
#' @param nrows (integer) a number of repetitions row-wise. Ignored if
#'              \code{n} is provided.
#'
#'
#' @return The same object, repeated column-wise and row-wise.
#' @export
#'
#' @examples
#' library(spMisc)
#'
#' M <- matrix(1:4,2,2)
#'
#' # These pairs of functions do the same:
#'      rep_mat(M, c(2,3))
#'      rep_mat(M, 2, 3)
#'
#'      rep_mat(M, ncols = 2)
#'      rep_cols(M, 2)
#'
#'      rep_mat(M, nrows = 2)
#'      rep_rows(M, 2)
#'
rep_mat <- function(obj, n = c(nrows, ncols), ncols = 1, nrows = 1) {

    switch(as.character(length(n)),
           "1" = {
               n_rows = n[1]
               n_cols = ncols
           },
           "2" = {
               n_rows = n[1]
               n_cols = n[2]
           },
           stop(paste("Length of `n`=", length(n), ", must be either 1 or 2."))
    )

    obj  %>%
        rep_rows(nrows = n_rows) %>%
        rep_cols(ncols = n_cols)
}

#' @rdname rep_mat
#' @export
# repeat n times row-wise
rep_cols <- function(obj, ncols = 1) {do.call("cbind", rep(list(obj), ncols))}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @rdname rep_mat
#' @export
# repeat n times row-wise
rep_rows <- function(obj, nrows = 1) {do.call("rbind", rep(list(obj), nrows))}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
