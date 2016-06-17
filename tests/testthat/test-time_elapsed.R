context("Functions time_elapsed() and printDuration()")

## TODO: Rename context
## TODO: Add more tests

test_that("time_elapsed() works", {
    expect_equal(time_elapsed(Sys.time()), "0 secs")

    t1 <- as.POSIXct("2016-06-18 01:59:51 GMT")
    t2 <- as.POSIXct("2016-06-18 02:01:25 GMT")
    expect_equal(time_elapsed(t1, t2), "1.6 mins")
})

test_that("printDuration() works", {
    t1 <- as.POSIXct("2016-06-18 01:59:51 GMT")
    t2 <- as.POSIXct("2016-06-18 02:01:25 GMT")

    out1 <- capture.output(printDuration(t1,End = t2))
    out2 <- printDuration(t1,returnString = TRUE, End = t2)
    expect_equal(out1, "Analysis completed in 1.6 mins")
    expect_equal(out1, out2)
})

