context("Functions which.in.*()")

## TODO: Rename context
## TODO: Add more tests

test_that("which.in.*() works", {
    m1 <- matrix(NA, 5, 6)

  expect_equal(which.in.diag(m1), c(1,7,13,19,25))

  i1 <- which.in("diag",    m1)
  expect_length(i1, 5)

  i2 <- which.in("offdiag", m1)
  expect_length(i2, 25)


  i3 <- which.in("col", m1, col = 2)
  expect_equal(i3, c(6:10))


  i4 <- which.in("row", m1, row = 2)
  expect_equal(i4, c(2,  7, 12, 17, 22, 27))


  i5 <- which.in("trilow", m1)
  expect_length(i5, 10)

  i6 <- which.in("trilow", m1, diag = TRUE)
  expect_length(i6, 15)

  i7 <- which.in("triupp", m1)
  expect_length(i7, 15)

  # None should match
  expect_equal(sum(i7  %in%  i5), 0)

})
