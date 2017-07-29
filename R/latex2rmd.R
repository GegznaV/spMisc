


#'  Convert Rnw to Rmd
#'
#'  Does most of the job converting Sweave .Rnw files to R markdown .Rmd format.
#'  Not perfect, but good enough.
#'
#' @param input
#' @param output
#'
#' @return
#' @export
#'
#' @examples
#'
#' setwd("C:/Users/ViG/Documents/GitHub/hyperSpec2/docs/articles/plotting")
#' input   <- "plotting.Rnw"
#' output  <- "plotting2.Rmd"
#' latex2rmd(input, output)


latex2rmd <- function(input, output) {
    # Define function `r`, so that regex matches multilines and
    # new line symbols.
    library(magrittr)
    library(stringr)
    library(purrr)
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # # To match ecacly N times, not more, not less
    # txt <-c("--- --- -- - -", "---a---a--a-a-")
    #
    # str_view_all(txt, "(?<!-)-{3}(?!-)")
    # str_view_all(txt, "(?<!-)-{1}(?!-)")
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    r <- purrr::partial(stringr::regex,
                        multiline = TRUE,
                        dotall    = TRUE)

    section <- function(sym) {
        str_c("\n\\1\n", str_dup(sym, 70),"\n")
    }
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Read text
    text <- readChar(input, file.info(input)$size)

    text  %<>%
        str_replace_all(r("\\\r"), "")

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Šitą kodų bloką iškelti atskirai, kad ieškotų pavadinimų, autorių,
    # datų, t.t. tik "head" dalyje.
    #
    # Po to tuos pavadinimus gražiai sudėtų į Rmd dokumento YAML antraštę.
    #
    text  %<>%
        str_replace_all(c(
            " *pdftitle=\\{(.*?)\\},?"    = "title: \\1",
            " *pdfsubject=\\{(.*?)\\},?"  = "subtitle: \\1" ,
            " *pdfauthor=\\{(.*?)\\},?"   = "author: \\1",
            " *pdfkeywords=\\{(.*?)\\},?" = "keywords: \\1",
            "\\\\begin\\{document\\}"
            = str_c("---\n\n",
                    "```{r setup}\n",
                    "knitr::opts_chunk$set(echo = TRUE)\n\n",
                    "```\n"))
        ) %>%
        str_replace_all(r("^.*\\\\hypersetup\\{(.*?)\\}"),
                        "---\n\\1")  %>%
        str_replace_all(
            pattern = r("\\\\title\\{(.*?)\\}"),
            replacement = section("=")) %>%

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # hyperSpec specific repacements
    text  %<>% str_replace_all(c(
        "\\\\(phy|chy)" = "_hyperSpec_",
        "\\\\df" = "_data.frame_",
        "\\\\eg" = "e.g.,")) %>%

        str_replace_all(
            pattern = r("\\\\plottab\\{(.*?)\\}\\{(.*?)\\}"),
            replacement = "`\\1` <!-- \\2 -->")
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


    text %<>%
        str_replace_all(
            pattern = r("<<(.*?)>>=(.*?)@\\s?"),
            replacement = "\n```{r, \\1}\\2```\n") %>%

        str_replace_all(
            pattern = r("\\\\href\\{(.*?)\\}\\{(.*?)\\}"),
            replacement = "[\\2](\\1)") %>%

        str_replace_all(
            pattern = r("\\\\url\\{(.*?)\\}"),
            replacement = "[\\1]")  %>%

        # Special symbols / Enclosing symbols
        str_replace_all(c(
            "\\\\," = ',',
            "\\\\textasciitilde"             = '~',
            "~\\s?~"                         = '~', # Šitą eilutę panaikinti
            "\\\\cdot"                       = '·',
            "[^`]`{2}[^`]"                   = '"',
            "[^']'{2}[^']"                   = '"',
            "\\\\&"                          = '&',
            "\\\\times"                      = '×',
            "\\\\textquotesgl\\{(.*?)\\}"    = "'",
            "\\\\textquotedbl\\{(.*?)\\}"    = '"',
            "\\\\textsuperscript\\{(.*?)\\}" = '^\\1^',
            "\\\\textsubscript\\{(.*?)\\}"   = '~\\1~',
            "\\\\Sexpr\\{(.*?)\\}"           = "`r \\1`",
            "\\\\textbf\\{(.*?)\\}"          = "**\\1**",
            "\\\\emph\\{(.*?)\\}"            = "_\\1_", #??? italic or bold)
            "\\\\textit\\{(.*?)\\}"          = "_\\1_")) %>%

        str_replace_all(r("\\\\verb\\+(.*?)\\+"), '`\\1`') %>%

        str_replace_all(c(
            "\\\\(texttt|code|Rcode|Rfunarg|Robject|Rcommand)(\\[.*?\\])?\\{(.*?)\\}" = "`\\3`",
            "\\\\(Rpackage)(\\[.*?\\])?\\{(.*?)\\}" = "**`\\3`**",
            "\\\\(Rfunction|Rmethod)(\\[.*?\\])?\\{(.*?)\\}" = "_`\\3`_"))

    # Section names
    text  %<>%
        str_replace_all(
            pattern = r("\\\\section\\*?\\{(.*?)\\}"),
            replacement = section("=")) %>%

        str_replace_all(
            pattern = r("\\\\subsection\\*?\\{(.*?)\\}"),
            replacement = section("-")) %>%

        str_replace_all(
            pattern = r("\\\\subsubsection\\*?\\{(.*?)\\}"),
            replacement = "\n### \\1")  %>%

        str_replace_all(
            pattern = r("\\\\frametitle\\*?\\{(.*?)\\}"),
            replacement = section("=")) %>%

        str_replace_all(
            pattern = r("\\\\framesubtitle\\*?\\{(.*?)\\}"),
            replacement = section("-"))

    # Items of a list
    text  %<>%
        str_replace_all(c(
            "\\\\begin\\{itemize\\}"              = "\n",
            "\\\\end\\{(itemize|labeling)\\}"     = "",
            "\\\\begin\\{labeling\\}\\{(.*?)\\}"  = "<!-- \\1 -->")) %>%

        str_replace_all(
            pattern = r("\\\\item\\[(.*?)\\]"),
            replacement = "- **\\1\\**") %>%

        str_replace_all(
            pattern = r("\\\\item"),
            replacement = "- ")

    # Other
    text  %<>%
        str_replace_all(
            pattern = r("\\\\end\\{frame\\}"),
            replacement = "---")  %>%

        str_replace_all(
            pattern = r("\\\\\\\\"),
            replacement = "  ")


    # text  %<>%
    #     str_replace_all(
    #         pattern = r("\\\\begin\\{(.*?)\\}"),
    #         replacement = "")  %>%
    #
    #     str_replace_all(
    #         pattern = r("\\\\end\\{(.*?)\\}"),
    #         replacement = "")


    readr::write_lines(text, output)
}
