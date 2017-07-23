context("Function regcapturedmatches ")

## TODO: Rename context
## TODO: Add more tests

test_that("regcapturedmatches works", {
    x <- c("larry:35,M", "alison:22,F", "dave", "lily:55,F")
    m <- regexpr("(.*):(\\d+),([MF])", x, perl = TRUE)
    rez <- spMisc:::regcapturedmatches(x, m)
    expect_is(rez, "list")
    # expect_equal(rez[[3]], character(0)) # out of date test
    expect_equal(is.na(rez[[3]]), rep(TRUE, 3))
    expect_equal(as.vector(rez[[2]]), c("alison", "22", "F"))


    expect_error(spMisc:::regcapturedmatches("x","m"))
})
