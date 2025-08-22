#' Replicative Significance Index (RSI) and RSI*
#'
#' @description Simulates `N` replications of an effect size with known
#' standard error, returning the proportion that are statistically
#' significant (RSI) and a skewness-augmented variant (RSI*).
#'
#' @param effect Observed effect size.
#' @param se     Standard error of the effect size.
#' @param N      Number of simulated replications (default 1e4).
#' @param alpha  Significance threshold (default 0.05).
#' @param lambda Weight on skewness for RSI* (default 0.1).
#' @param plot   Draw histogram of simulated p-values? (default TRUE).
#'
#' @return Named list: RSI, Skewness, RSI_star, Mean_p, SD_p.
#' @export
#'
#' @examples
#' rsi(0.5, 0.2)
rsi <- function(effect = 0.5,
                se     = 0.2,
                N      = 1e4,
                alpha  = 0.05,
                lambda = 0.1,
                plot   = TRUE) {

  if (!requireNamespace("moments", quietly = TRUE)) {
    stop("Package 'moments' is required; install it with `install.packages('moments')`.")
  }

  estimates <- stats::rnorm(N, mean = effect, sd = se)
  p_values  <- 2 * stats::pnorm(-abs(estimates / se))

  RSI      <- mean(p_values < alpha)
  gamma    <- moments::skewness(p_values)
  n_alpha <- sum(p_values < alpha)
  RSI_star <- if (n_alpha > 0) {
    mean(1 - p_values[p_values < alpha] / alpha)
  } else {
    NA_real_
  }

  if (plot) {
    graphics::hist(p_values, breaks = 50, col = 'skyblue', border = 'white',
                   main = 'P-value distribution across simulations',
                   xlab = 'P-value', ylab = 'Frequency')
    graphics::abline(v = alpha, col = 'red', lwd = 2, lty = 2)
    graphics::legend('topright', legend = paste('alpha =', alpha),
                     col = 'red', lty = 2, lwd = 2, bty = 'n')
  }

  invisible(list(RSI      = round(RSI,      4),
                 Skewness = round(gamma,    4),
                 RSI_star = round(RSI_star, 4),
                 Mean_p   = round(mean(p_values), 4),
                 SD_p     = round(stats::sd(p_values), 4)))
}
