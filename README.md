# RSI
Computes the Replicative Significance Index (RSI), the proportion of hypothetical replications that achieve statistical significance, plus a skewness-adjusted variant (RSI*).


RSI Package – Quick‑Start Guide
===============================

Installation
------------

    if (!requireNamespace("devtools", quietly = TRUE))
        install.packages("devtools")

    devtools::install_github("suhrudp/RSI",
                             build_vignettes = TRUE,
                             dependencies   = TRUE)

    library(RSI)

------------------------------------------------------------------------
1. Basic call
------------------------------------------------------------------------

    rsi()  # defaults: effect = 0.5, se = 0.2, N = 1e4, alpha = 0.05

Returns a named list:

    $RSI       – proportion of significant replications
    $Skewness  – skewness of simulated p‑values
    $RSI_star  – skew‑adjusted RSI  (RSI + lambda * skewness)
    $Mean_p    – mean simulated p‑value
    $SD_p      – standard deviation of p‑values

A histogram of p‑values with a dashed red alpha line is drawn unless
`plot = FALSE`.

------------------------------------------------------------------------
2. Custom effect size & precision
------------------------------------------------------------------------

    rsi(effect = 0.25,    # smaller observed effect
        se     = 0.10,    # tighter standard error
        N      = 5e4)     # more Monte‑Carlo draws

------------------------------------------------------------------------
3. Exploring different alpha levels
------------------------------------------------------------------------

    alpha_grid <- c(0.10, 0.05, 0.025, 0.01)
    sapply(alpha_grid, \(a) rsi(alpha = a, plot = FALSE)$RSI)

------------------------------------------------------------------------
4. Tuning the skewness weight (lambda)
------------------------------------------------------------------------

    rsi(lambda = 0.25)   # heavier correction for skewness

------------------------------------------------------------------------
5. Turning graphics off
------------------------------------------------------------------------

    silent <- rsi(plot = FALSE)

------------------------------------------------------------------------
6. Batch evaluation in a data frame
------------------------------------------------------------------------

    library(dplyr)

    scenarios <- expand.grid(effect = c(.2, .4, .6),
                             se     = c(.15, .25),
                             alpha  = c(.05, .01))

    results <- scenarios |>
      rowwise() |>
      mutate(res = list(rsi(effect, se, N = 1e4, alpha, plot = FALSE))) |>
      unnest_wider(res)

    results

------------------------------------------------------------------------
Function arguments recap
------------------------------------------------------------------------

    effect   numeric  Observed effect size  (default 0.5)
    se       numeric  Standard error        (default 0.2)
    N        integer  # simulations         (default 1e4)
    alpha    numeric  Significance cutoff   (default 0.05)
    lambda   numeric  Skewness weight       (default 0.1)
    plot     logical  Draw histogram?       (default TRUE)

------------------------------------------------------------------------
Interpreting RSI vs. RSI*
------------------------------------------------------------------------

* RSI   – fraction of replications expected to reach p < alpha.
* RSI*  – RSI adjusted for skewness; positive skew bumps the estimate up,
          negative skew pulls it down.  The lambda parameter controls
          how much weight the adjustment gets.

------------------------------------------------------------------------
Tips
------------------------------------------------------------------------

• Wrap `rsi()` inside your power‑simulation loops.
• Rank competing studies by RSI to prioritize replication.
• Explore multiple alpha thresholds to check robustness.

