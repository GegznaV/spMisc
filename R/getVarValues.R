#' [~] Parse arguments of a function and return approriate values for selected variable
#'
#' Parse dataframe \code{DATA}, variable \code{VAR} and a call
#' \code{CALL} of a function and return approriate values of the
#' \code{VAR}. \cr If possible, return \code{DATA[,"VAR"]} \cr
#' Otherwise return \code{VAR}.
#'
#' @param VAR A name of a variable (with or without quotes).
#' @param DATA A name of a data frame (with or without quotes).
#' @param CALL (\code{\link[=call-class]{Call}}) to be parsed. Default is
#'              call to parent function.
#' @param env The environment in which expressions must be evaluated.
#'
#' @return A vector. If possible, return \code{DATA[,VAR]}.
#' Otherwise return \code{VAR}.
#' @export
#'
#' @examples
#'
#' library(spMisc)
#' # --------------------------------------------------------------------
#' # [Behaviour of function has changed] EXAMPLES  are out of date!!!
#' # --------------------------------------------------------------------
#'
#'
#' # EXAMPLE 1 *****************************************************************
#'
#' # Clear current environment
#' clear()
#'
#' # Data
#' df  <- mtcars[,c("cyl","gear")]
#'
#' #  Function, that uses `getVarValues`:
#' f1 <- function(data, v1, v2) { getVarValues(v1, data) }
#'
#' # Returns values of `df$cyl`:
#' f1(df, "cyl")
#' ##  [1] 6 6 4 6 8 6 8 4 4 6 6 8 8 8 8 8 8 4 4 4 4 8 8 8 8 4 4 4 8 6 8 4
#'
#' # Values of `df$gear` not of `df$cyl`:
#' cyl <- "gear"
#' f1(df, cyl)
#' ##  [1] 4 4 4 3 3 3 3 4 4 4 4 3 3 3 3 3 3 4 4 4 3 3 3 3 3 4 5 5 5 5 5 4
#'
#' # Returns values of `df$gear`:
#' f1(df, "gear")
#' ##  [1] 4 4 4 3 3 3 3 4 4 4 4 3 3 3 3 3 3 4 4 4 3 3 3 3 3 4 5 5 5 5 5 4
#'
#' var <- c("My", "variable", "var")
#' f1(df, var)
#' ## [1] "My"   "variable"   "var"
#' ## Warning message:
#' ## In getVarValues(v1, data) : Arguments 'DATA' and 'VAR' do not match!!!
#'
#' # EXAMPLE 2 *****************************************************************
#' # A Data frame
#'    df <- data.frame(A = "Values_A_(DATA.FRAME)",
#'                     E = "Values_E_(DATA.FRAME)", stringsAsFactors = FALSE)
#'
#' # Vectors
#'    A <- "Values of the vector 'A'"
#'    B <- "Values of the vector 'B'"
#'
#'
#' # A call object `CALL`:
#'
#' fun  <- function(data, gr, ID) match.call()
#' CALL <- fun(df, A, B)
#' CALL
#' ## fun(data = df, gr = A, ID = B)
#'
#'
#' # Outputs of `getVarValues` -------------------------------------------------
#'
#'
#' getVarValues("A", df, CALL)
#' ## [1] "Values_A_(DATA.FRAME)"
#'
#' getVarValues(A, df)
#' ## [1] "Values of the vector 'A'"
#'
#' getVarValues(B, df)
#' ## [1] "Values of the vector 'B'"
#'
#' # UNEXPECTED results -----------------------------------------------------------------------
#'
#' \donttest{
#' \dontrun{
#'
#'  getVarValues(ID, df) # ??? `ID` found only in function's `fun` definition.
#'  ## NULL
#'
#'  getVarValues(G, df) # ERROR, as variable G does not exist.
#'  ##  Error in eval(expr, envir, enclos) : object 'G' not found
#'
#'  getVarValues(F, df) # F is a special variable: F = FALSE
#'  ##  FALSE
#'
#'  getVarValues(c, df) # c() is a function.
#'  ## function (..., recursive = FALSE)  .Primitive("c")
#' }}
#' @author Vilmantas Gegzna
#'
getVarValues <- function(VAR, DATA,
                         CALL = match.call(definition = sys.function(sys.parent()),
                                           call = sys.call(sys.parent())),
                         env = parent.frame(2L)
                         ) {

    # Prepare data, if needed -------------------------------------------------
    if (inherits(DATA,"hyperSpec")){
        DATA <- DATA$..
    }

    # Force evaluation of function arguments ----------------------------------
    force(env) # Get parent environment
    force(CALL)# Get call of function which parameters are going to be evaluated.

    # Look for missing arguments-----------------------------------------------
    missVar <- vector("logical",2)
    missVar[1] <- missing(VAR)
    missVar[2] <- missing(DATA)

    if (any(missVar)) {
        missVarTXT <- paste(c("VAR", "DATA")[missVar],
                            collapse = ", ")
        stop(paste("Missing arguments with no default values:", missVarTXT))
    }
    # -----------------------------------------------------------------------
    VAR_value <- NULL
    try({VAR_value <- VAR}, silent = TRUE)

    # If data is missing (i.e. is NULL) -------------------------------------
    if (is.null(DATA))
        return(VAR)

    # If DATA is provided ---------------------------------------------------
    # and ...
    VAR_length            <- VAR_value  %>% simplify2array  %>% length
    is_VAR_value_in_DATA  <- all(VAR_value %in% colnames(DATA))
    if (VAR_length == 1 & is_VAR_value_in_DATA)
        return(DATA[[VAR_value]])

    #  ------------------------------------------------------------------------

    DATA_length  <- nrow(DATA) %if_null% length(DATA)  # <<<< this line may need reviewing: length(data.frame) vs. length(matrix)
    if (VAR_length == DATA_length)
        return(VAR_value)

    #  ------------------------------------------------------------------------
    # Convert input variable names to character (without evaluation)
    VAR_name   <- CALL[[match.call()$VAR  %>% as.character]] %>% as.character
    is_VAR_name_in_DATA <- VAR_name %in% colnames(DATA)

    if (is_VAR_name_in_DATA)
        return(DATA[[VAR_name]])

    # VAR_value_in_DATA <- env[[DATA_name]][[VAR_name]]
    # VAR_value_in_DATA <- env[[DATA_name]][[,VAR_name,drop=TRUE]]
    # VAR_value %in% colnames(env[[DATA_name]]

    #  ------------------------------------------------------------------------

    warning("Lengths of arguments 'DATA' and 'VAR' do not match!!!")# <<<< this line may need reviewing:
                                                      # Error message is not informative enough

    return(VAR_value)
}



#
# txt2 <- paste0(VAR_name,
#                " <- if('",Name,"' %in% colnames(env$",DATA_name,")) ",
#                "env$", DATA_name, "$", Name,
#                " else env$", VAR_name)
# eval_(txt2)
#
#
#    if (!is.null(Name)) {
#        Name <- as.character(c(Name))  # c() is used to convert `call` object to
# 		                               # string correctly.
#
#        var_values <- if (Name %in% colnames(env[[DATA_name]])) {
#                env[[DATA_name]][[,Name,drop=TRUE]]
#            } else {
#                env[[VAR_name, drop=TRUE]]
#            }
#    } else {
#        var_values <- VAR # eval_(VAR_name)
#    }
#    return(var_values)

    # # Get the value of variable in the call object `CALL` (without evaluation).
    # # This value is the name of variable of inerest:
    # Name <- CALL[[VAR_name]] # `Name` is an object of class `call`

    # DATA_name  <- CALL[[match.call()$DATA %>% as.character]] %>% as.character

    # VAR_value_in_env <- env[[VAR_name, drop=TRUE]]
