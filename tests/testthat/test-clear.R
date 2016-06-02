context("`Clear` family functions")

test_that("function `clear` works as expected",{

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
})


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

