
# TODO: Continue checking from here...





# ============================================================================
# str_replace_all(
#     pattern = r("\\\\section\\*?\\{(.*?)\\}"),
#     replacement = section("=")) %>%
#
# str_replace_all(
#     pattern = r("\\\\subsection\\*?\\{(.*?)\\}"),
#     replacement = section("-")) %>%
#
# str_replace_all(
#     pattern = r("\\\\subsubsection\\*?\\{(.*?)\\}"),
#     replacement = "\n### \\1"))  %>%
#
# str_replace_all(
#     pattern = r("\\\\frametitle\\*?\\{(.*?)\\}"),
#     replacement = section("=")) %>%
#
# str_replace_all(
#     pattern = r("\\\\framesubtitle\\*?\\{(.*?)\\}"),
#     replacement = section("-")) %>%
# ============================================================================



# # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# input       <- "C:/Users/ViG/Documents/GitHub/hyperSpec2/docs/articles/plotting/plotting.Rnw"
# output_file <- "Vignettes/_Rmd/plotting.Rmd"
# text <- read_file(input)
# text <- text %>% str_replace_all(r("\\\r"), "")
#
# write_file(text, path = output_file)
# # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




preamble_base <- c(
        '---
title:       {pr[["title"]]}
# subtitle:  {pr[["subtitle"]]}
# file_name: {pr[["file_name"]]}
# Authors --------------------------------------------------------------------
# author:    {pr[["author"]]}
author:
  - name: Claudia Beleites^1,2,3,4,5^
    email: chemometrie@beleites.de
    corresponding : yes
    affiliation   : |
        1. DIA Raman Spectroscopy Group, University of Trieste/Italy (2005--2008)
        2. Spectroscopy $\\cdot$ Imaging, IPHT, Jena/Germany (2008--2017)
        3. ÖPV, JKI, Berlin/Germany (2017--2019)
        4. Arbeitskreis Lebensmittelmikrobiologie und Biotechnologie, Hamburg University, Hamburg/Germany (2019 -- 2020)
        5. Chemometric Consulting and Chemometrix GmbH, Wölfersheim/Germany (since 2016)
# Document -------------------------------------------------------------------
date: {pr[["date"]]}
output:
    bookdown::html_document2:
      base_format: rmarkdown::html_vignette
      toc: yes
      fig_caption: yes
      css:
        - man/vignette.css
        - man/style.css
vignette: >
{vignette_txt}
# Citations/References -------------------------------------------------------
link-citations: yes
bibliography: man/{pr[["file_name"]]}-pkg.bib
biblio-style: plain
csl: man/elsevier-with-titles.csl
---


```{{r setup, include = FALSE}}
# Packages -------------------------------------------------------------------
library(hyperSpec)

# Functions ------------------------------------------------------------------
source("man/vignette-functions.R", encoding = "UTF-8")

# Settings -------------------------------------------------------------------
source("man/vignette-default-settingsR.R", encoding = "UTF-8")

# knitr::opts_chunk$set(
#   fig.path   = "man/figures/{pr[["file_name"]]}--"
# )
```

```{{r bib, echo=FALSE, paged.print=FALSE}}
make_bib(
  c(
    "hyperSpec"
  ),
  file = "man/{pr[["file_name"]]}-pkg.bib"
)
```

')


#'  Convert Rnw to Rmd
#'
#'  Does most of the job converting Sweave .Rnw files to R markdown .Rmd format.
#'  Not perfect, but good enough.
#'
#' @param input_file
#' @param output_file
#'
#' @return
#' @export
#'
#' @examples
#'
#' # // none //
#

latex2rmd <- function(input_file, output_file) {
    # Define function `r`, so that regex matches multilines and
    # new line symbols.
    # library(tidyverse)
    # library(magrittr)
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    r <- purrr::partial(
        stringr::regex,
        multiline = TRUE,
        dotall    = TRUE
    )

    section <- function(sym) {
        str_c("\n\\1\n", str_dup(sym, 70), "\n")
    }
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Read text
    # text <- readChar(input, file.info(input)$size)

    text <- read_file(input_file)
    text <- text %>% str_replace_all(r("\\\r"), "")

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    text <- text %>%
        # Special symbols / Enclosing symbols
        str_replace_all(c(
            "\\\\maketitle" = "",

            "\\\\,"                          = ' ',
            # "\\\\,"                        = ""                  ,

            "\\\\textasciitilde"             = '~',
            # "~\\s?~"                         = '~', # Šitą eilutę panaikinti
            "\\\\cdot"                       = '·', # FIXME: UTF-8 code is needed
            # "[^`]`{2}[^`]"                   = '"',
            # "[^']'{2}[^']"                   = '"',
            "([^`])`{2}([^`])"               = '\\1"\\2',
            "([^'])'{2}([^'])"               = '\\1"\\2',
            "\\\\&"                          = '&',
            "\\\\times"                      = '×', # FIXME: UTF-8 code is needed
            "\\\\textquotesgl\\{(.*?)\\}"    = "'",
            "\\\\textquotedbl\\{(.*?)\\}"    = '"',
            "\\\\textsuperscript\\{(.*?)\\}" = '^\\1^',
            "\\\\textsubscript\\{(.*?)\\}"   = '~\\1~',
            "\\\\Sexpr\\{(.*?)\\}"           = "`r \\1`",
            "\\\\textbf\\{(.*?)\\}"          = "**\\1**",

            "\\\\emph\\{(.*?)\\}"            = "*\\1*", #??? italic or bold)
            "\\\\textit\\{(.*?)\\}"          = "*\\1*"
        )) %>%

        str_replace_all(r("\\\\verb\\+(.*?)\\+"), '`\\1`')


    text <- text %>%
        str_replace_all(c(
            "\\\\(texttt|code)(\\[.*?\\])?\\{(.*?)\\}"                           = "`\\3`"      ,
            "\\\\(Rcode|Rfunarg|Robject|Rcommand|Rclass)(\\[.*?\\])?\\{(.*?)\\}" = "`\\3`{.r}"  ,
            "\\\\(Rpackage)(\\[.*?\\])?\\{(.*?)\\}"                              = "package **\\3**"  ,
            "\\\\(Rfunction)(\\[.*?\\])?\\{(.*?)\\}"                             = "`\\3()`{.r}",
            "\\\\(Rmethod)(\\[.*?\\])?\\{(.*?)\\}"                               = "`\\3()`{.r}",

            "\\s*\\\\begin\\{Sinput\\}"        =  "\n```{r}"                   ,
            "\\s*\\\\end\\{Sinput\\}"          =  "```\n"                      ,
            "\\s*\\\\begin\\{Schunk\\}"        =  ""                         ,
            "\\s*\\\\end\\{Schunk\\}"          =  ""                         ,
            "\\s*\\\\begin\\{Soutput\\}"       =  "<!-- \\\\begin{Soutput}"  ,
            "\\s*\\\\end\\{Soutput\\}"         =  "\\\\end{Soutput} -->"     ,
            "\\s*\\\\begin\\{Verbatim\\}"      =  "\n```"                      ,
            "\\s*\\\\end\\{Verbatim\\}"        =  "```\n"                      ,

            "\\\\ldots"                        = "..." ,
            # "\\\\ldots"                      = "\\.\\.\\." ,

            "\\\\label\\{"                     = " {#", # only for sections  # FIXME: ???

            "\\\\addcontentsline\\{(.*)\\}"    = ""                  ,
            "\\\\\\$"                          = "\\\\$"             ,
            "^(\\s*)%(.*)[^->]\\s*$"           = "\\1<!-- \\2 -->"   ,

            # Packages
            "\\\\deseqtwo\\{\\}"               =  "**`DESeq2`**"     ,

            "\\\\Biocexptpkg\\{(.*?)\\}"       =  '`r Biocexptpkg("\\1")`' ,
            "\\\\Biocannopkg\\{(.*?)\\}"       =  '`r Biocannopkg("\\1")`' ,
            "\\\\Biocpkg\\{(.*?)\\}"           =  '`r Biocpkg("\\1")`'     ,

            # Citation / Bibliography / References
            "\\\\cite\\{(.*?)\\}"              = "[\\@\\1]"          ,
            "\\\\cite\\<(.*?)\\>\\{(.*?)\\}"   = "[\\1 \\@\\2]"      ,
            "\\\\citeA\\{(.*?)\\}"             = "\\@\\1"            ,
            "\\\\citeNP\\{(.*?)\\}"            = "\\@\\1"            ,
            "\\\\citeNP\\<(.*?)\\>\\{(.*?)\\}" = "\\1 \\@\\2"        ,

            "\\\\ref\\{(.*?)\\}"               = "\\\\@ref(\\1)"     ,

            "\\\\footnote\\{(.*?)\\}"          = "^[\\1]"            ,

            "\\\\bibliography\\{(.*?)\\}"      = "# References {-}"  ,
            "\\\\bibliographystyle\\{(.*?)\\}" = ""

        )) %>%

        str_replace_all(
            pattern = r("<<(.*?)>>=(.*?\n)@\\s?"),
            replacement = "\n```{r \\1}\\2```\n") %>%

        str_replace_all(
            pattern = r("\\\\href\\{(.*?)\\}\\{(.*?)\\}"),
            replacement = "[\\2](\\1)") %>%

        str_replace_all(
            pattern = r("\\\\url\\{(.*?)\\}"),
            replacement = "<\\1>")

    # Section names --------------------------------------------------
    # \section*{Session Info}   →    \section{Session Info} {-}

    text <- text %>%

        str_replace_all(c(
            "\\s*\\\\section\\{(.*?)\\}"        =  "\n\n# \\1" ,
            "\\s*\\\\section\\*\\{(.*?)\\}"     =  "\n\n# \\1 {-}" ,
            "\\s*\\\\subsection\\{(.*?)\\}"     =  "\n\n## \\1",
            "\\s*\\\\subsubsection\\{(.*?)\\}"  =  "\n\n### \\1" ,
            "\\s*\\\\paragraph\\{(.*?)\\}"      =  "\n\n#### \\1",

            "\\s*\\\\frametitle\\{(.*?)\\}"     =  "\n\n# \\1",
            "\\s*\\\\framesubtitle\\{(.*?)\\}"  =  "\n\n## \\1",

            "\n\\s*\\{#sec:" = " {#sec:",
            "\\(\\)`\\{.r[: ](.*?)\\}" = "()`{.r}\\1" # fixes some inconsistencies

        )) %>%

        # Items of a list
        # text  %<>%
        str_replace_all(c(
            "\\\\begin\\{itemize\\}"              = "\n",
            "\\\\end\\{(itemize|labeling)\\}"     = "",
            "\\\\begin\\{labeling\\}\\{(.*?)\\}"  = "<!-- \\1 -->")) %>%

        str_replace_all(
            pattern = r("\\\\item\\[(.*?)\\]"),
            replacement = "- **\\1\\**") %>%

        str_replace_all(
            pattern = r("\\\\item"),
            replacement = "- ") %>%

        # Other
        # text  %<>%
        str_replace_all(
            pattern = r("\\\\end\\{frame\\}"),
            replacement = "---")  %>%

        # str_replace_all(
        #     pattern = r("\\\\\\\\"),
        #     replacement = "  ") %>%

        # text  %<>%
        str_replace_all(
            c(
                "\\\\\\\\" = "\n",
                "[\n]{3,}?" = "\n\n"# Remove multiple newlines
            )
        )

    # text  %<>%
    #     str_replace_all(
    #         pattern = r("\\\\begin\\{(.*?)\\}"),
    #         replacement = "")  %>%
    #
    #     str_replace_all(
    #         pattern = r("\\\\end\\{(.*?)\\}"),
    #         replacement = "")

    # hyperSpec specific repacements =========================================
    text <- text %>%

        str_replace_all(c(
            "\\\\(phy)" = "package **hyperSpec**", # package name
            "\\\\(chy)" = "`hyperSpec`{.r}",       # R class
            "\\\\df"    = "`data.frame`{.r}",
            "\\\\eg"    = "e.g.,",
            "\\\\ie"    = "i.e.,",
            "\\\\rcm"   = "$cm^{-1}$",
            "\\\\mum"   = "$\\mu m$",
            # "\\\\R"     = "**R**"
            "(\\<\\<.*?\\>\\>)" = "# \\1"
        )) %>%

        str_replace_all(
            pattern = r("\\s*\\\\plottab\\{(.*?)\\}\\{(.*?)\\}"),
            replacement = '\n<!-- "\\1" Fig. \\\\@ref(fig:\\2) -->'
        )

    # \newcommand{\mFun}[1]{\marginpar{\scriptsize \Rfunction{#1}}}

    # \author{%
    #     \Sexpr{sub ("[<].*$", "", maintainer ("hyperSpec"))}%
    #     \url{%
    #         \Sexpr{sub ("^.*[<]", "<", maintainer ("hyperSpec"))}%
    #     }\\
    #     \ DIA Raman Spectroscopy Group, University of Trieste/Italy (2005--2008)
    #     \ Spectroscopy $\cdot$ Imaging, IPHT, Jena/Germany (2008--2017)
    #     \ ÖPV, JKI, Berlin/Germany (2017--2019)
    #     \ Arbeitskreis Lebensmittelmikrobiologie und Biotechnologie, Hamburg University, Hamburg/Germany (2019--2020)
    #     \Chemometric Consulting and Chemometrix GmbH, Wölfersheim/Germany (since 2016)
    # }

    # ========================================================================

    # NA values must be replaced to "" or entries removed at all:
    pr <- list()
    pr[["title"]]     <- str_extract(text, "(?<=\\\\title\\{).*(?=\\})")
    pr[["subtitle"]]  <- str_extract(text, "(?<=pdfsubject=\\{).*?(?=\\},?)")
    pr[["file_name"]] <- str_extract(text, "(?<=pdftitle=\\{).*?(?=\\},?)")
    pr[["author"]]    <- str_extract(text, "(?<=pdfauthor=\\{).*?(?=\\},?)")
    pr[["keywords"]]  <- str_extract(text, "(?<=pdfkeywords=\\{).*?(?=\\},?)")

    pr[["date"]] <- '"`r Sys.Date()`"'

    # pr[['output']] <- "rmarkdown::html_vignette"

    pr$vignette <-
        (str_extract_all(text, "% \\\\Vignette.*")[[1]]) %>%
        c(
            "%\\VignetteEngine{knitr::rmarkdown}",
            "%\\VignetteEncoding{UTF-8}"
        )
    vignette_txt <- str_c("    ", pr$vignette, collapse = "\n")

    preamble <- str_glue(preamble_base)

    body <- str_extract(text, r("(?<=\\\\begin\\{document\\}).*(?=\\\\end\\{document\\})"))

    final <- structure(
        str_c(preamble, "\n", body),
        class = "glue"
    )

    write_file(final, path = output_file)

    # Additional fixing ------------------------------------------------------
    code_lines <- read_lines(output_file)

    is_code_block <- str_detect(code_lines, "```\\{r.*?\\}")

    code_lines[is_code_block] <-
        str_replace_all(code_lines[is_code_block], c(
            " ?= ?" = "=",
            " \\}"  = "}",
            " ?, ?" = ", ",
            "(results=)(.*?)([, }])" = "\\1'\\2'\\3",
            # ", results='tex'"        = "results='markup'",
            "fig=TRUE" = "fig.cap=CAPTION"
        ))

    is_code_block_bad <- str_detect(code_lines, "```\\{r.*?\\}.+")

    code_lines[is_code_block_bad] <- str_replace(
        code_lines[is_code_block_bad],
        "(```\\{r.*?\\})(.+)",
        "\n<!-- \\2 -->\n\\1"
    )

    is_fig_caption <- str_detect(code_lines, "fig.cap=CAPTION")

    code_lines[is_fig_caption] <- str_replace(
        code_lines[is_fig_caption],
        "(```\\{r.*?fig.cap=CAPTION.*?\\})",
        '\n\n```{r include=FALSE}\nCAPTION = " ??? "\n```\n\n\\1\n'
    )

    write_lines(code_lines, path = output_file)
}




# fs::file_show(output_file)


# txt3 <- "```{r check-required, echo = FALSE, results = tex}"
#
# str_replace_all(txt3, c(
#     " = "                    = "=",
#     "\\s*\\}"                = "}",
# ),

# )



# dir()
#
# in_txt <- read_lines(input)
# write_lines(in_txt, path = "Vignettes/_Rmd/plotting.Rmd")
# fs::file_show("Vignettes/_Rmd/plotting.Rmd")
# readr::write_lines(text, output)
# }



setwd("D:/Dokumentai/GitHub/R-2019--proj-stud/hyperSpec/vignettes")
# input   <- "plotting.Rnw"
# output  <- "plotting2.Rmd"
# latex2rmd(input, output)

# usethis::use_vignette("hyperspec")
# usethis::use_vignette("baseline")
# usethis::use_vignette("plotting")
# usethis::use_vignette("laser")
# usethis::use_vignette("flu")
# usethis::use_vignette("fileio")
# usethis::use_vignette("chondro")

base_names <- c(
    "hyperspec",
    "baseline",
    # "plotting",
    "laser",
    "flu",
    "fileio",
    "chondro"
)

all_files <- fs::path_ext_set(base_names, ext = rep(".Rmd", times = length(base_names)))

for (i in all_files) {
    input <- output <- i
    latex2rmd(input, output)
}

