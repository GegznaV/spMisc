context("Function fullfile()")

test_that("Function fullfile() works", {
    fsep = .Platform$file.sep

    expect_match(fullfile("a","b","c"),      paste0("a",fsep, "b",fsep, "c"))
    # Removes slashes
    expect_match(fullfile("a/","/b/","/c/"), paste0("a",fsep, "b",fsep, "c"))
    # Adds extension
    expect_match(fullfile("a","b\\","c", ext = "txt"), paste0("a",fsep, "b",fsep, "c.txt"))
    # Removes doule dot from extension
    expect_match(fullfile("a","b\\","c", ext = ".txt"), paste0("a",fsep, "b",fsep, "c.txt"))
})
