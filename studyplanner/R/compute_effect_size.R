# internal check helper (no roxygen，no output)
.effect_size_checks <- function(delta, sigma, rho) {
  stopifnot(is.numeric(delta), length(delta) == 1L)
  stopifnot(is.numeric(sigma), length(sigma) == 1L, sigma > 0)
  stopifnot(is.numeric(rho), length(rho) == 1L, rho >= -1, rho <= 1)
}

#' Adjusted effect size for correlated baseline–follow-up designs
#'
#' Computes d_adj = Delta / (sigma * sqrt(1 - rho^2)), where Delta is the mean
#' difference in annual change (or other contrast), sigma is the SD of the
#' outcome at a single timepoint, and rho is the baseline–follow-up correlation.
#'
#' @param delta Numeric. The expected mean difference in annual change between groups.
#' @param sigma Numeric (> 0). SD of the outcome at a single timepoint.
#' @param rho Numeric, between -1 and 1 inclusive.
#' @return A single numeric: adjusted effect size d_adj.
#' @examples
#' effect_size_adj(delta = 0.05, sigma = 0.2, rho = 0.9)
#' @export
effect_size_adj <- function(delta, sigma, rho) {
  .effect_size_checks(delta, sigma, rho)
  denom <- sigma * sqrt(1 - rho^2)
  if (!is.finite(denom) || denom <= 0) stop("Denominator is non-positive; check sigma and rho")
  as.numeric(delta / denom)
}

