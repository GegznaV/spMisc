#' [!] Get indices of minima/maxima
#'
#' Determines the location, i.e., index of all minimum or maximum values in a
#' numeric or logical vector.
#'
#' @inheritParams base::which.min
#' @inheritParams base::which
#' @inheritParams base::min
#'
#' @param ... Further parameters to be passed to \code{\link[base]{which}}.
#' @export
#' @details Internaly functions \code{\link[base]{which}} and
#' \code{\link[base]{as.vector}} are used.
#' @examples
#' x <- c(1,2,1,3,3,2,1)
#' which.max.all(x)
#' #>  4 5
#'
#' which.min.all(x)
#' #>  1 3 7
#'
#' @author Vilmantas Gegzna
#' @family matrix operations in \pkg{spMisc}

which.max.all <- function(x, na.rm = FALSE, useNames = FALSE, ...) {
    which(x == max(x, na.rm = na.rm), useNames = useNames, ...) %>% as.vector()
}

#' @rdname which.max.all
#' @export
which.min.all <- function(x, na.rm = FALSE, useNames = FALSE, ...) {
    which(x == min(x, na.rm = na.rm), useNames = useNames,  ...) %>% as.vector()
}
