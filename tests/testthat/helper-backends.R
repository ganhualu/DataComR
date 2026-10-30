# Each entry turns an in-memory data frame into the backend under test.
# Later tickets add arrow and duckdb.
backends <- list(
  data_frame = function(df) df
)

# Runs `code` once per backend, with `as_backend()` converting fixtures to
# that backend. Every test of df_compare() should go through this helper.
test_each_backend <- function(desc, code) {
  code <- substitute(code)
  for (name in names(backends)) {
    env <- new.env(parent = parent.frame())
    env$as_backend <- backends[[name]]
    test_that(paste0(desc, " [", name, "]"), eval(code, env))
  }
}
