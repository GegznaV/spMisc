#' Mask NA values with other symbol
#'
#' Replace (i.e. mask) NA values with other symbol
#'
#' @param obj an objecta, that may have \code{NA} values
#' @param replacement a replacement for \code{NA} values. default is spece (\code{" "}).
#'
#' @return the same object with NA values replaced.
#' @export
#'
#' @examples
#'
#' library(pander)
#' library(magrittr)
#'
#' summary(CO2[,3:4])  %>% pander()
#' summary(CO2[,3:4])  %>% na.replace() %>% pander()
#'
#'
na.replace <- function(obj, replacement = " "){
    obj[is.na(obj)] <- replacement
    return(obj)
}
