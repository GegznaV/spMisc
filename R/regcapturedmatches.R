#' [.] Extract regular expression matches captured by names
#'
#' regcapturedmatches.R: extracts captured matches from match data obtained
#'  by regexpr, gregexpr or regexec.
#'
#'
#' @param x (A list of) strings.
#' @param m Parsed data, a result from a regular expression function.
#'
#' @return A list with captured matches
#'
#'
#' @source
#' The coded adapted from:
#' \href{https://gist.github.com/MrFlick/10413321}{regcapturedmatches.R} on gist.github.com
#' \href{http://stackoverflow.com/questions/33288075/from-matlab-to-r-capture-named-fields-with-regular-expressions-to-a-dataframe}{answer} on stackoverflow.com.
#' Originally written by:
#' \href{http://stackoverflow.com/users/2372064/mrflick?tab=profile}{MrFlick}
#'
#' @examples
#' # usage
#'
#' x <- c("larry:35,M", "alison:22,F", "dave", "lily:55,F")
#' m <- regexpr("(.*):(\\d+),([MF])", x, perl = TRUE)
#' rez <- regcapturedmatches(x, m)
#' rez
#'
#'
#' regexp2df(x, "(.*):(\\d+),([MF])")
#'
#'
#' m <- regexpr("(?<name>.*):(?<age>\\d+),(?<gender>[MF])",
#'               x,
#'               perl = TRUE)
#' rez2 <- regcapturedmatches(x, m)
#' rez2
#'
#' regexp2df(x, "(?<name>.*):(?<age>\\d+),(?<gender>[MF])")
#'
#' @export
regcapturedmatches <- function(x, m) {
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if (length(x) != length(m))
    stop("`x` and `m` must have the same length")

  is_list <- is.list(m)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  useBytes <- if (is_list) {
      any(purrr::map_lgl(m, ~isTRUE(attr(., "useBytes"))))
  } else {
    any(attr(m, "useBytes"))
  }

  if (useBytes) {
    asc <- iconv(x, "latin1", "ASCII")
    ind <- is.na(asc) | (asc != x)
    if (any(ind)) Encoding(x[ind]) <- "bytes"
  }
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if (is_list) {
      if (any(purrr::map_lgl(m, ~is.null(attr(.,"capture.start"))))) {
          stop("No capture data found (did you use perl=T?)")
      }

      starts  <- purrr::map(m, ~attr(., "capture.start"))  # %>% reduce(rbind.data.frame)
      lengths <- purrr::map(m, ~attr(., "capture.length"))

  } else {
      if (is.null(attr(m,"capture.start"))) {
          stop("No capture data found (did you use perl=T?)")
      }

    starts  <- data.frame(t(attr(m, "capture.start")))
    lengths <- data.frame(t(attr(m, "capture.length")))
  }

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  cleannames <- function(x) {
    if (!is.null(colnames(x))) {
        colnames(x) <- make.unique(make.names(colnames(x)))
        x
    } else {
        x
    }
  }

  starts  <- purrr::map(starts,  cleannames)
  lengths <- purrr::map(lengths, cleannames)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  Substring <- function(x, starts, lens) {

    if (all(starts < 0)) {
      return(rep(NA, length(starts)))
      # return(character())
    } else {
      x <- t(
          mapply(function(x, st, ln) substring(x, st, st + ln - 1),
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
      function(x, sos, mls) {Substring(x, sos, mls)},
      x,    starts,    lengths,
      USE.NAMES = FALSE
  )
  y
}
