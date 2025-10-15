test_that("plan_grid returns full grid with sensible columns", {
  g <- plan_grid(delta_vec = c(0.04, 0.05), sigma_vec = 0.2, rho_vec = c(0.8, 0.9), n_vec = c(50, 100))
  expect_true(all(c("delta", "sigma", "rho", "n", "d_adj", "power", "cost") %in% names(g)))
  expect_equal(nrow(g), 2 * 1 * 2 * 2)
  expect_true(all(is.finite(g$d_adj)))
  expect_true(all(g$power >= 0 & g$power <= 1))
})
