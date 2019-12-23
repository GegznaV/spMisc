#' knit_output_dir
#'
#' @param output_dir (character)
#'
#' @export
#'
#' @details this function does not work as expected!
#'
#' @examples
#' # In YAML header or R markdown file:
#' #
#' # ---
#' # knit: (spMisc::knit_output_dir(output_dir = "some_dir/")(inputFile, encoding))
#' # ---
#'
#' # ---
#' # knit: (function(inputFile, encoding, ...) {
#' #         rmarkdown::render(inputFile, encoding = encoding,
#' #         output_dir = "some_dir/")
#' #     })
#' # ---
#'
knit_output_dir <- function(output_dir = ".") {
    (function(inputFile, encoding, ...) {
        rmarkdown::render(inputFile, encoding = encoding, output_dir = output_dir, ...)
    })
}


