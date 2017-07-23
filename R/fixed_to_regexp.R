#' Convert fixed expression to regular expression
#'
#' A back slash (\code{\ }) is added before special symbols
#' (\code{. \ | ( ) [ \{ \}^ $ * + ?}) in a string \code{str}
#' to interpret them as "fixed" in a regular expression.
#' Useful in functions, which accept regular expressions but do not have
#' option \code{fixed = TRUE}.
#'
#' @param str A string
#'
#' @return The string rewritten as regular expression.
#' @export
#'
#' @examples
#' fixed_to_regexp("\\")
#'   ## "\\\\"
#'
#' fixed_to_regexp("||")
#' fixed_to_regexp(".\\|(){}^$*+?[]")
#'
#' fixed_to_regexp("(A|B)")
#'  ## "\\(A\\|B\\)"
#'
#' fixed_to_regexp("Hello!") # nothing is changed
#'   ## "Hello!"
#'
fixed_to_regexp <- function(str) {
    gsub(pattern = "([\\. \\\\ \\| \\( \\) \\{ \\} \\^ \\$ \\* \\+ \\? \\[])",
         replacement = "\\\\\\1",
         x = str)
}
