context("Functions nDiag2nTri() and nTri2nDiag()")


test_that("nDiag2nTri() works", {
  expect_equal(nDiag2nTri(10), 45)
  expect_equal(nDiag2nTri(6), 15)
})

test_that("nTri2nDiag() works", {
    expect_equal(nTri2nDiag(10), 5)
    expect_equal(nTri2nDiag(6), 4)
    expect_gt(nTri2nDiag(7), 4.27)
    expect_lt(nTri2nDiag(7), 4.28)

})
