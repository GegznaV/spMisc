#' [.] Find and display added and removed names
#'
#' @param initial A charecter vector with initial names.
#' @param final A charecter vector with final names.
#'
#' @return A list with added and removed names
#' @export
#'
#' @family \pkg{spMisc} utilities
#' @author Vilmantas Gegzna
#'
list_AddRm <- function(initial, final) {
    Names <- list()
    Names$REMOVED <- initial[!(initial %in% final)]
    Names$ADDED   <-   final[!(final   %in% initial)]

    f1 <- function(x) if (length(x) == 0) NULL else x
    Names <- lapply(Names,f1)
    # if (length(Names$ADDED) > 0 ) {
    #     message("These columns were ADDED to the `hyperSpec` object:")
    #     cat(Names$ADDED,sep = '\n')
    # }
    #
    # if (length(Names$REMOVED) > 0 ) {
    #     message("These columns were REMOVED from the `hyperSpec` object:")
    #     cat(Names$REMOVED,sep = '\n')
    # }
    return(Names)
}
