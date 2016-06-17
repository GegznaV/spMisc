#' Build full file name from parts
#'
#' Build full file name from parts and remove repeated slashes.
#'
#' @inheritParams base::file.path
#' @param ext - extension of file name (e.g. ".txt" or "txt")
#'
#' @return
#' A character vector of the arguments concatenated term-by-term and
#' separated by \code{fsep} if all arguments have positive length;
#' otherwise, an empty character vector (unlike \code{\link[base]{paste}}).
#' All slashes are converted to \code{fsep}. Double slashes are removed.
#'
#' @export
#'
#' @examples
#'
#' fullfile("a","b","c")
#'  #> [1] "a/b/c"
#'
#' fullfile("a/","/b/","/c/")
#'  #> [1] "a/b/c"
#'
#' fullfile("a","b\\","c", ext = "txt")
#'  #> [1] "a/b/c.txt"
#'
#' fullfile("a","b\\","c", ext = "txt")
#'  #> [1] "a/b/c.txt"
#'
fullfile  <- function(..., ext = "", fsep = .Platform$file.sep){
    # Need to check, if spaces are entered and remove them
    #  #>  not implemented yet

    # Add dot to the extension
    if (length(ext)>0) ext <- gsub("(^[^\\.])", ".\\1", ext)

    file.path(..., fsep = fsep)  %>%
        # Convert slashes to default separator
        gsub(pattern = "(\\\\|/)", replacement = fsep)  %>%

        # Remove double slashes
        gsub(pattern = paste0(fsep,"+"), replacement = fsep) %>%

        gsub(pattern = paste0(fsep,"$"), replacement = "") %>%

        paste0(ext)




}
