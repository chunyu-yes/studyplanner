#' Clamp a numeric value into [lo, hi]
#' @keywords internal
#' @noRd
clamp <- function(x, lo, hi) {
  pmax(lo, pmin(hi, x))
}
