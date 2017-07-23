#' Add new class attributes to an object
#'
#' @param x An object
#' @param new_class (\code{character})\cr
#'                 A character vector with classes to add.
#'
#' @return The same object \code{x} with new classes added.
#' @export
#'
#' @examples
#' x <- data.frame()
#' y <- class_add(x, "meow")
#' class(y)
#'
#' # The same class does not repeat if added several times
#' y2 <- class_add(x, c("meow" , "meow"))
#' class(y2)
class_add <- function(x, new_class) {
    class(x) <-
        c(new_class, class(x))  %>%
        union(class(x))
    x
}
