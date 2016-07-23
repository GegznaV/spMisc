context("`Clear` family functions")

#  ------------------------------------------------------------------------

test_that("function `clear` clears all objects", {

    A <- 5
    B <- "s"
    D1 <- "string2"
    D2 <- "string3"
    L <- list(A,B)
    .test_clear    <- function() print(".test")
    `%test_clear%` <- function(a,b) print(paste(a,b))
    test_clear     <- function() print("test")

    expect_length(ls(), 7)
    expect_length(ls(all.names = TRUE), 8)

    clear()
    expect_length(ls(), 0)
    expect_length(ls(all.names = TRUE), 1)

    # Clear hidden
    clear(all.names = TRUE)
    expect_length(ls(), 0)
    expect_length(ls(all.names = TRUE), 0)

})

#  ------------------------------------------------------------------------

test_that("function `clear` clears listed objects", {

    A <- 5
    B <- "s"
    D1 <- "string2"
    D2 <- "string3"
    L <- list(A,B)
    .test_clear    <- function() print(".test")
    `%test_clear%` <- function(a,b) print(paste(a,b))
    test_clear     <- function() print("test")

    expect_length(ls(), 7)
    expect_length(ls(all.names = TRUE), 8)

    # Clear if quoted object name is provided
    clear("A")
    expect_length(ls(), 6)
    expect_length(ls(all.names = TRUE), 7)
    expect_false("A"   %in% ls())
    expect_true( "B"   %in% ls())

    # Clear if unquoted object name is provided
    clear(B)
    expect_length(ls(), 5)
    expect_length(ls(all.names = TRUE), 6)
    expect_false( "B"   %in% ls())

    # The first argument is ignored, as list is provided
    clear("D2", list = c(".test_clear", "%test_clear%"))
    expect_length(ls(), 4)
    expect_length(ls(all.names = TRUE), 4)
    expect_false( ".test_clear"   %in% ls(all.names = TRUE))
    expect_false( "%test_clear%"  %in% ls())
    expect_true( "D2"   %in% ls())

})

#  ------------------------------------------------------------------------


test_that("function `clear_all` works as expected",{
    A <- 5
    B <- "s"
    D1 <- "string2"
    D2 <- "string3"
    L <- list(A,B)
    .test_clear    <- function() print(".test")
    `%test_clear%` <- function(a,b) print(paste(a,b))
    test_clear     <- function() print("test")

    expect_length(ls(), 7)
    expect_length(ls(all.names = TRUE), 8)

    clear_all()
    expect_length(ls(), 0)
    expect_length(ls(all.names = TRUE), 0)
})

#  ------------------------------------------------------------------------


test_that("function `clear_hidden_only` works as expected",{
    A <- 5
    B <- "s"
    D1 <- "string2"
    D2 <- "string3"
    L <- list(A,B)
    .test_clear    <- function() print(".test")
    `%test_clear%` <- function(a,b) print(paste(a,b))
    test_clear     <- function() print("test")

    expect_length(ls(), 7)
    expect_length(ls(all.names = TRUE), 8)

    clear_hidden_only()
    expect_length(ls(), 7)
    expect_length(ls(all.names = TRUE), 7)
})


#  ------------------------------------------------------------------------

test_that("function `clear_fun` works as expected",{

    A <- 5
    B <- "s"
    D1 <- "string2"
    D2 <- "string3"
    L <- list(A,B)
    .test_clear    <- function() print(".test")
    `%test_clear%` <- function(a,b) print(paste(a,b))
    test_clear     <- function() print("test")

    expect_length(ls(), 7)
    expect_length(ls(all.names = TRUE), 8)

    clear_fun()
    expect_length(ls(), 5)
    expect_length(ls(all.names = TRUE), 5)
})


#  ------------------------------------------------------------------------
test_that("function `clear_except` throws warinig",{
    # Does not clear and warns
    expect_warning(clear_except())
})

#  ------------------------------------------------------------------------
test_that("function `clear_except` works (quoted inputs)",{

    A <- 5
    B <- "s"
    D1 <- "string2"
    D2 <- "string3"
    L <- list(A,B)
    .test_clear    <- function() print(".test")
    `%test_clear%` <- function(a,b) print(paste(a,b))
    test_clear     <- function() print("test")

    expect_length(ls(), 7)
    expect_length(ls(all.names = TRUE), 8)

    # Clear if quoted object name is provided
    clear_except("A")
    expect_length(ls(), 1)
    expect_length(ls(all.names = TRUE), 2)
    expect_true("A"   %in% ls())
    expect_false( "B" %in% ls())
    expect_true(".test_clear"   %in% ls(all.names = TRUE))


})

#  ------------------------------------------------------------------------
test_that("function `clear_except` works (unquoted inputs)",{

    A <- 5
    B <- "s"
    D1 <- "string2"
    D2 <- "string3"
    L <- list(A,B)
    .test_clear    <- function() print(".test")
    `%test_clear%` <- function(a,b) print(paste(a,b))
    test_clear     <- function() print("test")

    expect_length(ls(), 7)
    expect_length(ls(all.names = TRUE), 8)

    # Clear if unquoted object name is provided
    clear_except(B)
    expect_length(ls(), 1)
    expect_length(ls(all.names = TRUE), 2)
    expect_true( "B"   %in% ls())


})


#  ------------------------------------------------------------------------
test_that("function `clear_except` works (inputs as a list)",{

    A <- 5
    B <- "s"
    D1 <- "string2"
    D2 <- "string3"
    L <- list(A,B)
    .test_clear    <- function() print(".test")
    `%test_clear%` <- function(a,b) print(paste(a,b))
    test_clear     <- function() print("test")

    expect_length(ls(), 7)
    expect_length(ls(all.names = TRUE), 8)

    # Clear if unquoted object name is provided
    clear_except(B, list = c("A", ".test_clear"))
    expect_length(ls(), 1)
    expect_length(ls(all.names = TRUE), 2)
    expect_false("B"   %in% ls())
    expect_true("A"    %in% ls())
    expect_true(".test_clear"   %in% ls(all.names = TRUE))

})

#  ------------------------------------------------------------------------

test_that("function `clear_except_class` works as expected",{

    A <- 5
    B <- "s"
    D1 <- "string2"
    D2 <- "string3"
    L <- list(A,B)
    .test_clear    <- function() print(".test")
    `%test_clear%` <- function(a,b) print(paste(a,b))
    test_clear     <- function() print("test")

    expect_length(ls(), 7)
    expect_length(ls(all.names = TRUE), 8)

    # Do not clear if no class is provided
    expect_warning(clear_except_class())
    expect_length(ls(), 7)
    expect_length(ls(all.names = TRUE), 8)

    # Clear functions
    clear_except_class("character")
    expect_length(ls(), 3)
    expect_length(ls(all.names = TRUE), 4)

    expect_false("L" %in% ls())
    expect_true("B" %in% ls())
    # Does not clear hidden
    expect_true(".test_clear"   %in% ls(all.names = TRUE))
})


test_that("function `clear_class` works as expected",{

    A <- 5
    B <- "s"
    D1 <- "string2"
    D2 <- "string3"
    L <- list(A,B)
    .test_clear    <- function() print(".test")
    `%test_clear%` <- function(a,b) print(paste(a,b))
    test_clear     <- function() print("test")

    expect_length(ls(), 7)
    expect_length(ls(all.names = TRUE), 8)

    # Does not clear and warns
    expect_warning(clear_class())
    expect_length(ls(), 7)
    expect_length(ls(all.names = TRUE), 8)

    # Clear one class
    clear_class("function")
    expect_length(ls(), 5)
    expect_length(ls(all.names = TRUE), 6)
})

