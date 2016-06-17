context("Function make.filenames()")


test_that("make.filenames works", {
    s <- '\\ / : * ? " < > |'
  expect_equal(make.filenames(s), "_ _ _ _ _ _ _ _ _")
  expect_equal(make.filenames(s, allow.space = FALSE), "_________________")

  s2 <- "/Hello?"

  expect_equal(make.filenames(s2), "_Hello_")
  expect_equal(make.filenames(s2,replacement = "-"), "-Hello-")

  # Unallowed sybol
  expect_error(make.filenames(s2,replacement = "*"))
  expect_error(make.filenames(s2,replacement = "/"))
  expect_error(make.filenames(s2,replacement = "\\"))
  expect_error(make.filenames(s2,replacement = "\""))
  expect_error(make.filenames(s2,replacement = "*"))

})
