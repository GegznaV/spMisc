# @param ID Name of a new column, that contains ID of each original list element.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Rowbind dataframes, which are elements of a named list
#'
#' @param x a named list, that contain dataframes that have columns with the same names.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#'
#' LIST <- split(chickwts, chickwts$feed)
#' new_DF <- rbind_df_in_list(LIST)
#'
#' head(chickwts)
#'
#' #    weight      feed
#' #  1    179 horsebean
#' #  2    160 horsebean
#' #  3    136 horsebean
#' #  4    227 horsebean
#' #  5    217 horsebean
#' #  6    168 horsebean
#'
#'
#' head(new_DF)
#'
#' #    .group weight   feed
#' # 1 casein    368 casein
#' # 2 casein    390 casein
#' # 3 casein    379 casein
#' # 4 casein    260 casein
#' # 5 casein    404 casein
#' # 6 casein    318 casein
#'
rbind_df_in_list <- function(x){
    if (!is.list(x)) stop("`x` must be a list.")

    DF <- x  %>%
        do.call(rbind, .)     %>%
        dplyr::mutate(.group = rownames(.))  %>%
        # Remove numbers, added in `do.call(rbind, .)`
        tidyr::separate(col   = .group,
                        into = ".group",
                        sep = "\\.\\d*$",
                        extra = "drop") %>%
        # .group as 1-st column
        dplyr::select_(.dots = c(".group", colnames(.)[1:(ncol(.) - 1)]))

    rownames(DF) <- NULL

    DF
}
