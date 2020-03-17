# Copyright 2017 Meik Michalke <meik.michalke@hhu.de>
# https://github.com/unDocUMeantIt/roxyPackage/blob/master/R/rnw2rmd.R
#
#
# This file is part of the R package roxyPackage.
#
# roxyPackage is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# roxyPackage is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with roxyPackage.  If not, see <http://www.gnu.org/licenses/>.

#' Convert vognettes from *.Rnw to *.Rmd
#'
#' This is a much enhanced R port of Perl code gists from GitHub [1, 2].
#' It tries its best to convert old Sweave vignettes into R markdown.
#' Please do not expect it to do wonders, but to give you a good starting point
#' for conversions.
#'
#' @param file Path to an *.Rnw file to convert.
#' @param output Character string defining the R markdown output format.
#' @param output_options A named character vector with additional options. If you need
#'    more than the default indentaion, you have to provide it directly (see default
#'    values for \code{toc_float}).
#' @param engine Character string defining the \code{VignetteEngine} value.
#' @param csl Character string defining a CSL style file for the bibliography.
#'    Please note that you will have to provide an existing file of that name in an
#'    appropriate location, like the *.Rmd file's directory. Ignored if \code{NULL},
#'    or if no bibliography was detected.
#' @param eval Logical, a default value for all R code chunks that are found. This is
#'    like a safety net to be able to disable all code by default. Setting the default
#'    value will be omitted if set to \code{NULL}.
#' @param replace An optional list of named character vectors with regular expressions
#'    to do custom replacements in the text body. The list must contain vectors with
#'    two character elements named \code{from} and \code{to}, to define what expressions
#'    should be replaced and with what.
#' @param flattr_id Character string, the ID value of your Flattr meta tag. If set will be
#'    added to the header of the resulting HTML file of the vignette.
#' @param write_file Logical, if set to \code{TRUE} results will be written to a file in
#'    the same directory as the input \code{file}, but with *.Rmd file ending. Default is
#'    \code{FALSE}, meaning results are returned as a character string.
#' @param overwrite Logical, whether existing files should be overwritten if \code{write_file=TRUE}.
#' @export
#' @references
#'  [1] https://gist.github.com/mikelove/5618f935ace6e389d3fbac03224860cd
#'
#'  [2] https://gist.github.com/lgatto/d9d0e3afcc0a4417e5084e5ca46a4d9e
#' @examples
#' \dontrun{
#' rnw2rmd(file.path(find.package("roxyPackage"), "doc", "roxyPackage_vignette.Rnw"))
#'
#' # use a fancy theme (not so good for CRAN, bloats the HTML file)
#' rnw2rmd(
#'   file.path(find.package("roxyPackage"), "doc", "roxyPackage_vignette.Rnw"),
#'   output = "html_document",
#'   output_options = c(
#'     theme = "cerulean",
#'     highlight = "kate",
#'     toc = "true",
#'     toc_float = "\\n      collapsed: false\\n      smooth_scroll: false",
#'     toc_depth = 3
#'   )
#' )
#' }
rnw2rmd <- function(
    file,
    output         = "rmarkdown::html_vignette",
    output_options = c(toc = "true"),
    engine         = "knitr::rmarkdown",
    csl            = NULL
    ) {

    txt <- txt_body <- readLines(file)

    title           <- which(grepl("\\\\title{",             txt, perl = TRUE))
    author          <- which(grepl("\\\\author{",            txt, perl = TRUE))


    bibliography    <- which(grepl("^\\s*\\\\bibliography{", txt, perl = TRUE))

    usepackage      <- which(grepl("\\\\usepackage",         txt, perl = TRUE))

    begin_document  <- which(grepl("\\\\begin{document}",    text, perl = TRUE))
    end_document    <- which(grepl("\\\\end{document}",      text, perl = TRUE))



    if (isTRUE(begin_document > 0)) {
        body_start_line <- begin_document + 1
        body_end_line   <- ifelse(isTRUE(end_document > 0), (end_document - 1), length(text))
        txt_body        <- text[body_start_line:body_end_line]
    }

    begin_abstract <- which(grepl("\\\\begin{abstract}",     txt_body, perl = TRUE))
    end_abstract   <- which(grepl("\\\\end{abstract}",       txt_body, perl = TRUE))

    preamble <- list()


    if (isTRUE(bibliography > 0)) {
        preamble[["bibliography"]] <-
            gsub("\\\\bibliography{(.+?)}", "\\1.bib", txt[[bibliography]], perl = TRUE)
        if (!is.null(csl)) {
            preamble[["csl"]] <- csl
        }
    }

    if (isTRUE(begin_abstract > 0)) {
        abstract_text <- txt_body[c((begin_abstract + 1):(end_abstract - 1))]
        for (thisPat in pat) {
            abstract_text <- gsub(thisPat[["from"]], thisPat[["to"]], abstract_text, perl = TRUE)
        }
        preamble[["abstract"]] <- paste0(">\n  ", paste(abstract_text, collapse = "\n  "))
        txt_body <- txt_body[-c((begin_abstract):(end_abstract))]
    }

    preamble[["vignette"]] <- paste(
        ">",
        paste0(txt[vignette_meta], collapse = "\n  "),
        paste0("%\\VignetteEngine{", engine, "}"),
        paste0(txt[usepackage], collapse = "\n  "),
        sep = "\n  "
    )

    for (thisPat in pat) {
        txt_body <- gsub(thisPat[["from"]], thisPat[["to"]], txt_body, perl = TRUE)
    }

    txt_body <- nested_env(txt = txt_body)

    # clean up multiple newlines
    # txt_body <- gsub("[\\\n]{3,}?", "\\\n\\\n", txt_body, perl = TRUE)

    txt_body

    return(txt_body)
} ## end function rnw2rmd()


## internal function nested_env()
# iterates through a character vector and tries to replace
# itemize or enumerate blocks with R markdown equivalents
nested_env <- function(txt) {
    begin_itemize   <- paste0("\\s*\\\\begin{itemize}\\s*")
    begin_enumerate <- paste0("\\s*\\\\begin{enumerate}\\s*")
    level <- 0
    enum  <- 0
    envir_in <- ""
    for (thisTxtNum in 1:length(txt)) {
        if (isTRUE(grepl(begin_itemize, txt[thisTxtNum], perl = TRUE))) {
            envir_in <- "itemize"
            level <- level + 1
            txt[thisTxtNum] <- gsub(begin_itemize, "", txt[thisTxtNum], perl = TRUE)
        } else if (isTRUE(grepl(begin_enumerate, txt[thisTxtNum], perl = TRUE))) {
            envir_in <- "enumerate"
            enum <- 0
            level <- level + 1
            txt[thisTxtNum] <- gsub(begin_enumerate, "", txt[thisTxtNum], perl = TRUE)
        } else {}
        if (isTRUE(grepl("\\\\item", txt[thisTxtNum], perl = TRUE))) {
            if (level > 2) {
                warning("list depths of more than two levels are not supported in Rmarkdown, reducing to two levels -- please check!")
            } else {}
            if (envir_in %in% "itemize") {
                indent <- switch(as.character(level),
                    "0" = "",
                    "1" = "* ",
                    "2" = "    + ",
                    "    + "
                )
                txt[thisTxtNum] <- gsub("\\s*\\\\item[(.+?)]\\s*", indent, txt[thisTxtNum], perl = TRUE)
                txt[thisTxtNum] <- gsub("\\s*\\\\item\\s*", indent, txt[thisTxtNum], perl = TRUE)
            } else if (envir_in %in% "enumerate") {
                message(level)
                enum <- enum + 1
                if (level > 1) {
                    indent <- paste0("    ", letters[enum], ". ")
                } else if (level > 0) {
                    indent <- paste0(enum, ". ")
                } else {
                    indent <- ""
                }
                txt[thisTxtNum] <- gsub("\\s*\\\\item\\s*", indent, txt[thisTxtNum], perl = TRUE)
            }
        }

        if (envir_in %in% c("itemize", "enumerate")) {
            envir_end <- paste0("\\s*\\\\end{", envir_in, "}\\s*")
            if (isTRUE(grepl(envir_end, txt[thisTxtNum], perl = TRUE))) {
                level <- level - 1
                txt[thisTxtNum] <- gsub(envir_end, "", txt[thisTxtNum], perl = TRUE)
            }
        }
    }
    if (level != 0) {
        warning("looks like we were not able to correctly detect all levels of ", envir_in, " environments. is the input document valid?")
    } else {}
    return(txt)
} ## end internal function nested_env()


## internal function flattr_header()
flattr_header <- function(output_options, flattr_id = FALSE,  output = "rmarkdown::html_vignette") {

    result <- list()
    if (all(!is.null(flattr_id), isTRUE(output %in% c("html_document", "rmarkdown::html_vignette", "html_vignette")))) {
        result[["output_options"]] <- c(output_options, includes = paste0("\n      in_header: vignette_header.html"))
        result[["r_setup"]] <- paste0(
            "\n```{r setup, include=FALSE}\n",
            "header_con <- file(\"vignette_header.html\")\n",
            "writeLines('<meta name=\"flattr:id\" content=\"", flattr_id, "\" />', header_con)\n",
            "close(header_con)\n```\n"
        )
    } else {
        result[["output_options"]] <- output_options
        result[["r_setup"]] <- ""
    }
    return(result)
} ## end internal function flattr_header()

