#' Sample size for target power under two-arm design
#'
#' Solves for the minimal integer n such that power_two_arm(d_adj, n, alpha) >= target_power.
#'
#' @param d_adj Adjusted effect size.
#' @param alpha Alpha level.
#' @param target_power Required power, e.g., 0.9.
#' @return Integer total sample size n.
#' @export
sample_size_two_arm <- function(d_adj, alpha = 0.05, target_power = 0.9) {
  stopifnot(d_adj > 0, target_power > 0, target_power < 1)
  f <- function(n) power_two_arm(d_adj, n, alpha) - target_power
  # bracket search
  n <- 4L
  while (f(n) < 0) {
    n <- n * 2L
    if (n > 1e4) stop("Effect too small for feasible sample size")
  }
  # binary search
  lo <- as.integer(n/2); hi <- n
  while (lo + 1 < hi) {
    mid <- as.integer(floor((lo + hi)/2))
    if (f(mid) >= 0) hi <- mid else lo <- mid
  }
  hi
}


#' Total and per-arm cost given design and per-subject costs
#'
#' @param n Total sample size (both arms).
#' @param cost_per_subject Numeric other cost per subject (MRI).
#' @param fixed_costs Numeric fixed costs per subject (setup, overhead).
#' @return A list with total_cost and per_arm_n.
#' @export
study_cost <- function(n, cost_per_subject=10000, fixed_costs = 5000) {
  stopifnot(n >= 2, cost_per_subject >= 0, fixed_costs >= 0)
  list(total_cost = n * (fixed_costs + cost_per_subject),
       per_arm_n = n/2)
}


#' Optimize design under a budget constraint
#'
#' Finds the maximum power achievable under a given budget by choosing n (even)
#' that satisfies cost <= budget.
#'
#' @param d_adj Adjusted effect size.
#' @param alpha Alpha level.
#' @param budget Total budget available.
#' @param cost_per_subject Per-subject cost.
#' @param fixed_costs Fixed costs.
#' @return A list with n, power, and cost.
#' @export
optimize_under_budget <- function(d_adj, alpha = 0.05, budget, cost_per_subject, fixed_costs) {
  stopifnot(budget > fixed_costs)
  max_n <- floor(budget / (fixed_costs + cost_per_subject))
  if (max_n < 2) stop("Budget too small for any enrollment")
  # enforce even n for equal allocation
  if (max_n %% 2 == 1) max_n <- max_n - 1
  # Evaluate power at feasible n range (ensure n >= 4)
  n_vals <- seq(4, max_n, by = 2)
  powers <- vapply(n_vals, function(n) power_two_arm(d_adj, n, alpha), numeric(1))
  best_idx <- which.max(powers)
  list(n = n_vals[best_idx], power = powers[best_idx],
       cost = study_cost(n_vals[best_idx], cost_per_subject, fixed_costs)$total_cost)
}
