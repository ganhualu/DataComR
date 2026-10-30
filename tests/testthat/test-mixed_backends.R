base <- data.frame(
  usubjid = c("01", "02", "03"),
  visit = c(1, 1, 2),
  aval = c(10.5, 20, 30),
  aval_c = c("a", "b", "c")
)
compare <- base
compare$aval[2] <- 21
compare$aval_c[3] <- NA

expected <- tibble::tibble(
  usubjid = c("02", "03"),
  visit = c(1, 2),
  variable = c("aval", "aval_c"),
  base = c("20", "c"),
  compare = c("21", NA)
)

# Every ordered pair of different backends, e.g. Base a data frame and Compare
# a duckdb table.
for (base_backend in names(backends)) {
  for (compare_backend in setdiff(names(backends), base_backend)) {
    test_that(paste0("a Base dataset as ", base_backend, " can be compared with a Compare dataset as ", compare_backend), {
      res <- df_compare(
        backends[[base_backend]](base),
        backends[[compare_backend]](compare),
        id = c("usubjid", "visit")
      )

      expect_identical(return_code(res), 4096L)
      expect_identical(differences(res), expected)
      expect_snapshot(print(res))
    })
  }
}

test_that("duckdb tables in different connections are an error", {
  skip_if_not_installed("duckdb")
  other_con <- DBI::dbConnect(duckdb::duckdb(shared_home = FALSE))
  withr::defer(DBI::dbDisconnect(other_con, shutdown = TRUE))
  other <- dplyr::copy_to(other_con, compare, name = "compare")

  expect_snapshot(
    df_compare(backends$duckdb(base), other, id = c("usubjid", "visit")),
    error = TRUE
  )
})

test_that("an arrow Dataset on disk can be a Base or Compare dataset", {
  skip_if_not_installed("arrow")
  path <- withr::local_tempfile()
  arrow::write_dataset(compare, path)
  compare_dataset <- arrow::open_dataset(path)

  expect_identical(
    differences(df_compare(base, compare_dataset, id = c("usubjid", "visit"))),
    expected
  )
  expect_identical(
    differences(df_compare(compare_dataset, backends$duckdb(base), id = c("usubjid", "visit")))$variable,
    c("aval", "aval_c")
  )
})

test_that("a dataset that is not a data frame, arrow or duckdb table is an error", {
  expect_snapshot(df_compare(base, list(a = 1), id = "usubjid"), error = TRUE)
})
