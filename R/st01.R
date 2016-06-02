#' [. will be removed] Standardize values to intervat from 0 to 1
#'
#' Apply formula: \eqn{(x-MIN)/(MAX-MIN)}{(x-MIN)/(MAX-MIN)}
#'
#' Use function \code{\link[scales]{rescale}} instead.
#'
#' @param x A numeric vector vector
#' @param MIN A value treated as a minimum.
#' @param MAX A value treated as a maximum.
#'
#' @export
#'
#' @examples
#'
#' x <- seq(.3,1,.1)
#' st01(x)
#' st01(x, MIN = .2)
#'
#' @seealso \code{\link[scales]{rescale}}
#'
#' @family \pkg{spHelper} utilities
#'
st01 <- function(x, MIN = min(x), MAX = 1) {
    (x-MIN)/(MAX-MIN)

}

#' @rdname st01
#' @export
stMinMax <- function(x, MIN = min(x), MAX = max(x)) {
    (x-MIN)/(MAX-MIN)
}
