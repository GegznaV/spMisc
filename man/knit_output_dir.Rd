% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/knit_output_dir.R
\name{knit_output_dir}
\alias{knit_output_dir}
\title{knit_output_dir}
\usage{
knit_output_dir(output_dir = ".")
}
\arguments{
\item{output_dir}{(character)}
}
\description{
knit_output_dir
}
\details{
this function does not work as expected!
}
\examples{
# In YAML header or R markdown file:
#
# ---
# knit: (spMisc::knit_output_dir(output_dir = "some_dir/")(inputFile, encoding))
# ---

# ---
# knit: (function(inputFile, encoding, ...) {
#         rmarkdown::render(inputFile, encoding = encoding,
#         output_dir = "some_dir/")
#     })
# ---

}
