#' Add a line of text in the last line of an HTML file head
#'
#' @param filename (string(1)) \cr name of an HTML file.
#' @param line_to_add (string(1)) \cr text to be added.
#' @param locale Information of locale, produced by, e.g.,
#'               \code{readr::default_locale()}. More about locales:
#'                \link[readr]{locale}.
#'
#' @return A message, if the line was added.
#' @export
#'
#' @examples
#'
#' # add_line_to_html_head("index.html", "<br>")
#' @author Vilmantas Gegzna
#' @seealso html_enable_favicons
html_add_line_to_head <- function(filename,
                                  line_to_add,
                                  locale = readr::default_locale()) {

    file_contents <- readr::read_lines(filename, locale = locale)

    exists_in_file <- function(x){
        file_contents %>%
            stringr::str_detect(stringr::fixed(x)) %>%
            any()
    }

    if (!exists_in_file("</head>")) {
        return(stringr::str_c("Tag '</head>' was not detected in: ", filename))
    }

    if (exists_in_file(line_to_add)) {
        # message("The file already contains the `line_to_add`.")
        msg <- "Not changed"
    } else {
        # Add code as the last line of the html head, add preceeding tab
        file_contents  %>%
            stringr::str_replace(
                pattern = "(</head>)",
                replacement = sprintf("\t%s\n\\1", line_to_add)) %>%
            # Write to file
            readr::write_lines(path = filename)
        msg <- "Updated"
    }
    # Output formatted message
    sprintf("% 12s: %s", msg, filename)
}
