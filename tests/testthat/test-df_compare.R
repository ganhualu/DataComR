base <- data.frame(
  usubjid = c("01", "02", "03"),
  visit = c(1, 1, 2),
  aval = c(10.5, 20, 30),
  aval_c = c("a", "b", "c")
)

test_each_backend("equal datasets have Return code 0 and no Unequal values", {
  res <- df_compare(as_backend(base), as_backend(base), id = c("usubjid", "visit"))

  expect_identical(return_code(res), 0L)
  expect_identical(nrow(differences(res)), 0L)
})

test_each_backend("a changed numeric value is one Unequal value with its ID values", {
  compare <- base
  compare$aval[2] <- 21

  res <- df_compare(as_backend(base), as_backend(compare), id = c("usubjid", "visit"))

  expect_identical(return_code(res), 4096L)
  expect_identical(
    differences(res),
    tibble::tibble(
      usubjid = "02", visit = 1, variable = "aval", base = "20", compare = "21",
      diff = 1, pct_diff = 5
    )
  )
})

test_each_backend("Unequal values are reported per variable, in Base variable order", {
  compare <- base
  compare$aval_c[3] <- "z"
  compare$aval[1] <- 11

  res <- df_compare(as_backend(base), as_backend(compare), id = c("usubjid", "visit"))

  expect_identical(return_code(res), 4096L)
  expect_identical(
    differences(res),
    tibble::tibble(
      usubjid = c("01", "03"),
      visit = c(1, 2),
      variable = c("aval", "aval_c"),
      base = c("10.5", "c"),
      compare = c("11", "z"),
      diff = c(0.5, NA),
      pct_diff = c(100 * 0.5 / 10.5, NA)
    )
  )
})

test_each_backend("a value against a missing value is unequal; two missing values are equal", {
  base_na <- base
  base_na$aval[3] <- NA
  compare <- base_na
  compare$aval_c[1] <- NA

  res <- df_compare(as_backend(base_na), as_backend(compare), id = c("usubjid", "visit"))

  expect_identical(
    differences(res),
    tibble::tibble(
      usubjid = "01", visit = 1, variable = "aval_c", base = "a", compare = NA_character_,
      diff = NA_real_, pct_diff = NA_real_
    )
  )
})

test_each_backend("an ID variable missing from either dataset is an error", {
  compare <- base[setdiff(names(base), "visit")]

  expect_snapshot(
    df_compare(as_backend(base), as_backend(compare), id = c("usubjid", "visit")),
    error = TRUE
  )
  expect_snapshot(
    df_compare(as_backend(compare), as_backend(base), id = c("usubjid", "visit")),
    error = TRUE
  )
})

test_each_backend("printing shows a minimal Listing", {
  compare <- base
  compare$aval[2] <- 21

  expect_snapshot({
    df_compare(as_backend(base), as_backend(base), id = c("usubjid", "visit"))
    df_compare(as_backend(base), as_backend(compare), id = c("usubjid", "visit"))
  })
})

test_each_backend("Unequal numeric values are shown at full precision", {
  base_fp <- data.frame(id = 1, x = 0.1 + 0.2)
  compare <- data.frame(id = 1, x = 0.3)

  comparison <- df_compare(as_backend(base_fp), as_backend(compare), id = "id")

  expect_identical(differences(comparison)$base, "0.30000000000000004")
  expect_identical(differences(comparison)$compare, "0.3")
})

test_each_backend("id must name at least one ID variable", {
  expect_snapshot(df_compare(as_backend(base), as_backend(base), id = character()), error = TRUE)
  expect_snapshot(df_compare(as_backend(base), as_backend(base), id = 1), error = TRUE)
})
