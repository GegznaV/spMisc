#' [+] Simulate correlated continuous data from standard normal distribution
#'
#' Simulate correlated continuaous data from standard normal distribution by
#' using Choleski factorization of correlation matrix.
#' @details Number of variables is determined by the size of correlation matrix
#'          \code{corrMat}.
#'
#'
#' @param corrMat A symmetricmatrix of correlation coefficients. Determinant of
#'                \code{corrMat} must be positive. If \code{corrMat} is a vector,
#'                it is passed to function \code{\link{corr_vec2mat}} to
#'                construct a correlation matrix.\cr
#'                Default \code{corrMat = corr_vec2mat(c(.8,.2,.7))}.
#' @param N A number of observations. Default is 100.
#'
#' @return A dataframe with correlated variables.
#'
#' @seealso \code{\link{corr_vec2mat}}, \link[MASS]{mvrnorm}, \link[base]{chol}
#' @export
#' @source \url{http://www.r-bloggers.com/simulating-random-multivariate-correlated-data-continuous-variables/}
#'
#' @examples
#'
#' # ------------------------------------------------------------
#' simCorrVars()
#' simCorrVars(N = 10)
#'
#' # ------------------------------------------------------------
#' # Generate 2 correlated variables with 10 observations:
#' # A. Imput is a matrix
#'
#' corrMat <- matrix(c(1, .5, .5, 1), 2)
#' print(corrMat)
#' simCorrVars(corrMat, N = 10)
#'
#' # B. Imput is a vector
#' simCorrVars(.5, N = 10)
#' simCorrVars(c(.1,.5,.8), N = 10)
#'
#' # ------------------------------------------------------------
#' @family simmulation functions in \pkg{spHelper}
#' @author Vilmantas Gegzna
#'
simCorrVars <- function(corrMat, N = 100){
    if (missing(corrMat)) {
        corrMat = corr_vec2mat(c(.8,.2,.7))
    }

    if (is.vector(corrMat)) corrMat <- corr_vec2mat(corrMat)
    if (!isSymmetric(corrMat)) stop("Correlation matrix must be symmetric.")

    U = t(chol(corrMat))
    nvars = dim(U)[1]

    # set.seed(1)
    random.normal = matrix(rnorm(nvars*N,0,1), nrow = nvars, ncol = N);
    X = U %*% random.normal
    newX = t(X)
    as.data.frame(newX)

    # raw = as.data.frame(newX)
    # orig.raw = as.data.frame(t(random.normal))
    # names(raw) = c("response","predictor1","predictor2")
    # cor(raw)
    # plot(head(raw, 100))
    # plot(head(orig.raw,100))
}
