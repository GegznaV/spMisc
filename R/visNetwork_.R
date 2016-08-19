#'  Wrapper for function visNetwork
#'
#' The result is the same as if function \code{visNetwork} was used.
#'
#' @param file path to graphviz (.gv) file
#' @inheritParams visNetwork::visNetwork
#' @inheritParams base::readLines
#'
#' @export
#' @importFrom visNetwork visNetwork
visNetwork_ <- function(file, width = NULL, height = NULL, main = NULL,
                        encoding = "UTF-8", ...){
    file2text(file, encoding) %>%
        visNetwork(dot = ., width = width, height = height, main = main, ...)
}

#' @rdname visNetwork_
#' @export
file2text <- function(file, encoding = "UTF-8"){
    readLines(file, encoding = encoding) %>%
        paste0(collapse = "\n")
}

