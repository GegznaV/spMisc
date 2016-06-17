
# Regular expression (named tokens) --------------------------------------------

#' [!+] Capture information to a dataframe by regular expressions
#'
#' Capture information in substrings of \code{text} that match \bold{named} and
#' \bold{unnamed tokens} of regular expressions and convert the result to a
#' data frame.
#'
#' @note Call to function \code{gregexpr} with parameter \code{perl = TRUE}
#' is used.
#'
#' @param text The text to be parsed: a character vector where matches are
#'        sought, or an object which can be coerced by \code{as.character}
#'        to a character vector.
#' @param pattern Perl-like regular expression.
#' @param ... Other arguments to be passed to \code{\link[base]{gregexpr}}.
#'
#'
#' @param stringsAsFactors	logical, passed to \code{\link[base]{as.data.frame}}.
#'
#' @inheritParams base::gregexpr
#'
#' @return A data frame with parsed information.
#'
#'
#' @export
#'
#' @seealso More about regular expressions used in R: \link[base]{regex}\cr
#'          Website handy for creating and testing Perl-like regular expressions
#'          (library \emph{pcre}, version 1, not 2)
#'          \url{https://regex101.com/r/dS3iP1/1#pcre} \cr
#'
#'          Functions \code{\link[base]{gregexpr}},
#'          \code{\link{regcapturedmatches}},
#'          operator from package \pkg{magrittr} \code{\link[magrittr]{\%>\%}}.
#'
#' @examples
#'
#' text1 <- c("A_111  B_aaa",
#'               "A_222  B_bbb",
#'               "A_333  B_ccc",
#'               "A_444  B_ddd",
#'               "A_555  B_eee")
#'
#' # Named tokens
#' pattern1_named_tokens <- 'A_(?<Part_A>.*)  B_(?<Part_B>.*)'
#'
#' regexp2df(text1, pattern1_named_tokens)
#' ##     Part_A Part_B
#' ## 1    111    aaa
#' ## 2    222    bbb
#' ## 3    333    ccc
#' ## 4    444    ddd
#' ## 5    555    eee
#'
#' # Unnamed tockens - groups inside brackets:
#' pattern1_unnamed_tokens <- 'A_(.*)  B_(.*)'
#'
#' regexp2df(text1, pattern1_unnamed_tokens)
#' ##       X     X.1
#' ## 1    111    aaa
#' ## 2    222    bbb
#' ## 3    333    ccc
#' ## 4    444    ddd
#' ## 5    555    eee
#'
#'
#' #----------------------------------------------------------
#' # Wrong. There must be NO SPACES in token's name:
#'
#' \donttest{
#' \dontrun{
#' pattern2 <- 'A (?<Part A>.*)  B (?<Part B>.*)'
#' regexp2df(text1, pattern2)
#'
#' ## Error ...
#'
#' }}
#' #----------------------------------------------------------
#' text3 <- c("sn555 ID_O20-5-684_N52_2_Subt2_01.",
#'               "sn555 ID_O20-5-984_S52_8_Subt10_11.")
#'
#' pattern3 <- paste0('sn(?<serial_number>.*) ID_(?<ID>.*)_(?<Class>[NS])',
#'                    '(?<Sector>.*)_(?<Point>.*)_[Ss]ubt.*\\.');
#'
#' regexp2df(text3, pattern3)
#'
#' ##   serial_number    ID       Class Sector Point
#' ## 1      555      O20-5-684     N     52     2
#' ## 2      555      O20-5-984     S     52     8
#'
#' #----------------------------------------------------------
#' # List all .R files in your working directory:
#'
#' regexp2df(dir(),'(?<R_file>.*\\.[rR]$)')
#'
#'
#' # Do the same by using chaining operator %>%:
#' library(dplyr)
#'
#' dir() %>% regexp2df('(?<R_file>\\.*[rR]$)')
#'
#' #----------------------------------------------------------
#' # Capture several types of files:
#'
#' expr <- paste0('(?<R_file>.*\\.[rR]$)|',
#'                '(?<Rmd_file>.*\\.[rR]md$)|',
#'                '(?<CSV_file>.*\\.[cC][sS][vV]$)')
#' dir() %>% regexp2df(expr)
#'
#' @family \pkg{spMisc} utilities
#' @section Contribution:
#' In this function ideas from
#' \href{http://stackoverflow.com/questions/33288075/from-matlab-to-r-capture-named-fields-with-regular-expressions-to-a-dataframe?answertab=votes#tab-top}{this answer}
#' on github.com were used.
#'
#' @author Author Vilmantas Gegzna,
#'  contributor
#'  \href{http://stackoverflow.com/users/2372064/mrflick?tab=profile}{MrFlick},
#'  as he provided ideas on github.com (see section Contribution).

regexp2df <- function(text, pattern, ignore.case = FALSE,
                      perl = TRUE, ## TRUE not FALSE, see if description is correct
                      stringsAsFactors = default.stringsAsFactors(),
                      ...)  {
    ParsedData <- gregexpr(pattern, text, ignore.case = ignore.case,
                           perl = perl, ...)
    as_a_list  <- regcapturedmatches(text, ParsedData)
    rbind_DF <- function(...)
    {
        rbind.data.frame(...,
                         stringsAsFactors = stringsAsFactors,
                         make.row.names = TRUE)
    }
    df <- do.call(rbind_DF, as_a_list)
    return(df)
}

