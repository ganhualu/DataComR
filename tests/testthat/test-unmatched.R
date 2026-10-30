base <- data.frame(
  usubjid = c("01", "02", "03"),
  visit = c(1, 1, 2),
  aval = c(10.5, 20, 30)
)

test_each_backend("an Observation only in Base is an Unmatched observation with Return code 64", {
  compare <- base[c(1, 3), ]

  res <- df_compare(as_backend(base), as_backend(compare), id = c("usubjid", "visit"))

  expect_identical(return_code(res), 64L)
  expect_identical(
    unmatched_rows(res),
    tibble::tibble(usubjid = "02", visit = 1, dataset = "Base")
  )
})

test_each_backend("Unmatched observations in both datasets set Return code 64 + 128", {
  compare <- rbind(base[c(1, 3), ], data.frame(usubjid = "04", visit = 1, aval = 40))

  res <- df_compare(as_backend(base), as_backend(compare), id = c("usubjid", "visit"))

  expect_identical(return_code(res), 192L)
  expect_identical(
    unmatched_rows(res),
    tibble::tibble(usubjid = c("02", "04"), visit = c(1, 1), dataset = c("Base", "Compare"))
  )
})

test_each_backend("the Listing counts Unmatched observations in each dataset", {
  compare <- rbind(base[c(1, 3), ], data.frame(usubjid = "04", visit = 1, aval = 40))

  expect_snapshot(df_compare(as_backend(base), as_backend(compare), id = c("usubjid", "visit")))
})

test_each_backend("Variables only in Base / only in Compare set Return code 1024 / 2048", {
  compare <- base
  compare$extra <- "x"

  expect_identical(
    return_code(df_compare(as_backend(base), as_backend(compare), id = "usubjid")),
    2048L
  )
  expect_identical(
    return_code(df_compare(as_backend(compare), as_backend(base), id = "usubjid")),
    1024L
  )
})

test_each_backend("the Listing names Variables found in only one dataset", {
  base_v <- base
  base_v$only_b1 <- 1
  base_v$only_b2 <- 2
  compare <- base
  compare$only_c <- "x"

  expect_snapshot(df_compare(as_backend(base_v), as_backend(compare), id = "usubjid"))
})

test_each_backend("equal datasets have no Unmatched observations", {
  res <- df_compare(as_backend(base), as_backend(base), id = c("usubjid", "visit"))

  expect_identical(
    unmatched_rows(res),
    tibble::tibble(usubjid = character(), visit = numeric(), dataset = character())
  )
})
