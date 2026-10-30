base <- data.frame(
  usubjid = c("01", "02", "03", "04"),
  aval = c(10, 20, 30, 40),
  avalc = c("a", "b", "c", "d")
)

listing <- function(x) capture.output(print(x))

test_each_backend("max_print caps the Unequal values shown per variable and notes the truncation", {
  compare <- base
  compare$aval <- c(11, 21, 31, 40)

  res <- df_compare(as_backend(base), as_backend(compare), id = "usubjid", max_print = 2)
  out <- listing(res)

  expect_length(grep("^ *0[1-4] +\\|\\|", out), 2)
  expect_true(any(grepl(
    "NOTE: The MAXPRINT=2 printing limit has been reached for the variable aval.",
    out,
    fixed = TRUE
  )))
  expect_identical(nrow(differences(res)), 3L)
})

test_each_backend("max_print must be a positive whole number", {
  expect_snapshot(df_compare(as_backend(base), as_backend(base), id = "usubjid", max_print = 0), error = TRUE)
})

test_each_backend("values within the criterion but not exactly equal are counted and noted", {
  compare <- base
  compare$aval <- c(10.25, 20, 30.5, 40)

  res <- df_compare(
    as_backend(base), as_backend(compare), id = "usubjid",
    method = "absolute", criterion = 0.5
  )
  out <- listing(res)

  expect_identical(return_code(res), 0L)
  expect_true("  Total Number of Values not EXACTLY Equal: 2." %in% out)
  expect_true(any(grepl(
    "NOTE: All values compared are within the equality criterion used. However, 2 of the values compared are not exactly equal.",
    out,
    fixed = TRUE
  )))
})

test_each_backend("the Listing of fully equal datasets", {
  expect_snapshot(print(df_compare(as_backend(base), as_backend(base), id = "usubjid")))
})

test_each_backend("the Listing of datasets with Unequal values only", {
  compare <- base
  compare$aval[2] <- 21
  compare$avalc[4] <- "z"

  expect_snapshot(print(df_compare(as_backend(base), as_backend(compare), id = "usubjid")))
})

test_each_backend("the Listing with every summary section populated", {
  skip_if_backend_drops_attributes(as_backend(base))
  base_all <- rbind(base, base[4, ])
  base_all$only_b <- 1
  base_all$kind <- c("x", "y", "z", "w", "w")
  base_all$n <- 1:5
  attr(base_all$aval, "label") <- "Analysis value"
  attr(base_all, "label") <- "Base data"
  compare <- rbind(base[1:3, ], data.frame(usubjid = "05", aval = 50, avalc = "e"))
  compare$aval[1] <- 10.5
  compare$only_c <- 2
  compare$kind <- c(1, 2, 3, 4)
  compare$n <- c(1, 2, 3, 4)
  attr(compare$aval, "label") <- "AVAL"

  expect_snapshot(
    print(df_compare(as_backend(base_all), as_backend(compare), id = "usubjid"))
  )
})

test_that("the Listing when max_print truncates the Value Comparison Results", {
  compare <- base
  compare$aval <- c(11, 21, 31, 41)

  expect_snapshot(print(df_compare(base, compare, id = "usubjid", max_print = 2)))
})

test_that("the Listing of a positional comparison names the observation number", {
  compare <- base[1:3, ]
  compare$aval[3] <- 33

  expect_snapshot(print(df_compare(base, compare)))
})
