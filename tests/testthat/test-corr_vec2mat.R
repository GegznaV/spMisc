context("Function corr_vec2mat()")

## TODO: Rename context
## TODO: Add more tests

test_that("corr_vec2mat() works", {
    vector = c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6)
    M <- corr_vec2mat(vector)

    # All ones on diagonal
    expect_equal(mean(diag(M)), 1)

    # Symetric
    expect_equal(M[4,3], M[3,4])
    expect_equal(M[2,1], M[1,2])

    # Values are placed in correct order
    expect_equal(M[1, ], c(1.0, 0.1, 0.2, 0.3))
})

test_that("corr_vec2mat() throw warnings and errors", {
    vector = c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6)
    M <- corr_vec2mat(vector)

    vector2 = c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7)

    # Warning and reduced size of vector
    expect_warning(M2 <- corr_vec2mat(vector2))
    expect_equal(dim(M2), dim(M))

    # Values are not between [-1 and 1]
    expect_error(corr_vec2mat(2))
    expect_error(corr_vec2mat(-1.12))

    # Missing input
    expect_error(corr_vec2mat())})
