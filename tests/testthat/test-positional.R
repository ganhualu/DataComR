# Without ID variables, observations are matched by position, as SAS does by
# default. Only in-memory data frames have a guaranteed observation order, so
# these tests use test_that() directly; the error for arrow and duckdb inputs
# is tested at the end on those backends.

base <- data.frame(
  usubjid = c("01", "02", "03"),
  aval = c(10.5, 20, 30)
)

test_that("two data frames without ID variables are compared observation by observation", {
  compare <- base
  compare$aval[2] <- 21

  res <- df_compare(base, compare)

  expect_identical(return_code(res), 4096L)
  expect_identical(
    differences(res),
    tibble::tibble(
      obs = 2L, variable = "aval", base = "20", compare = "21",
      diff = 1, pct_diff = 5
    )
  )
})

test_that("extra observations in a longer Base dataset are Unmatched observations with Return code 64", {
  compare <- base[1:2, ]

  res <- df_compare(base, compare)

  expect_identical(return_code(res), 64L)
  expect_identical(unmatched_rows(res), tibble::tibble(obs = 3L, dataset = "Base"))
})

test_that("extra observations in a longer Compare dataset are Unmatched observations with Return code 128", {
  compare <- rbind(base, data.frame(usubjid = c("04", "05"), aval = c(40, 50)))

  res <- df_compare(base, compare)

  expect_identical(return_code(res), 128L)
  expect_identical(unmatched_rows(res), tibble::tibble(obs = c(4L, 5L), dataset = "Compare"))
})

test_that("the Listing says observations were matched by position", {
  compare <- rbind(base, data.frame(usubjid = "04", aval = 40))
  compare$aval[2] <- 21

  expect_snapshot(df_compare(base, compare))
})

test_that("without ID variables, a variable named obs is an error rather than being overwritten", {
  base_obs <- data.frame(obs = c(3, 2, 1), aval = c(10.5, 20, 30))

  expect_snapshot(df_compare(base_obs, base), error = TRUE)
  expect_snapshot(df_compare(base, base_obs), error = TRUE)
})

# Every pair of backends in which at least one dataset is not a data frame.
for (base_backend in names(backends)) {
  for (compare_backend in names(backends)) {
    if (base_backend == "data_frame" && compare_backend == "data_frame") next
    test_that(paste0("without ID variables, a Base dataset as ", base_backend, " with a Compare dataset as ", compare_backend, " is an error"), {
      base_data <- backends[[base_backend]](base)
      compare_data <- backends[[compare_backend]](base)

      expect_snapshot(df_compare(base_data, compare_data), error = TRUE)
    })
  }
}
