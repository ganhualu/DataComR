pairing_base <- data.frame(
  usubjid = c("01", "02"),
  aval = c(1, 2),
  avalc = c("a", "b"),
  ady = c(10, 20)
)

test_each_backend("var limits the comparison of values to the named variables", {
  compare <- pairing_base
  compare$aval <- c(1, 3)
  compare$avalc <- c("a", "z")
  compare$ady <- c(11, 20)

  res <- df_compare(
    as_backend(pairing_base), as_backend(compare),
    id = "usubjid", var = c("aval", "ady")
  )

  expect_identical(return_code(res), 4096L)
  expect_identical(
    differences(res),
    tibble::tibble(
      usubjid = c("02", "01"), variable = c("aval", "ady"),
      base = c("2", "10"), compare = c("3", "11"),
      diff = c(1, 1), pct_diff = c(50, 10)
    )
  )
})

test_each_backend("with pairs a var variable with a differently named Compare variable", {
  compare <- data.frame(
    usubjid = c("01", "02"),
    aval = c(1, 2),
    avalc = c("a", "b"),
    study_day = c(10, 21)
  )

  res <- df_compare(
    as_backend(pairing_base), as_backend(compare),
    id = "usubjid", var = c("aval", "ady"), with = c("aval", "study_day")
  )

  expect_identical(return_code(res), 4096L)
  expect_identical(
    differences(res),
    tibble::tibble(
      usubjid = "02", variable = "ady", base = "20", compare = "21",
      diff = 1, pct_diff = 5
    )
  )
})

test_each_backend("the attributes of a with pair are compared and reported by the Base name", {
  skip_if_backend_drops_attributes(as_backend(pairing_base))
  base <- pairing_base
  attr(base$ady, "label") <- "Study Day"
  compare <- pairing_base
  names(compare)[names(compare) == "ady"] <- "study_day"
  attr(compare$study_day, "label") <- "Analysis Day"

  res <- df_compare(
    as_backend(base), as_backend(compare),
    id = "usubjid", var = "ady", with = "study_day"
  )

  expect_identical(return_code(res), 32L)
  expect_snapshot(res)
})

test_each_backend("var still reports variables in only one dataset", {
  base <- pairing_base
  base$base_extra <- c(1, 2)
  compare <- pairing_base
  compare$avalc <- c("x", "y")
  compare$compare_extra <- c(1, 2)

  res <- df_compare(as_backend(base), as_backend(compare), id = "usubjid", var = "aval")

  expect_identical(return_code(res), 1024L + 2048L)
  expect_identical(nrow(differences(res)), 0L)
  expect_snapshot(res)
})

test_each_backend("var still compares the attributes of variables it does not name", {
  skip_if_backend_drops_attributes(as_backend(pairing_base))
  base <- pairing_base
  attr(base$avalc, "label") <- "Character Value"

  res <- df_compare(as_backend(base), as_backend(pairing_base), id = "usubjid", var = "aval")

  expect_identical(return_code(res), 32L)
})

test_each_backend("with without var is an error", {
  expect_snapshot(
    df_compare(as_backend(pairing_base), as_backend(pairing_base), id = "usubjid", with = "aval"),
    error = TRUE
  )
})

test_each_backend("var and with of different lengths are an error", {
  expect_snapshot(
    df_compare(
      as_backend(pairing_base), as_backend(pairing_base),
      id = "usubjid", var = c("aval", "ady"), with = "aval"
    ),
    error = TRUE
  )
})

test_each_backend("var and with naming variables not in their dataset are an error", {
  compare <- pairing_base[c("usubjid", "aval", "avalc")]

  expect_snapshot(error = TRUE, {
    df_compare(as_backend(pairing_base), as_backend(compare), id = "usubjid", var = c("aval", "chg"))
    df_compare(as_backend(pairing_base), as_backend(compare), id = "usubjid", var = c("aval", "ady"))
    df_compare(
      as_backend(pairing_base), as_backend(compare),
      id = "usubjid", var = c("aval", "ady"), with = c("aval", "study_day")
    )
  })
})

test_each_backend("var or with naming an ID variable is an error", {
  b <- as_backend(pairing_base)
  cmp <- as_backend(pairing_base)

  expect_snapshot(error = TRUE, {
    df_compare(b, cmp, id = "usubjid", var = c("usubjid", "aval"))
    df_compare(b, cmp, id = "usubjid", var = "avalc", with = "usubjid")
  })
})

test_each_backend("var and with must be character vectors naming each Base variable once", {
  b <- as_backend(pairing_base)
  cmp <- as_backend(pairing_base)

  expect_snapshot(error = TRUE, {
    df_compare(b, cmp, id = "usubjid", var = 1)
    df_compare(b, cmp, id = "usubjid", var = character())
    df_compare(b, cmp, id = "usubjid", var = "aval", with = 2)
    df_compare(b, cmp, id = "usubjid", var = c("aval", "aval"), with = c("aval", "ady"))
  })
})

# SAS-style upper-case names, as read from a SAS transport file.
upper_compare <- data.frame(
  USUBJID = c("01", "02"),
  AVAL = c(1, 3),
  AVALC = c("a", "b"),
  ADY = c(10, 20)
)

test_each_backend("by default variable names are case-sensitive, so USUBJID is not usubjid", {
  base <- data.frame(visit = c(1, 2), usubjid = c("01", "01"), aval = c(1, 2))
  compare <- data.frame(visit = c(1, 2), USUBJID = c("01", "01"), AVAL = c(1, 2))

  res <- df_compare(as_backend(base), as_backend(compare), id = "visit")

  expect_identical(return_code(res), 1024L + 2048L)
  expect_snapshot(res)
})

test_each_backend("ignore_case = TRUE pairs variables whose names differ only in case", {
  res <- df_compare(
    as_backend(pairing_base), as_backend(upper_compare),
    id = "usubjid", ignore_case = TRUE
  )

  expect_identical(return_code(res), 4096L)
  expect_identical(
    differences(res),
    tibble::tibble(
      usubjid = "02", variable = "aval", base = "2", compare = "3",
      diff = 1, pct_diff = 50
    )
  )
  expect_identical(unmatched_rows(res), tibble::tibble(usubjid = character(), dataset = character()))
})

test_each_backend("with ignore_case = TRUE, id, var and with match in any case and results use Base names", {
  compare <- data.frame(
    USUBJID = c("01", "02", "03"),
    AVAL = c(1, 3, 5),
    STUDY_DAY = c(11, 20, 30)
  )

  res <- df_compare(
    as_backend(pairing_base), as_backend(compare),
    id = "USUBJID", var = c("AVAL", "Ady"), with = c("aval", "study_day"),
    ignore_case = TRUE
  )

  expect_identical(return_code(res), 128L + 1024L + 4096L)
  expect_identical(
    differences(res),
    tibble::tibble(
      usubjid = c("02", "01"), variable = c("aval", "ady"),
      base = c("2", "10"), compare = c("3", "11"),
      diff = c(1, 1), pct_diff = c(50, 10)
    )
  )
  expect_identical(unmatched_rows(res), tibble::tibble(usubjid = "03", dataset = "Compare"))
  expect_snapshot(res)
})

# duckdb identifiers are case-insensitive, so a duckdb table can't hold two
# names that differ only in case; these fixtures run on data frames and arrow.
test_each_backend("with ignore_case = TRUE, names differing only in case within one dataset are an error", {
  skip_if(inherits(as_backend(pairing_base), "tbl_lazy"), "duckdb names are case-insensitive")
  colliding <- pairing_base
  colliding$AVAL <- colliding$aval
  colliding$Ady <- colliding$ady

  expect_snapshot(error = TRUE, {
    df_compare(as_backend(colliding), as_backend(pairing_base), id = "usubjid", ignore_case = TRUE)
    df_compare(as_backend(pairing_base), as_backend(colliding), id = "usubjid", ignore_case = TRUE)
  })
})

test_each_backend("ignore_case must be TRUE or FALSE", {
  expect_snapshot(
    df_compare(as_backend(pairing_base), as_backend(pairing_base), id = "usubjid", ignore_case = "yes"),
    error = TRUE
  )
})

test_each_backend("names differing only in case within one dataset are distinct variables by default", {
  skip_if(inherits(as_backend(pairing_base), "tbl_lazy"), "duckdb names are case-insensitive")
  base <- pairing_base
  base$AVAL <- c(5, 6)
  compare <- base
  compare$AVAL <- c(5, 7)

  res <- df_compare(as_backend(base), as_backend(compare), id = "usubjid")

  expect_identical(differences(res)$variable, "AVAL")
})

test_that("var, with and ignore_case work when matching by position", {
  base <- data.frame(A = 1:3, B = c("x", "y", "z"), C = c(1, 2, 3))
  compare <- data.frame(a = c(1L, 9L), b2 = c("x", "q"), c = c(1, 2))

  res <- df_compare(base, compare, var = c("A", "B"), with = c("a", "b2"), ignore_case = TRUE)

  expect_identical(return_code(res), 4096L + 64L)
  expect_identical(
    differences(res),
    tibble::tibble(
      obs = c(2L, 2L), variable = c("A", "B"), base = c("2", "y"), compare = c("9", "q"),
      diff = c(7, NA), pct_diff = c(350, NA)
    )
  )
  expect_identical(unmatched_rows(res), tibble::tibble(obs = 3L, dataset = "Base"))
})
