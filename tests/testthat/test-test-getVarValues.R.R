context("functionality of fnction `getVarValues`")
# More tests for `getVarValues` are needed

test_that("`getVarValues()` works", {
    # Clear current environment
    clear()

    # Data
    df  <- mtcars[,c("cyl","gear")]

    #  Function, that uses `getVarValues`:
    f1 <- function(data, v1) { getVarValues(v1, data) }

    # Returns values of `df$cyl`:
    expect_equal(f1(df, "cyl"), df$cyl)

    # Input variable with text (length = 1): return values of `df$gear` not of `df$cyl`
    cyl <- "gear"
    expect_equal(f1(df, cyl), df$gear)

    # Returns values of `df$gear`:
    expect_equal(f1(df, "gear"),df$gear)

    # Input variable with text (length = 1): returns Warning ang 3 values
    var <- c("gear", "cyl", "var")
    expect_warning(rez <- f1(df, var))
    expect_length(rez, 3)

})

test_that("`getVarValues()` throws error if inputs are incorrect or missing.", {
    ##  Error
    expect_error(getVarValues("v1", df))
    expect_error(getVarValues(DATA = df)) # c() is a function.
    expect_error(getVarValues(VAR = var))
    expect_error(getVarValues())
})
