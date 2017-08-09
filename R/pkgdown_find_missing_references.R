#' Find missing function references in "_pkgdown.yaml" file
#'
#' @return Vector of missing entries
#' @export
#'
#' @examples
#' pkgdown_find_missing_references()
pkgdown_find_missing_references <- function() {
    pkgdown_yaml <- "_pkgdown.yaml"
    if (!file.exists(pkgdown_yaml))
        stop('File "_pkgdown.yaml" was not found.')

    str <- readr::read_lines(pkgdown_yaml)
    x   <- pkgdown::template_reference()

    contents <- x$reference[[1]]$contents

    # Indices of not-missing sampes
    ind <-
        purrr::map_lgl(contents,
                       ~any(stringr::str_detect(str, .x)))

    rez <- c(glue::glue("Missings in: {getwd()}/{pkgdown_yaml}"),
             glue::glue("  - '{contents[!ind]}'"))

    class_add(rez, "missing_references")
}


#' @rdname pkgdown_find_missing_references
#' @inheritParams base::print
#' @export
#' @method print missing_references
print.missing_references <- function(x, ...) {
   if (length(x) == 1) {
       x[2] <- "(none)"
   }
    writeLines(x)
}
