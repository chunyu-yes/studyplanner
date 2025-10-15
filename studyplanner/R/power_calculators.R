#' Power for two-arm study using adjusted effect size
#'
#' Computes power = 1 - Phi(z_(1-alpha) - d_adj * sqrt(n/2)),
#' assuming equal allocation, two-sided alpha, and standard normal approximation.
#'
#' @param d_adj Numeric. Adjusted effect size from `effect_size_adj()`.
#' @param n Integer (> 0). Total sample size across both arms.
#' @param alpha Numeric, between 0 and 1 (open interval). One-sided alpha level.
#' @return Numeric power between 0 and 1.
#' @examples
#' d <- effect_size_adj(0.05, 0.2, 0.9)
#' power_two_arm(d, n = 100, alpha = 0.05)
#' @export
power_two_arm <- function(d_adj, n, alpha = 0.05) {
  stopifnot(is.numeric(d_adj), length(d_adj) == 1L)
  stopifnot(is.numeric(n) || is.integer(n), length(n) == 1L, n > 0)
  stopifnot(is.numeric(alpha), length(alpha) == 1L, alpha > 0, alpha < 1)
  zcrit <- stats::qnorm(1 - alpha)
  z <- d_adj * sqrt(n/2)
  as.numeric(1 - stats::pnorm(zcrit - z))
}


#' Compute alpha adjusted for multiplicity using Bonferroni or FDR placeholder
#'
#' @param alpha Nominal alpha.
#' @param m Number of tests.
#' @param method One of "bonferroni" or "none". (FDR is typically used for discovery; for
#' confirmatory power, provide your familywise alpha or use bonferroni.)
#' @return Adjusted alpha.
#' @export
alpha_adjust <- function(alpha, m = 1L, method = c("bonferroni", "none")) {
  method <- match.arg(method)
  stopifnot(m >= 1)
  if (method == "bonferroni") alpha / m else alpha
}
