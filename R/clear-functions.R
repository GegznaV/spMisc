#' @title [!] Clear variables from workspace (current environment)
#'
#' @description Remove items from the workspace, i.e. the current environment,
#' and free up system memory. Explanation in section \bold{"Details"}.
#'
#'
#' @details
#'
#' \code{clear} removes either listed or, if none is listed, all* not hidden
#' (that name does not begin with dot(\code{.})) variables.
#' Default is to clear all except hidden objects.\cr\cr
#' \code{clear_all} the same as \code{clear} just aditionally clears hidden
#'  variables (that name begins with dot (\code{.})).\cr\cr
#' \code{clear_except} clears variables except listed ones.\cr\cr
#' \code{clear_class} removes objects of indicated class(es), except those which
#' names provided in list \code{exceptVar}.\cr\cr
#' \code{clear_except_class} keeps objects of indicated class(es), others are
#'  cleared.\cr\cr
#' \code{clear_fun} removes \emph{all} (including hidden) items that are
#'   functions. \cr\cr
#'
#' These functions are wrappers and extensions for \code{\link[base]{rm}}.\cr\cr
#'
#' @param ... The objects as names (unquoted) or character strings (quoted).
#'
#' @param list A character vector naming objects. Used instead of `\code{...}`.
#'        If \code{list} is not \code{NULL}, dots `\code{...}` are ignored.
#'
#' @param except,exceptVar Names of \bold{variables} (as a character vector)
#'        \bold{to be kept} (to be cleared). Default is \code{NULL}.
#' @param clrClass Names of classes (as a character vector). Objects of
#'        indicated classes to be removed.
#' @param exceptClass Names of classes (as a character vector) that
#'         have \bold{not} to be cleared. Default is \code{NULL}.
#'
#' @param envir The environment in which function takes action. Default is
#'        the global environment \code{.GlobalEnv}.
#'
#' @param all.names	a logical value. If \code{TRUE} (default \emph{only}
#'  in \code{clear_all} and \code{clear_fun}), all objects are cleared.
#'  If \code{FALSE} (default in \code{clear}), objects which names begin
#'  with a \code{.} are omitted.
#'
#' @export
#'
#' @examples
#'
#' clear()
#'
#'   A <- 5
#'   B <- "s"
#'  D1 <- "string2"
#'  D2 <- "string3"
#'   L <- list(A,B)
#' FUN <- function(x) x
#' `%in%` <- `%in%`
#'
#'
#' ls()
#'
#' clear_class("numeric")
#' ls()
#'
#' clear_fun()
#' ls()
#'
#' clear(except = c("D1", "D2"))
#' ls()
#'
#' clear(except = c("B"))
#' ls()
#'
#' clear()
#' ls()
#'
#' numeric_1 <- 5
#' numeric_2 <- 5
#' numeric_3 <- 5
#' My_list <- list("a","A")
#' My_string <- "ABC"
#' ls()
#'
#' clear_except_class(c("numeric", "list"))
#' ls()
#'
#' clear_class("numeric", exceptVar = "numeric_1")
#' ls()
#'
#'
#' @family \pkg{spHelper} utilities
#' @family \pkg{spHelper} \code{clear} family functions
#'
#' @seealso Remove objects from a specified environment \code{\link[base]{rm}},
#'          list objects \code{\link[base]{ls}}.
#'
#' @author Vilmantas Gegzna
#
# @param pos The environment as a position in the search list.

clear <- function(... , list = NULL, except = NULL, all.names = FALSE,
                  envir = parent.frame()) {
    if (is.null(list)) {
        list <- match.call(expand.dots = FALSE)$`...`
        list <- unlist(lapply(list, as.character))
    }

    if (is.null(list)) {list <- ls(name = envir, all.names = all.names)}
    list <- setdiff(list, except)

    if (!is.character(list))
        stop("Argument must be empty or a character vector.")

    rm(list = list, envir = envir)
    gc()
    invisible("Cleared")
}

#  ------------------------------------------------------------------------
#' @rdname clear
#' @export
#'
clear_all <- function(... , list = NULL, except = NULL,
                      all.names = TRUE, envir = parent.frame())  {
    clear(... , list = list, except = except,
          all.names = all.names, envir = envir)
}

#  ------------------------------------------------------------------------
#' @rdname clear
#' @export
#'
clear_except <- function(..., list = NULL, all.names = FALSE, envir = parent.frame())  {
    if (is.null(list)) {
        list <- match.call(expand.dots = FALSE)$`...`
        list <- sapply(list, as.character)
    }

    if (is.null(list)) {
        warning("The workspace is not cleared as no variables that must be kept are listed.")
    } else {
        clear(except = list, envir = envir, all.names = all.names)
    }
}
#  ------------------------------------------------------------------------
#' @rdname clear
#' @export
clear_class <- function(clrClass = NULL, exceptVar = NULL,
                        all.names = FALSE, envir = parent.frame()) {
    if (is.null(clrClass)) {
        warning("The workspace is not cleared as no classes that must be removed are listed.")
        return()
    } else {
        clrList <- ls(envir, all.names = all.names)

    if (length(clrList) > 0) {
        objs  <-  mget(clrList, envir = envir)
        # Objects of classes to remove
        clrList <- names(Filter(function(i) inherits(i, clrClass), objs))
        # Objects to keep
        clrList <- Filter(function(i) i %NOTin% exceptVar, clrList)

        # Clear
        clear(list = clrList, envir = envir, all.names = all.names)

        invisible("Cleared")
        }
    }
}
#  ------------------------------------------------------------------------
#' @rdname clear
#' @export
clear_except_class <- function(exceptClass = NULL, all.names = FALSE, envir = parent.frame()) {
    if (is.null(exceptClass)) {
        warning("The workspace is not cleared as no classes that must be kept are listed.")
    } else {
        clrList <- ls(envir)
        if (length(clrList) > 0) {
            objs  <-  mget(clrList, envir = envir)
            clrList <- names(Filter(function(i) !inherits(i, exceptClass), objs))
            clear(list = clrList, envir = envir,all.names = all.names)
            invisible("Cleared")
        }

    }
}
#  ------------------------------------------------------------------------
#' @rdname clear
#' @export
clear_fun <- function(all.names = TRUE, envir = parent.frame()) {
    clear_class("function", envir = envir, all.names = all.names)
}





##  BUG 1: FIXED
##
##  Use this to fix BUG with "%>%"
##  `%>%` <-  `%>%`
##
# objs =  mget(ls(envir = envir), envir = envir)
# names(Filter(function(i) inherits(i, "function"), objs))

##  BUG 2: FIXED
##  `<a>` <- "string"
## this variable cannot be cleared
#@section WARNING:
#
# BUG: clear_fun() gives error if special function (e.g. `%>%`) is present.

#  ------------------------------------------------------------------------
