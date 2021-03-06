% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/html_add_line_to_head.R
\name{html_add_line_to_head}
\alias{html_add_line_to_head}
\title{Add a line of text in the last line of an HTML file head}
\usage{
html_add_line_to_head(filename, line_to_add, locale = readr::default_locale())
}
\arguments{
\item{filename}{(string(1)) \cr name of an HTML file.}

\item{line_to_add}{(string(1)) \cr text to be added.}

\item{locale}{Information of locale, produced by, e.g.,
\code{readr::default_locale()}. More about locales:
 \link[readr]{locale}.}
}
\value{
A message, if the line was added.
}
\description{
Add a line of text in the last line of an HTML file head
}
\examples{

# add_line_to_html_head("index.html", "<br>")
}
\seealso{
html_enable_favicons
}
\author{
Vilmantas Gegzna
}
