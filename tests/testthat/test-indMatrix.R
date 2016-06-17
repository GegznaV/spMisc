context("Function indMatrix")

test_that("indMatrix works", {
    expect_equal(indMatrix(matrix(NA, 2, 5)),  matrix(1:10, 2,5))
    expect_equal(indMatrix(matrix(4:6, 5, 3)), matrix(1:15, 5,3))
})
