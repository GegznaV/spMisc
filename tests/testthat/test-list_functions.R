context("Function list_functions()")

## TODO: Rename context
## TODO: Add more tests

test_that("list_functions() works", {

  expect_gt(length(list_functions()[[1]]),1)
  expect_true("list_functions"  %in% list_functions()[[1]])

  expect_true("rm"  %in% list_functions("base")[[1]])

})
