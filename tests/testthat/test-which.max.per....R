context("Functions which.max.perCol/perRow")


#  ------------------------------------------------------------------------

test_that("which.max.perRow works", {
    set.seed(1)
    Clusters <- kmeans(iris[,-5], 3)$cluster
    Species <- iris$Species

    TABLE <- table(Species, Clusters)
    # test that set.seed works
    expect_equal(diag(TABLE), c(50, 2, 14))

    # test that which.max.perRow works
    ind <- which.max.perRow(TABLE)
    expect_equal(ind, c(1,8,6))

    # If Na values exist .... TEST INCOMPLETE
    TABLE[1,1] = NA


})

#  ------------------------------------------------------------------------


test_that("which.max.perCol works", {
    set.seed(1)
    Clusters <- kmeans(iris[,-5], 3)$cluster
    Species <- iris$Species

    TABLE <- table(Species, Clusters)
    # test that set.seed works
    expect_equal(diag(TABLE), c(50, 2, 14))

    # test that which.max.perCol works
    ind <- which.max.perCol(TABLE)
    expect_equal(ind, c(1,6,8))

    # If Na values exist .... TEST INCOMPLETE
    TABLE[1,1] = NA


})

#  ------------------------------------------------------------------------


test_that("which.max.all works", {
    x <- c(1,2,1,3,3,2,1)
    expect_equal(which.max.all(x), 4:5)
})

#  ------------------------------------------------------------------------


test_that("which.min.all works", {
    x <- c(1,2,1,3,3,2,1)
    expect_equal(which.min.all(x), c(1,3,7))

})

#  ------------------------------------------------------------------------


