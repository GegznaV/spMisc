context("Function eval_glue")

test_that("eval_glue works", {
    rm(list = ls())
    AA <- "nn"

    eval_glue("{AA} <- 3")

    expect_equal(nn, 3)
    expect_equal(AA, "nn")
})
