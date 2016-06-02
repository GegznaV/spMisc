
#' Is an expresion equal to FALSE?
#'
#' If condition is equal to \code{FALSE}, returns \code{TRUE},
#' otherwise (i.e. if \code{NULL} or \code{TRUE}) returns \code{FALSE}.
#'
#' @param condition Either a logical condition or \code{NULL}.
#'
#' @export
#'
#' @family \pkg{spMisc} utilities
#' @seealso \code{\link[base]{isTRUE}}
#'
#' @author Vilmantas Gegzna
#'
isFALSE <- function(condition)
    if (isTRUE(condition==FALSE)) TRUE else FALSE

#' @param is_false Result if condition is equal to  \code{FALSE}.
#' @param otherwise_ Result if condition is not equal to \code{FALSE}.
#'
#' @rdname isFALSE
#' @export
#'
ifFALSE <- function(condition, is_false, otherwise_){
    if (isTRUE(condition==FALSE)) is_false else otherwise_
}
