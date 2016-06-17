context("spMisc operators")


test_that("%!in% and %NOTin% works", {

    vect <- c(FALSE,TRUE,FALSE,TRUE,FALSE,TRUE,TRUE,TRUE,FALSE,TRUE)

    rez0 <- 1:10 %in%    c(1,3,5,9) == vect

    rez1 <- 1:10   %!in% c(1,3,5,9) == vect
    rez2 <- 1:10 %NOTin% c(1,3,5,9) == vect

    expect_true(all(rez1))
    expect_true(all(rez2))
    expect_true(all(!rez0))

    expect_equal(rez0, !rez1)
})

#  ------------------------------------------------------------------------


test_that("%if_null% and %if.NULL% works", {

    a1 <- "Default value"
    a2 <- NULL
    a3 <- character()
    b  <- "Alternative"

    expect_equal(a1 %if.NULL% b, "Default value")
    expect_equal(a2 %if.NULL% b, "Alternative")
    expect_equal(a3 %if.NULL% b, character(0))

    expect_equal(a1 %if_null% b, "Default value")
    expect_equal(a2 %if_null% b, "Alternative")
    expect_equal(a3 %if_null% b, character(0))

})


#  ------------------------------------------------------------------------


test_that("%if_null_or_len0% works", {

    a1 <- "Default value"
    a2 <- NULL
    a3 <- character()
    b  <- "Alternative"

    expect_equal(a1 %if_null_or_len0% b, "Default value")
    expect_equal(a2 %if_null_or_len0% b, "Alternative")
    expect_equal(a3 %if_null_or_len0% b, "Alternative")

})

#  ------------------------------------------------------------------------


test_that("%++% and %.+.%  works", {
    expect_equal("a" %.+.% "b", "a b")
    expect_equal("a" %++% "b",  "ab")
})
