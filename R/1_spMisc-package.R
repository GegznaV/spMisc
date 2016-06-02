#' @name spMisc
#'
#' @title Extension for `spMisc` and convenience functions
#'
#' @docType package
#'
#' @description
#'
#' [+] - function is well described. \cr
#' [!] - a description is incomplete and needs revision.\cr\cr
#'
#' Functions in \code{spMisc} by topic
#'
#' @section Regular expressions:
#'
#' \code{\link{regcapturedmatches}} \cr
#' \code{\link{regexp2df}} \cr
#'
#'
#' @section Various:
#'
#'
#' \code{\link{bru}} \cr
#' \code{\link{fCap}} \cr
#' \code{\link{make_firstCapitals}} \cr
#' \code{\link{list_functions}} \cr
#'
#'
#' @author Vilmantas Gegzna
#'
#' @examples
#'
#' \donttest{
#' \dontrun{
#'
#' # List all functions in package:
#'
#' list_functions()
#'
#' # Plot structure of functions inside the package:
#' require(sna)
#' require(mvbutils)
#'
#' pkgFW <- mvbutils::foodweb(where="package:spMisc", cex=0.7, charlim=60)
#' sna::gplot(pkgFW$funmat, g = 9,
#'            jitter = T,
#'            # mode = "mds",
#'            label.cex = .6,
#'            diag=TRUE,
#'            vertex.cex=1:2,
#'            displaylabels=TRUE,
#'            label.bg="gray90")
#'
#'
#' }}
#'
#'
#' @import magrittr

#'
NULL
#> NULL

# \code{\link{}} \cr
# \code{\link{}} \cr
# \code{\link{}} \cr
# \code{\link{}} \cr
# \code{\link{}} \cr
# \code{\link{}} \cr
# \code{\link{}} \cr
# \code{\link{}} \cr
# @importFrom tidyr '%>%'
