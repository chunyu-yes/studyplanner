test_that("sample size solver finds reasonable n", {
  d <- effect_size_adj(0.05, 0.2, 0.9)
  n <- sample_size_two_arm(d, alpha = 0.05, target_power = 0.8)
  expect_true(is.numeric(n) && n > 0)
  # Verify power at that n meets target
  expect_gte(power_two_arm(d, n, 0.05), 0.8 - 1e-8)
})


test_that("cost functions behave", {
  c <- study_cost(n = 100, cost_per_subject = 10000, fixed_costs = 5000)
  expect_equal(c$total_cost, 100*(10000+5000))
  expect_equal(c$per_arm_n, 50)


  d <- effect_size_adj(0.05, 0.2, 0.9)
  opt <- optimize_under_budget(d, alpha = 0.05, budget = 200000, cost_per_subject = 2000, fixed_costs = 20000)
  expect_true(opt$n %% 2 == 0)
  expect_true(opt$power > 0 && opt$power < 1)
  expect_lte(opt$cost, 200000)
})

test_that("effect_size_adj errors on invalid denom", {
  expect_error(effect_size_adj(0.1, 0, 0.5))
  expect_error(effect_size_adj(0.1, 0.2, 1))    # rho = 1
})

test_that("optimize_under_budget errors when budget is too small", {
  d <- effect_size_adj(0.05, 0.2, 0.9)
  expect_error(optimize_under_budget(d, budget = 100, cost_per_subject = 2000, fixed_costs = 100))
})

test_that("sample_size_two_arm stops on infeasible tiny effects", {
  d <- 1e-8
  expect_error(sample_size_two_arm(d, alpha = 0.05, target_power = 0.9))
})
