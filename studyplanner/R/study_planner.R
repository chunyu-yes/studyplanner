#' High-level helper to plan a study from raw inputs
#'
#' @param delta Expected difference in annual change between arms.
#' @param sigma SD of outcome at a single timepoint.
#' @param rho Baseline-follow-up correlation.
#' @param alpha Alpha level.
#' @param target_power Optional target power (if provided, returns n_target).
#' @param budget Optional budget (if provided, returns budget_opt solution given cost inputs).
#' @param cost_per_subject Per-subject cost (required if budget is set).
#' @param fixed_costs Fixed costs (default 0).
#' @param n Optional numeric. Sample size to evaluate directly.
#' @return A list with d_adj, power_at_n (if n provided), n_target (if target_power), and budget_opt (if budget).
#' @export
study_planner <- function(delta, sigma, rho, alpha = 0.05, n = NULL,
                          target_power = NULL, budget = NULL,
                          cost_per_subject = NULL, fixed_costs = NULL) {
  d <- effect_size_adj(delta, sigma, rho)
  out <- list(d_adj = d)
  if (!is.null(n)) out$power_at_n <- power_two_arm(d, n, alpha)
  if (!is.null(target_power)) out$n_target <- sample_size_two_arm(d, alpha, target_power)
  if (!is.null(budget)) {
    if (is.null(cost_per_subject)) stop("Provide cost_per_subject when using budget optimization")
    out$budget_opt <- optimize_under_budget(d, alpha, budget, cost_per_subject, fixed_costs)
  }
  out
}
