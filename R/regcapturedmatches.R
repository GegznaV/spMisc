#' [.] Extract regular expression matches captured by names
#'
#' regcapturedmatches.R: extracts captured matches from match data obtained
#'  by regexpr, gregexpr or regexec.
#'
#' # @export
#' @param x (A list of) strings.
#' @param m Parsed data, a result from a regular expression function.
#'
#' @return A list with captured matches
#'
#'
#' @author Daniel Marcelino (MrFlick)
#' @source
#' \url{https://gist.github.com/danielmarcelino/8209cfdf2cd993eeb1b3}[github.com/danielmarcelino]
#' \url{https://gist.github.com/MrFlick/10413321}
#' \url{http://stackoverflow.com/questions/33288075/from-matlab-to-r-capture-named-fields-with-regular-expressions-to-a-dataframe}
#' @examples
#' # usage
#'
#' x<-c("larry:35,M","alison:22,F","dave","lily:55,F")
#' m<-regexpr("(.*):(\\d+),([MF])", x, perl=TRUE)
#' spMisc:::regcapturedmatches(x,m)
#'

regcapturedmatches <- function(x,m) {
  if (length(x) != length(m))
    stop(gettextf("%s and %s must have the same length",
      sQuote("x"), sQuote("m")), domain = NA)

  ili <- is.list(m)
  useBytes <- if (ili) {
    any(unlist(lapply(m, attr, "useBytes")))
  } else {
    any(attr(m, "useBytes"))
  }
  if (useBytes) {
    asc <- iconv(x, "latin1", "ASCII")
    ind <- is.na(asc) | (asc != x)
    if (any(ind))
    Encoding(x[ind]) <- "bytes"
  }
  if (ili) {
    if (any(sapply(m, function(x) {is.null(attr(x,"capture.start"))}) == T)) {
      stop("No capture data found (did you use perl=T?)")
    }
	  starts <- lapply(m, function(x) {attr(x, "capture.start")})
	  lengths <- lapply(m, function(x) {attr(x, "capture.length")})
  } else {
    if (is.null(attr(m,"capture.start"))) {
      stop("No capture data found (did you use perl=T?)")
	  }
    starts <- data.frame(t(attr(m, "capture.start")))
    lengths <- data.frame(t(attr(m, "capture.length")))
  }

  cleannames <- function(x) {
    if (!is.null(colnames(x))) {
        colnames(x) <- make.unique(make.names(colnames(x)))
        x
    } else {
        x
    }
  }
  starts <- lapply(starts, cleannames)
  lengths <- lapply(lengths, cleannames)

  Substring <- function(x,starts,lens) {
    if (all(starts < 0)) {
      return(character())
    } else {
      x <- t(
        mapply(function(x,st,ln) substring(x,st,st + ln - 1),
	      x, data.frame(t(starts)), data.frame(t(lens)),
	      USE.NAMES = F)
      )
        if (!is.null(colnames(starts))) {
		colnames(x) <- colnames(starts)
        }
        x
    }
  }

  y <- Map(
    function(x, sos, mls) {
      Substring(x,sos,mls)
    },
    x,
    starts,
    lengths,
    USE.NAMES = FALSE
  )
  y
}
