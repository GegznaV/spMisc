context("Function fCap")


test_that("fCap() works", {
    expect_equal(fCap('laa laa laa'), "Laa Laa Laa")
    expect_equal(fCap('LAA LAA LAA'), 'LAA LAA LAA')
})
