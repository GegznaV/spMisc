
#' [+] Clear console (Matlab style)
#'
#' Clears console. I.e. does the same as pressing \code{CTRL + L}.
#'
#' @export
#'
#' @family \pkg{spMisc} utilities


clc <- function() { cat("\014") }
