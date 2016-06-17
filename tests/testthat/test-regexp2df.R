context("regexp2df")

## TODO: Rename context
## TODO: Add more tests

test_that("regexp2df() works", {
    text1 <- c("A_111  B_aaa",
               "A_222  B_bbb",
               "A_333  B_ccc",
               "A_444  B_ddd",
               "A_555  B_eee")

    # Named tokens
    pattern1_named_tokens <- 'A_(?<Part_A>.*)  B_(?<Part_B>.*)'

    rez1 <- regexp2df(text1, pattern1_named_tokens)
    expect_equal(dim(rez1), c(5,2))
    expect_equal(as.character(rez1[3,1]), "333")
    expect_equal(as.character(rez1[5,2]), "eee")
    expect_equal(names(rez1), c("Part_A", "Part_B"))


    # Unnamed tockens - groups inside brackets:
    pattern1_unnamed_tokens <- 'A_(.*)  B_(.*)'

    rez2 <- regexp2df(text1, pattern1_unnamed_tokens)
    expect_equal(dim(rez2), c(5,2))
    expect_equal(as.character(rez2[3,1]), "333")
    expect_equal(as.character(rez2[5,2]), "eee")

    #----------------------------------------------------------
    # Wrong. There must be NO SPACES in token's name:
    pattern2 <- 'A (?<Part A>.*)  B (?<Part B>.*)'
    expect_warning(expect_error(regexp2df(text1, pattern2)))

    })
