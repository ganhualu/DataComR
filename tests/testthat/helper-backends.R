# Each entry turns an in-memory data frame into the backend under test.
backends <- list(
  data_frame = function(df) df,
  arrow = function(df) {
    testthat::skip_if_not_installed("arrow")
    arrow::arrow_table(df)
  },
  duckdb = function(df) {
    testthat::skip_if_not_installed("duckdb")
    testthat::skip_if_not_installed("dbplyr")
    dplyr::copy_to(duckdb_con(), df, name = unique_table_name())
  }
)

# One in-memory duckdb connection shared by the whole test run, closed when
# the run ends.
duckdb_con <- local({
  con <- NULL
  function() {
    if (is.null(con)) {
      con <<- DBI::dbConnect(duckdb::duckdb(shared_home = FALSE))
      withr::defer(DBI::dbDisconnect(con, shutdown = TRUE), envir = testthat::teardown_env())
    }
    con
  }
})

unique_table_name <- local({
  n <- 0
  function() {
    n <<- n + 1
    paste0("fixture_", n)
  }
})

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
