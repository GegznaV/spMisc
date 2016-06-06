#' @name bru
#' @aliases bru
#' @aliases bru0
#'
#' @title [+] Generate a string of repeated symbols
#'
#' @description Generate a string of repeated symbols.
#'  Useful for R Markdown (.rmd) files and console output to highlight results.\cr\cr
#'  \code{bru} prints the string. Use \code{bru} to print the string directly
#'  to console or in R Markdown reports. \cr
#'  \code{bru0} returns a string. Use \code{bru0} in combination with functions
#'  such as \code{\link[base]{sprintf}}.
#'
#' @param symbol A symbol or sequence of symbols to be used. Default is \code{"="}.
#' @param n    A number of symbols to return: a length of a string.
#'             Default is 60 symbols.
#' @param after A number of new (empty) lines/rows to be added afterwards.
#'        \code{0} means that following text continues in the same row.
#'        Default is \cr\code{if (print==TRUE) 1 else 0}.
#' @param before A number of peceeding (empty) rows to be added. Default is 0.
#' @param print If \code{TRUE} (default for \code{bru}), result is printed to
#'       console using \code{\link[base]{cat}} method.
#'              If \code{FALSE}, a string is returned.
#'
#' @return String of repeated symbols.
#' @export
#'
#' @examples
#' library(spMisc)
#'
#' bru()
#' ## ============================================================
#'
#' bru("-")
#' ## ------------------------------------------------------------
#'
#' bru("= ")
#' ## = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
#'
#' bru(12345, 3) # length = 3 symbols
#' ## 123
#'
#' bru(12345, 6) # length = 6 symbols
#' ## 123451
#'
#' bru0() # return a string
#' ## [1] "============================================================"
#'
#' # Several sequences in separate rows
#' bru(n=5);bru("*",n=5)
#' ## =====
#' ## *****
#'
#' # Several sequences in one row
#' bru(n=5, after=0);bru("*",n=5, after=0)
#' ## =====*****
#'
#'# The same as previous, just short name of "after"
#' bru(n=5, a=0);bru("*",n=5, a=0)
#' ## =====*****
#'
#'
#' paste(bru(":", 5),  bru("*", 5))
#' ## :::::
#' ## *****
#' ## character(0)
#'
#' paste(bru0(":", 5),  bru0("*", 5))
#' ## [1] "::::: *****"
#'
#' bru0('*', 10, before = 5)
#' ## [1] "\n\n\n\n\n**********"
#'
#' bru('*', 10, before = 5) # 5 empty rows are added
#' ##
#' ##
#' ##
#' ##
#' ##
#' ## **********
#'
#' @family \pkg{spMisc} utilities
#' @author Vilmantas Gegzna
#'
bru <- function(symbol = "=",
                n = 60,
                after  = (if (print) 1 else 0),
                before = 0,
                print  = TRUE)
{
    # Create sequences of symbols
    nlB   <- bru_n('\n', before)
    lineC <- bru_n(symbol,n)
    nlA   <- bru_n('\n', after)
    # Adjust the length
    lineC <- substr(lineC, 1, n)

    # Join all symbols
    lineC <- paste0(nlB, lineC, nlA)

    # Either print or return the result
    if (print)  cat(lineC) else return(lineC)
}


#' @template same
#' @rdname bru
#' @export

bru0 <- function(..., print = FALSE) {bru(..., print = print)}


# --------------------------------------------------------------
# times how many times shopuld be repeated

bru_n <- function(symbol, times) {
    paste0(rep(symbol, times),   collapse = "")
}
