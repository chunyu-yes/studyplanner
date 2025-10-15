test_that("clamp works correctly", {
  expect_equal(clamp(5, 0, 10), 5)
  expect_equal(clamp(-1, 0, 10), 0)
  expect_equal(clamp(15, 0, 10), 10)
  expect_true(is.na(clamp(NA_real_, 0, 10)))
})

test_that("study_planner solves n for target power", {
  delta <- 0.05; sigma <- 0.20; rho <- 0.90; alpha <- 0.05
  res <- study_planner(delta = delta, sigma = sigma, rho = rho,
                       alpha = alpha, target_power = 0.80)
  expect_type(res, "list")
  expect_true("n_target" %in% names(res))
  d <- effect_size_adj(delta, sigma, rho)
  expect_gte(power_two_arm(d, res$n_target, alpha), 0.80 - 1e-8)
})

test_that("study_planner budget optimization respects budget", {
  delta <- 0.05; sigma <- 0.20; rho <- 0.90; alpha <- 0.05
  budget <- 50000; cps <- 2000; fixed <- 10000
  res <- study_planner(delta = delta, sigma = sigma, rho = rho,
                       alpha = alpha,
                       budget = budget, cost_per_subject = cps, fixed_costs = fixed)
  expect_true("budget_opt" %in% names(res))
  expect_lte(res$budget_opt$cost, budget)
  expect_true(res$budget_opt$power > 0 && res$budget_opt$power < 1)
  expect_true(res$budget_opt$n %% 2 == 0)
})

test_that("study_planner reports power at given n", {
  delta <- 0.05; sigma <- 0.20; rho <- 0.90; alpha <- 0.05
  n <- 50
  res <- study_planner(delta = delta, sigma = sigma, rho = rho,
                       alpha = alpha, n = n)
  d <- effect_size_adj(delta, sigma, rho)
  expect_equal(res$power_at_n, power_two_arm(d, n, alpha))
})

