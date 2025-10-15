test_that("power increases with n and d", {
  d <- effect_size_adj(0.05, 0.2, 0.9)
  p10 <- power_two_arm(d, n = 10)
  p100 <- power_two_arm(d, n = 100)
  expect_gt(p100, p10)
  d2 <- d * 1.5
  expect_gt(power_two_arm(d2, n = 100), p100)
})


test_that("alpha_adjust works", {
  expect_equal(alpha_adjust(0.05, m = 5, method = "bonferroni"), 0.01)
  expect_equal(alpha_adjust(0.05, m = 1, method = "none"), 0.05)
})
