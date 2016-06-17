context("isFALSE")

## TODO: Rename context
## TODO: Add more tests

test_that("isFALSE works", {
  expect_true(isFALSE(FALSE))
  expect_false(isFALSE(TRUE))
  expect_false(isFALSE(NULL))
  expect_false(isFALSE("a"))
  expect_false(isFALSE(1))
  expect_false(isFALSE(list()))
})
