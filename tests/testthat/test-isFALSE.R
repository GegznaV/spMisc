context("Function isFALSE() and ifFALSE ()")

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

test_that("ifFALSE works", {
    expect_true(ifFALSE(FALSE, TRUE, FALSE))
    expect_false(ifFALSE(TRUE, TRUE, FALSE))
    expect_false(ifFALSE(NULL, TRUE, FALSE))
    expect_false(ifFALSE("a",  TRUE, FALSE))
    expect_false(ifFALSE(1,    TRUE, FALSE))
    expect_false(ifFALSE(list(2),  TRUE, FALSE))
})
