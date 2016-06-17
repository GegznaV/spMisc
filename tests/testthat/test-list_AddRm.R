context("Function list_AddRm")

test_that("list_AddRm works", {
    rez <- list_AddRm(1:2,2:3)
  expect_equal(rez$REMOVED, 1)
  expect_equal(rez$ADDED, 3)

  rez2 <- list_AddRm(2,2)
  expect_equal(rez2$REMOVED, NULL)
  expect_equal(rez2$ADDED, NULL)

  expect_is(rez2, "list")
})
