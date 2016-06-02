#' [+] List all functions in a package
#'
#' List all functions in a package and return it as a data frame.
#'
#' @param Package A name of a package. Default \code{Package = "spMisc"}.
#'
#' @return A data frame with function names in a package.
#' @export
#'
#' @examples
#'
#' list_functions()
#' list_functions(Package = "magrittr")
#'
#' @author Vilmantas Gegzna
#'
list_functions <- function(Package = "spMisc")   {
    # Main function
    FunctionList <- unclass(lsf.str(envir = asNamespace(Package),
                                    all = TRUE))

    # Annotations
    df <- data.frame(Functions = FunctionList)
    names(df) <- paste0("Functions in ",
                        Package,
                        " (",packageVersion(Package),")")

    # Return
    return(df)
}

