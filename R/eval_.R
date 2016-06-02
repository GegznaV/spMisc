#' [!] Parse a string and evaluate expression
#'
#' A wrapper function to parse a string and evaluate it as an expression.
#' \code{eval_(X)} is the same as \code{eval(parse(text = X)}.
#'
#' @param X A string to be evaluated as an expression.
#' @inheritParams base::eval
#' @return Evaluated expression
#' @export
#' @seealso Evaluate an (unevaluated) expression (\link[base]{eval}),
#'          Parse expressions (\link[base]{parse})
#' @examples
#' if (any(ls() == "A")) rm(A)
#' any(ls() == "A")
#' #> [1] FALSE
#'
#' eval_("A <- 3")
#' any(ls() == "A")
#' #> TRUE
#'
eval_ <- function(X, envir = parent.frame()) {
    parse(text = X) %>% eval(. , envir = envir)
}
