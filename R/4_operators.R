#  %.+.% -----------------------------------------------------------------

#' @title Infix versions of \code{paste0} and \code{paste}
#'
#' @description
#'  Infix versions of \code{paste0} and \code{paste}.
#'
#' @details
#' \code{`\%++\%`} is an infix version of \code{paste0}. \cr
#' \code{`\%.+.\%`} is an infix version of \code{paste}.
#'
#' @param a,b values to be pasted with either \code{paste0(a,b)} or \code{paste}.
#'
#'
#' @export
#' @source Inspired by "Infix functions" in
#' \href{http://adv-r.had.co.nz/Functions.html#function-arguments}{Advanced R}
#' by Hadley Wickham.
#'
#' @seealso \code{\link[base]{paste}}, \code{\link[spAddins]{insertPaste_Addin}}
#'
#' @examples
#' "a" %++% "b"
#' #> [1] "ab"
#'
#' "a" %.+.% "b"
#' #> [1] "a b"
#'
`%.+.%` <- function(a, b) {paste(a, b)}


#  %++% ------------------------------------------------------

#' @title Infix versions of \code{paste0} and \code{paste}
#'
#' @description
#'  Infix versions of \code{paste0} and \code{paste}.
#'
#' @details
#' \code{`\%++\%`} is an infix version of \code{paste0}. \cr
#' \code{`\%.+.\%`} is an infix version of \code{paste}.
#'
#' @param a,b values to be pasted with either \code{paste0(a,b)} or \code{paste}.
#'
#'
#' @export
#' @source Inspired by "Inxix functions" in
#' \href{http://adv-r.had.co.nz/Functions.html#function-arguments}{Advanced R}
#' by Hadley Wickham.
#' @seealso \code{\link[base]{paste}}, \code{\link[spAddins]{insertPaste0_Addin}}
#'
#' @examples
#' "a" %++% "b"
#' #> [1] "ab"
#'
#' "a" %.+.% "b"
#' #> [1] "a b"
#'
`%++%` <- function(a, b) {paste0(a, b)}


# %if.NULL%  -----------------------------------------------------------------

#' @name If is NULL
#'
#' @title Infix operator to insert default value if result is NULL
#'
#' @description The function is useful as a way of providing a default value
#'  in case the output of another function is \code{NULL}.
#'
#' @param a An expression.
#' @param b An alternative
#'
#' @return If \code{!is.null(a)} is \code{TRUE} returns \code{a} otherwise
#'         returns \code{b}.
#'
#' @export
#'
#' @seealso \code{\link[spAddins]{insertIfNULL_Addin}}
#' @examples
#' a1 <- "Default value"
#' a2 <- NULL
#' b  <- "Alternative"
#'
#' \donttest{
#' \dontrun{
#'  a1 %if.NULL% b
#' #> [1] "Default value"
#'
#'  a2 %if.NULL% b
#'#> "Alternative"
#'}}
`%if.NULL%` <- function(a, b) {
    if (!is.null(a)) a else b
    }



# %if.NULL%  -----------------------------------------------------------------

#' @name If NULL
#' @title Infix operator to insert default value if result is NULL
#'
#' @description The function is useful as a way of providing a default value
#'  in case the output of another function is \code{NULL}.
#'
#' @param a An expression.
#' @param b An alternative
#'
#' @return If \code{!is.null(a)} is \code{TRUE} returns \code{a} otherwise
#'         returns \code{b}.
#'
#' @export
#'
#' @seealso \code{\link[spAddins]{insertIfNULL_Addin}}
#' @examples
#' a1 <- "Default value"
#' a2 <- NULL
#' b  <- "Alternative"
#'
#'  a1 %if_null% b
#' #> [1] "Default value"
#'
#'  a2 %if_null% b
#'#> "Alternative"
#'
`%if_null%` <- function(a, b) {if (!is.null(a)) a else b}

# %if_null_or_len0% -----------------------------------------------------------------

#' @name If NULL or length is 0
#' @title [.] Infix operator \%if_null_or_len0\%
#'
#' @description
#' The operator is useful as a way of providing a default value
#'  in case the output of another function is \code{NULL} or its length is
#'  zero.
#'
#'
#' @param a An expression.
#' @param b An alternative.
#'
#' @return If \code{!is.null(a) & length(a) > 0 & nchar(a) > 0} is \code{TRUE}
#'         returns \code{a}, otherwise returns \code{b}.
#'
#' @export
#' @examples
#' a1 <- "Default value"
#' a2 <- NULL
#' a3 <- character()
#' b  <- "Alternative"
#'
#'  a1 %if_null_or_len0% b
#' #> [1] "Default value"
#'
#'  a2 %if_null_or_len0% b
#' #> "Alternative"
#'
#'  a3 %if_null_or_len0% b
#' #> "Alternative"

`%if_null_or_len0%` <- function(a, b) {
    if (isTRUE(!is.null(a) & length(a)>0 & nchar(a)>0)) a  else b
}


# %NOTin%  -----------------------------------------------------------------

#' @name %NOTin%
#' @title [!] Operator "not in"
#'
#' @description Operator, oposite to \link[base]{\%in\%}.
#'
#' @param x vector or \code{NULL}: the values to be matched.
#' @param table vector or \code{NULL}: the values NOT to be matched against.
#'
#' @return A vector of the same length as \code{x}. \cr
#' \code{\%!in\%}: A logical vector, indicating if a match was located for
#'  each element of \code{x}: thus the values are \code{TRUE} or \code{FALSE}
#'  and never \code{NA}.
#' @export
#'
#' @seealso \code{\link[spAddins]{insertNotIn_Addin}}
#'
#' @examples
#'
#' 1:10 %!in% c(1,3,5,9)
#' #> [1] FALSE  TRUE FALSE  TRUE FALSE  TRUE  TRUE  TRUE FALSE  TRUE
#'
`%!in%` <- function (x, table) {match(x, table, nomatch = 0L) == 0L}


#' @rdname %NOTin%
#' @export
#' @examples
#' 1:10 %NOTin% c(1,3,5,9)
#' #> [1] FALSE  TRUE FALSE  TRUE FALSE  TRUE  TRUE  TRUE FALSE  TRUE
`%NOTin%` <- function (x, table) {
    # .Deprecated("%!in%")
    match(x, table, nomatch = 0L) == 0L
    }

