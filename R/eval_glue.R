#' [!] Format, parse and evaluate expression in a string
#'
#' A wrapper function to format and parse a string and evaluate it
#' as an expression. \code{eval_(X)} is a wrapper for
#' \code{eval(parse(text = glue::glue(X)))}.
#'
#' @details
#' It's a good practice to write backticks (`) arround variable names
#' to prevent from errors in situations, where variables have uncommon
#' names. See examples.
#'
#' @param ... Strings to be formatted and evaluated as an expression.
#' @param .open	 [\code{character(1)}: ‘\{’] \cr
#'        The opening delimiter. Doubling the full delimiter escapes it.
#' @param .close [\code{character(1)}: ‘\}’] \cr
#'        The closing delimiter. Doubling the full delimiter escapes it.
#' @inheritParams glue::glue
#' @inheritParams base::eval
#'
#' @export
#' @seealso Format and interpolate a string (\code{\link[glue]{glue}}).\cr
#'          Evaluate an (unevaluated) expression (\code{\link[base]{eval}}).\cr
#'          Parse expressions (\code{\link[base]{parse}}).
#' @examples
#' library("spMisc")
#'
#' AA <- "nn"
#'
#' glue::glue("{AA} <- 3")
#'
#' eval_glue("{AA} <- 3")
#'
#' AA
#'
#' nn
#'
#'  # It's a good practice to write backticks (`) arround variable names
#'  # to prevent from errors in situations, where variables have uncommon
#'  # names:
#'
#' BB <- "A B"
#'
#' eval_glue("`{BB}` <- 8")
#'
#' `A B`
#'
eval_glue <- function(..., envir = parent.frame(),
                      .sep = "", .open = "{", .close = "}") {

    x2 <- glue::glue(..., .envir = envir, .open = .open, .close = .close)
    eval(parse(text = x2), envir = envir)
}
