context("Function `eval_`")

test_that("`eval_` works as expected",{
    a1 <- 123
    a2 <- 987
    expect_true(a1 != a2)
    eval_("a2 <- a1")
    expect_true(a1 == a2)

    # clean up
    rm(a1, a2)
})

test_that("parameter `envir` in function `eval_` works as expected",{
    ENV <- new.env()
    expect_length(ls(name = ENV), 0)

    assign("a1", 123, envir = ENV)
    assign("a2", 987, envir = ENV)
    expect_length(ls(name = ENV), 2)

    expect_true(ENV$a1 != ENV$a2)

    eval_("a2 <- a1",envir = ENV)
    expect_true(ENV$a1 == ENV$a2)

    # clean up
    rm(ENV)
})
