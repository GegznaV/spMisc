
#' [+] Open curent working directory
#'
#' Function opens curent working directory.
#' @return No value, but informative error messages will be given if the
#' operation fails.
#'
#' @details
#' This function is a wrapper for \code{shell.exec(getwd())}.
#'
#' @export
#'
#' @examples
#'
#' \donttest{
#' \dontrun{
#' open_wd()
#' }}
#'
#' @seealso \code{\link[base]{shell.exec}}
#' @family \pkg{spMisc} utilities
#'

open_wd <- function(){
    shell.exec(getwd())
}

# [!] Open curent working directory (in Windows)

# Function opens curent working directory in Windows and returns error in other operating systems (OS).
# @details
# This function is wrapper for \code{shell.exec(getwd())}
# @export

# @examples
# open_wd()
# open_wd <- function(){
#     if (Sys.info()['sysname']  %in% "Windows"){
#         shell.exec(getwd())
#     } else {
#         stop("This function works only in Windows operating system.")
#     }
#
# }
