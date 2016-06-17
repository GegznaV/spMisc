#' @name fCap
#' @aliases fCap
#' @aliases make_firstCapitals
#' @title [+] Convert first letters of all words to capitals
#'
#' @description  Convert first letters of all words in a string to capitals.
#'
#' @param x Either a string or a vector of strings.
#'
#' @return The same string as input with all words starting in capital letters.
#'
#' @examples
#'
#' fCap('laa laa laa')
#' ##[1] "Laa Laa Laa"
#'
#' @export
#' @family \pkg{spMisc} utilities
fCap <- function(x){
    s <- strsplit(x, " ")[[1]]
    S <- paste(toupper(substring(s, 1, 1)),
           substring(s, 2),
           sep = "", collapse = " ")
    return(S)
}

