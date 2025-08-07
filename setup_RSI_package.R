##### setup_RSI_package.R  ###############################################
## 1.  LOAD / INSTALL DEPENDENCIES ----
needed <- c("usethis", "devtools", "testthat",
            "roxygen2", "pkgdown", "moments")
to_get <- needed[!vapply(needed, requireNamespace,
                         logical(1), quietly = TRUE)]
if (length(to_get)) install.packages(to_get)

library(devtools)  # attach first so helpers from usethis win the mask war
library(usethis)

## 2.  CREATE THE PACKAGE SKELETON ----
pkg_path <- "~/OneDrive/Stats/RSI"            # <- change if you like
create_package(pkg_path, open = FALSE)
setwd(pkg_path)

## 3.  DESCRIPTION, LICENSE, README ----
long_desc <- paste0(
  "Computes the Replicative Significance Index (RSI)—the proportion of ",
  "hypothetical replications that achieve statistical significance—plus a ",
  "skewness-adjusted variant (RSI*). Includes plotting utilities and ",
  "simulation helpers."
)

use_description(fields = list(
  Title       = "Replicative Significance Index (RSI) and RSI*",
  Description = long_desc,
  `Authors@R` = 'c(
    person("Suhrud", "Panchawagh",
           email = "panchawagh.suhrud@mayo.edu",
           role  = c("aut", "cre")),
    person("Vinay",  "Suresh",
           email = "vinay.suresh@bnc.ox.ac.uk",
           role  = "aut"),
    person("Bhavik", "Bansal",
           email = "bhavik.bansal@utsouthwestern.edu",
           role  = "aut")
  )',
  License     = "MIT + file LICENSE",
  Encoding    = "UTF-8",
  LazyData    = TRUE
))

use_mit_license("Suhrud Panchawagh")
use_readme_rmd(open = FALSE)

## 4.  MAIN FUNCTION FILE ----
use_r("rsi", open = FALSE)
writeLines(c(
  "#' Replicative Significance Index (RSI) and RSI*",
  "#'",
  "#' @description Simulates `N` replications of an effect size with known",
  "#' standard error, returning the proportion that are statistically",
  "#' significant (RSI) and a skewness-augmented variant (RSI*).",
  "#'",
  "#' @param effect Observed effect size.",
  "#' @param se     Standard error of the effect size.",
  "#' @param N      Number of simulated replications (default 1e4).",
  "#' @param alpha  Significance threshold (default 0.05).",
  "#' @param lambda Weight on skewness for RSI* (default 0.1).",
  "#' @param plot   Draw histogram of simulated p-values? (default TRUE).",
  "#'",
  "#' @return Named list: RSI, Skewness, RSI_star, Mean_p, SD_p.",
  "#' @export",
  "#'",
  "#' @examples",
  "#' rsi(0.5, 0.2)",
  "rsi <- function(effect = 0.5,",
  "                se     = 0.2,",
  "                N      = 1e4,",
  "                alpha  = 0.05,",
  "                lambda = 0.1,",
  "                plot   = TRUE) {",
  "",
  "  if (!requireNamespace(\"moments\", quietly = TRUE)) {",
  "    stop(\"Package 'moments' is required; install it with `install.packages('moments')`.\")",
  "  }",
  "",
  "  estimates <- stats::rnorm(N, mean = effect, sd = se)",
  "  p_values  <- 2 * stats::pnorm(-abs(estimates / se))",
  "",
  "  RSI      <- mean(p_values < alpha)",
  "  gamma    <- moments::skewness(p_values)",
  "  RSI_star <- RSI + lambda * gamma",
  "",
  "  if (plot) {",
  "    graphics::hist(p_values, breaks = 50, col = 'skyblue', border = 'white',",
  "                   main = 'P-value distribution across simulations',",
  "                   xlab = 'P-value', ylab = 'Frequency')",
  "    graphics::abline(v = alpha, col = 'red', lwd = 2, lty = 2)",
  "    graphics::legend('topright', legend = paste('alpha =', alpha),",
  "                     col = 'red', lty = 2, lwd = 2, bty = 'n')",
  "  }",
  "",
  "  invisible(list(RSI      = round(RSI,      4),",
  "                 Skewness = round(gamma,    4),",
  "                 RSI_star = round(RSI_star, 4),",
  "                 Mean_p   = round(mean(p_values), 4),",
  "                 SD_p     = round(stats::sd(p_values), 4)))",
  "}"
), "R/rsi.R")

## 5.  DOCUMENTATION & NAMESPACE ----
devtools::document()

## 6.  UNIT TESTS ----
use_testthat()
use_test("rsi", open = FALSE)
writeLines(c(
  "test_that('structure and names are correct', {",
  "  res <- rsi(effect = 0.5, se = 0.2, N = 100, plot = FALSE)",
  "  expect_type(res, 'list')",
  "  expect_named(res,",
  "               c('RSI', 'Skewness', 'RSI_star', 'Mean_p', 'SD_p'),",
  "               ignore.order = TRUE)",
  "})"
), "tests/testthat/test-rsi.R")

## 7.  VIGNETTE ----
usethis::use_vignette("RSI-overview", open = FALSE)

## 8.  CITATION INFO ----
use_citation()

## 9.  CONTINUOUS INTEGRATION & WEBSITE ----
use_git()                                    # adds .gitignore
## uncomment next two lines once your Git and PAT are set up
# use_github()                               # pushes to GitHub (needs GITHUB_TOKEN env var)
# use_github_action_check_standard()         # R-CMD-check workflow
use_pkgdown()
use_pkgdown_github_pages()

## 10.  FINAL CHECK ----
# devtools::check()
###########################################################################

source("setup_RSI_package.R", echo = TRUE)



