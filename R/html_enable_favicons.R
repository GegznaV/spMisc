#' Add code to HTML head that enables display of favicons
#'
#' Function adds a line of code to the last line of head of all \code{.html}
#' and \code{.htm} files in the indicated main directory and its subdirectories.
#' \bold{NOTE:} function doos not check if the favicon exists in the directory.
#'
#' @param main_dir (string(1)) \cr root directory of your website.
#' @param favicon_path (string(1)) \cr relative path to favicon
#'                                    (from the \code{main_dir}).
#'
#' @return A vector with messages if procedure suceeded
#' @export
#'
#' @examples
#' # html_enable_favicons("./docs", "favicon.ico")
#' @author Vilmantas Gegzna
#' @seealso html_add_line_to_head
html_enable_favicons <- function(main_dir = "./docs",
                                 favicon_path  = "favicon.png") {

    # Get default file separator
    fsep <- .Platform$file.sep

    # Extract paths to HTML files
    html_files <- list.files(
        path = main_dir,
        full.names = TRUE,
        recursive = TRUE,
        pattern = "\\.htm(l)?$")

    # Define lines to add
    line_to_add <-
        # Relative path to favicon (when `main_dir` is the root)
        stringr::str_replace(html_files, main_dir, ".") %>% # Convert path to relative.
        stringr::str_count(stringr::fixed(fsep))  %>%   # Get depth of directory last name is a
        magrittr::subtract(1) %>%               # filename not dir, thus -1.
        stringr::str_dup("../", .)    %>%
        stringr::str_c(favicon_path)  %>%
        # code of the lines to be added in the head of HTML files
        stringr::str_c('<link rel="icon" href="',. ,'" />')

    # Add the lines to the files
    purrr::map2_chr(html_files, line_to_add, html_add_line_to_head)
}
