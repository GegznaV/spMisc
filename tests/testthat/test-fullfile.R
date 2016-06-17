context("Function fullfile()")

test_that("Function fullfile() works", {
    expect_equal(fullfile("a","b","c"),      "a/b/c")
    # Removes slashes
    expect_equal(fullfile("a/","/b/","/c/"), "a/b/c")
    # Adds extension
    expect_equal(fullfile("a","b\\","c", ext = "txt"), "a/b/c.txt")
    # Removes doule dot from extension
    expect_equal(fullfile("a","b\\","c", ext = ".txt"), "a/b/c.txt")
})
