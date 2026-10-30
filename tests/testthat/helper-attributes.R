# Lazy database tables carry no R attributes, so tests expecting Attribute
# differences can't hold for them; their behaviour is tested separately.
skip_if_backend_drops_attributes <- function(data) {
  if (inherits(data, "tbl_lazy")) {
    testthat::skip("backend carries no R attributes")
  }
}
