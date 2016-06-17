context("Functions in file sort_matrix_elements")

## TODO: Rename context
## TODO: Add more tests

test_that("`sort_descOnDiag` works", {
    set.seed(1)
    Clusters <- kmeans(iris[,-5], 3)$cluster
    Species <- iris$Species

    TABLE <- table(Species, Clusters)
    # test that set.seed works
    expect_equal(diag(TABLE), c(50, 2, 14))

    # test that sort_descOnDiag works
    TABLE_best_match <- sort_descOnDiag(TABLE)
    expect_equal(diag(TABLE_best_match), c(50, 48, 36))

    # If NA values exist
    TABLE[1,1] = NA
    TABLE_best_match_NA <- sort_descOnDiag(TABLE)
    expect_equal(diag(TABLE_best_match_NA), c(48, 36, NA))

})

test_that("Parameter `ties` in `sort_descOnDiag` works", {
    # Row-wise importance
    Matrix <- matrix(c(3,0,0,2,3,0,0,0,5),3,3)
    MatrixBM1 <- sort_descOnDiag(Matrix, importance = 1)
    expect_true(all(MatrixBM1[3,] == c(0, 2, 3)))

    # Column-wise importance
    Matrix <- matrix(c(3,0,0,2,3,0,0,0,5),3,3)
    MatrixBM2 <- sort_descOnDiag(Matrix, importance = 2)
    expect_true(all(MatrixBM2[,3] == c(0, 2, 3)))

})


test_that("sort_colSums works", {
    set.seed(1)
    Clusters <- kmeans(iris[,-5], 3)$cluster
    Species <- iris$Species

    TABLE <- table(Species, Clusters)
    # test that set.seed works
    expect_equal(diag(TABLE), c(50, 2, 14))

    # test that sort_colSums works
    TABLE2 <- sort_colSums(TABLE)
    expect_true(all(TABLE2[3,] == c(14,0,36)))

    # If Na values exist
    TABLE[1,1] = NA
    TABLE3 <- sort_colSums(TABLE)
    expect_true(all(TABLE3[3,] == c(14,36,0)))

})

test_that("sort_rowSums works", {
    set.seed(1)
    Clusters <- kmeans(iris[,-5], 3)$cluster
    Species <- iris$Species

    TABLE <- table(Species, Clusters)
    # test that set.seed works
    expect_equal(diag(TABLE), c(50, 2, 14))

    # test that sort_rowSums works
    TABLE2 <- sort_rowSums(TABLE)
    expect_true(all(TABLE2[3,] == c(0,36,14)))

    # If Na values exist
    TABLE[1,1] = NA
    TABLE3 <- sort_rowSums(TABLE)
    expect_true(all(TABLE3[2,] == c(0,36,14)))

})


test_that("sort_rowMax works", {
    set.seed(1)
    Clusters <- kmeans(iris[,-5], 3)$cluster
    Species <- iris$Species

    TABLE <- table(Species, Clusters)
    # test that set.seed works
    expect_equal(diag(TABLE), c(50, 2, 14))

    # test that sort_rowMax works
    TABLE2 <- sort_rowMax(TABLE)
    expect_true(all(TABLE2[3,] == c(0,36,14)))

    # If Na values exist
    TABLE[1,1] = NA
    TABLE3 <- sort_rowMax(TABLE)
    expect_true(all(TABLE3[2,] == c(0,36,14)))

})

test_that("sort_colMax works", {
    set.seed(1)
    Clusters <- kmeans(iris[,-5], 3)$cluster
    Species <- iris$Species

    TABLE <- table(Species, Clusters)
    # test that set.seed works
    expect_equal(diag(TABLE), c(50, 2, 14))

    # test that sort_colMax works
    TABLE2 <- sort_colMax(TABLE)
    expect_true(all(TABLE2[3,] == c(0,14,36)))

    # If Na values exist
    TABLE[1,1] = NA
    TABLE3 <- sort_colMax(TABLE)
    expect_true(all(TABLE3[2,] == c(48,2,0)))

})


