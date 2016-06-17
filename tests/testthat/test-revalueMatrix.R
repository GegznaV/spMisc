context("Function revalueMatrix")


test_that("revalueMatrix() works", {
    x0  <- matrix(NA, 2, 6)
    x1  <- revalueMatrix(x0, 1:12)
    x2  <- matrix(1:12, 2, 6)

    expect_equal(x1,  x2)
    expect_length(x1, 12)
    expect_equal(x1[4], 4)
})
