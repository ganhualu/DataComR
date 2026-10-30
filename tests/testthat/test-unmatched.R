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

test_each_backend("a Duplicate ID in Base gives a warning and Return code 65536", {
  base_dup <- rbind(base, base[2, ])

  expect_snapshot(
    res <- df_compare(as_backend(base_dup), as_backend(base), id = c("usubjid", "visit"))
  )
  expect_identical(return_code(res), 65536L)
})

test_each_backend("Duplicate IDs are not compared while unique IDs still are", {
  compare_dup <- rbind(base, data.frame(usubjid = "02", visit = 1, aval = 99))
  compare_dup$aval[3] <- 31

  res <- suppressWarnings(
    df_compare(as_backend(base), as_backend(compare_dup), id = c("usubjid", "visit"))
  )

  expect_identical(return_code(res), 4096L + 65536L)
  expect_identical(
    differences(res),
    tibble::tibble(
      usubjid = "03", visit = 2, variable = "aval", base = "30", compare = "31",
      diff = 1, pct_diff = 10 / 3
    )
  )
  expect_identical(nrow(unmatched_rows(res)), 0L)
})

test_each_backend("the Listing lists Duplicate IDs and does not count them as Matched observations", {
  base_dup <- rbind(base, base[1, ], base[1, ])
  compare_dup <- rbind(base, base[3, ])

  expect_snapshot(
    df_compare(as_backend(base_dup), as_backend(compare_dup), id = c("usubjid", "visit"))
  )
})

test_each_backend("Return code bits combine when every condition occurs together", {
  base_all <- rbind(base, base[3, ])
  base_all$only_b <- 1
  compare <- rbind(base[1:2, ], data.frame(usubjid = "04", visit = 1, aval = 40))
  compare$aval[1] <- 11
  compare$only_c <- 2
  base_all <- rbind(base_all, data.frame(usubjid = "05", visit = 1, aval = 50, only_b = 1))

  res <- suppressWarnings(
    df_compare(as_backend(base_all), as_backend(compare), id = c("usubjid", "visit"))
  )

  expect_identical(return_code(res), 64L + 128L + 1024L + 2048L + 4096L + 65536L)
  expect_identical(
    unmatched_rows(res),
    tibble::tibble(usubjid = c("05", "04"), visit = c(1, 1), dataset = c("Base", "Compare"))
  )
})

test_each_backend("equal datasets have no Unmatched observations", {
  res <- df_compare(as_backend(base), as_backend(base), id = c("usubjid", "visit"))

  expect_identical(
    unmatched_rows(res),
    tibble::tibble(usubjid = character(), visit = numeric(), dataset = character())
  )
})
