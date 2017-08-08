#' Remove names of an object
#'
#' @param x An object, which have attribute "names"
#'
#' @return The same object without names.
#' @export
#'
#' @examples
#' obj <- c(a = 1)
#' obj
#'
#' remove_names(obj)
#'
remove_names <- function(x) {
    names(x) <- NULL
    x
}
