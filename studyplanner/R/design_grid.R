#' Explore a grid of study designs
#'
#' Computes power and cost over a grid of parameters to help sensitivity analyses.
#'
#' @param delta_vec Vector of Delta values.
#' @param sigma_vec Vector of sigma values.
#' @param rho_vec Vector of rho values.
#' @param n_vec Vector of total sample sizes.
#' @param alpha Alpha level.
#' @param cost_per_subject Per-subject cost.
#' @param fixed_costs Fixed costs.
#' @return A data.frame with all combinations and computed d_adj, power, and cost.
#' @export
plan_grid <- function(delta_vec, sigma_vec, rho_vec, n_vec, alpha = 0.05,
                      cost_per_subject = 0, fixed_costs = 0) {
  stopifnot(length(delta_vec) >= 1, length(sigma_vec) >= 1, length(rho_vec) >= 1, length(n_vec) >= 1)
  g <- expand.grid(delta = delta_vec, sigma = sigma_vec, rho = rho_vec, n = n_vec, KEEP.OUT.ATTRS = FALSE)
  g$d_adj <- mapply(effect_size_adj, g$delta, g$sigma, g$rho)
  g$power <- mapply(power_two_arm, g$d_adj, g$n, MoreArgs = list(alpha = alpha))
  costs <- mapply(function(n) study_cost(n, cost_per_subject, fixed_costs)$total_cost, g$n)
  g$cost <- as.numeric(costs)
  g
}
