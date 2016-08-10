# Get structural parts of file name
#
# Get parts of a file name: a directory, a filename without extension and
# directory name and an extension without leading period.
# Similar to MATLAB's function "fileparts"
#
# @param x A sting or a vector of strings with filenames
#
# @return
# A list with fields \code{path} for directory/folder name,
# \code{filename} for filename (without extension),
# and \code{extension} for file extension (without leading period).
#
# @export
#
# @examples
# library(spMisc)
#
# fileparts("c:/tata.txt")
# fileparts("c:/tata.txt")$dir

# fileparts  <- function(x){
#     rez <- list() # container for results
#     rez$path      <- dirname(x)
#     name_with_ext <- basename(x)
#     rez$filename  <- sub("(.*)\\.(.*?)$", "\\1", name_with_ext)
#     rez$extension <- sub("(.*)\\.(.*?)$", "\\2", name_with_ext)
#     return(rez)
# }
