test_that("effect_size_adj works and checks inputs", {
  expect_error(effect_size_adj(0.1, 0, 0.5))
  expect_error(effect_size_adj(0.1, 0.2, 2))
  d <- effect_size_adj(0.05, 0.2, 0.9)
  expect_true(is.numeric(d) && is.finite(d))
  # Manual check
  expect_equal(d, 0.05 / (0.2 * sqrt(1 - 0.9^2)))
})
