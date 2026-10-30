# Expected results for the Comparison methods are worked by hand from SAS PROC
# COMPARE's documented formulas, with x the Base value and y the Compare value:
#   absolute: unequal if |y - x| > criterion
#   relative: unequal if |y - x| / ((|x| + |y|) / 2 + delta) > criterion,
#             equal if x = y = 0
#   percent:  unequal if x != 0 and 100 |y - x| / |x| > criterion,
#             or if x = 0 and y != 0
# Values are chosen to be exact in binary floating point, so boundaries are
# tested exactly.

unequal_ids <- function(res) differences(res)$id

test_each_backend("absolute method: a difference equal to the Criterion is equal, a larger one is unequal", {
  base <- data.frame(id = 1:3, x = c(1, 1, -1))
  compare <- data.frame(id = 1:3, x = c(1.25, 1.5, -1.25))

  res <- df_compare(
    as_backend(base), as_backend(compare), id = "id",
    method = "absolute", criterion = 0.25
  )

  # |1.25 - 1| = 0.25 <= 0.25; |1.5 - 1| = 0.5 > 0.25; |-1.25 - -1| = 0.25
  expect_identical(unequal_ids(res), 2L)
  expect_identical(return_code(res), 4096L)
})

test_each_backend("the default Criterion is 0.00001", {
  base <- data.frame(id = 1:2, x = c(1, 1))
  compare <- data.frame(id = 1:2, x = c(1 + 2^-17, 1 + 2^-16))

  res <- df_compare(as_backend(base), as_backend(compare), id = "id", method = "absolute")

  # 2^-17 = 0.0000076 <= 0.00001; 2^-16 = 0.0000153 > 0.00001
  expect_identical(unequal_ids(res), 2L)
})

test_each_backend("relative method: SAS's formula with the default delta of 0", {
  base <- data.frame(id = 1:5, x = c(1, 1, -1, 0, 0))
  compare <- data.frame(id = 1:5, x = c(3, 3.5, -3, 0, 2^-20))

  res <- df_compare(
    as_backend(base), as_backend(compare), id = "id",
    method = "relative", criterion = 1
  )

  # id 1: |3 - 1| / ((1 + 3) / 2) = 1 <= 1
  # id 2: |3.5 - 1| / ((1 + 3.5) / 2) = 2.5 / 2.25 > 1
  # id 3: |-3 - -1| / ((1 + 3) / 2) = 1 <= 1
  # id 4: x = y = 0 is equal
  # id 5: any difference from 0 has relative difference 2 > 1
  expect_identical(unequal_ids(res), c(2L, 5L))
})

test_each_backend("relative method: delta is added to the denominator", {
  base <- data.frame(id = 1:3, x = c(1, 1, 0))
  compare <- data.frame(id = 1:3, x = c(3, 4, 0.5))

  res <- df_compare(
    as_backend(base), as_backend(compare), id = "id",
    method = "relative", criterion = 0.75, relative_delta = 0.5
  )

  # id 1: |3 - 1| / ((1 + 3) / 2 + 0.5) = 2 / 2.5 = 0.8 > 0.75
  # id 2: |4 - 1| / ((1 + 4) / 2 + 0.5) = 3 / 3 = 1 > 0.75
  # id 3: |0.5 - 0| / ((0 + 0.5) / 2 + 0.5) = 0.5 / 0.75 = 0.667 <= 0.75
  expect_identical(unequal_ids(res), c(1L, 2L))

  res <- df_compare(
    as_backend(base), as_backend(compare), id = "id",
    method = "relative", criterion = 0.8, relative_delta = 0.5
  )

  # id 1 is now on the boundary: 0.8 <= 0.8
  expect_identical(unequal_ids(res), 2L)
})

test_each_backend("percent method: SAS's formula, relative to the Base value", {
  base <- data.frame(id = 1:6, x = c(4, 4, 5, -4, 0, 0))
  compare <- data.frame(id = 1:6, x = c(5, 5.5, 4, -5, 0, 2^-20))

  res <- df_compare(
    as_backend(base), as_backend(compare), id = "id",
    method = "percent", criterion = 25
  )

  # id 1: 100 * |5 - 4| / 4 = 25 <= 25
  # id 2: 100 * |5.5 - 4| / 4 = 37.5 > 25
  # id 3: 100 * |4 - 5| / 5 = 20 <= 25 (the Base value is the denominator)
  # id 4: 100 * |-5 - -4| / 4 = 25 <= 25
  # id 5: x = 0 and y = 0 is equal
  # id 6: x = 0 and y != 0 is unequal, whatever the Criterion
  expect_identical(unequal_ids(res), c(2L, 6L))
})

test_each_backend("differences() gives diff and pct_diff for numeric Unequal values only", {
  base <- data.frame(id = 1:4, x = c(4, -8, 0, NA), s = c("a", "b", "c", "d"))
  compare <- data.frame(id = 1:4, x = c(5, -6, 2, 1), s = c("a", "b", "z", "d"))

  res <- df_compare(as_backend(base), as_backend(compare), id = "id")

  # diff is Compare - Base; pct_diff is 100 * diff / Base, missing when Base
  # is 0 or either value is missing.
  expect_identical(
    differences(res),
    tibble::tibble(
      id = c(1L, 2L, 3L, 4L, 3L),
      variable = c("x", "x", "x", "x", "s"),
      base = c("4", "-8", "0", NA, "c"),
      compare = c("5", "-6", "2", "1", "z"),
      diff = c(1, 2, 2, NA, NA),
      pct_diff = c(25, -25, NA, NA, NA)
    )
  )
})

test_each_backend("integer, double and logical are one Type family, compared by value", {
  base <- data.frame(id = 1:3, n = c(1L, 2L, 3L), flag = c(TRUE, FALSE, TRUE))
  compare <- data.frame(id = 1:3, n = c(1, 2, 3.5), flag = c(1, 0, 1))

  res <- df_compare(as_backend(base), as_backend(compare), id = "id")

  expect_identical(return_code(res), 4096L)
  expect_identical(
    differences(res),
    tibble::tibble(
      id = 3L, variable = "n", base = "3", compare = "3.5",
      diff = 0.5, pct_diff = 100 / 6
    )
  )
})

test_each_backend("factor and character are one Type family, compared by labels", {
  base <- data.frame(
    id = 1:3,
    s = factor(c("a", "b", "c"), levels = c("c", "b", "a")),
    f = factor(c("x", "y", "y"))
  )
  compare <- data.frame(
    id = 1:3,
    s = c("a", "b", "z"),
    f = factor(c("x", "y", "w"), levels = c("y", "x", "w"))
  )

  res <- df_compare(as_backend(base), as_backend(compare), id = "id")

  # Level order and level sets play no part, only the labels.
  expect_identical(
    differences(res)[c("id", "variable", "base", "compare")],
    tibble::tibble(id = c(3L, 3L), variable = c("s", "f"), base = c("c", "y"), compare = c("z", "w"))
  )
})

test_each_backend("a type difference within a Type family is listed but sets no bit", {
  base <- data.frame(id = 1:2, n = c(1L, 2L), s = factor(c("a", "b")), x = c(1, 2))
  compare <- data.frame(id = 1:2, n = c(1, 2), s = c("a", "b"), x = c(1, 2))

  res <- df_compare(as_backend(base), as_backend(compare), id = "id")

  expect_identical(return_code(res), 0L)
  expect_snapshot(print(res))
})

test_each_backend("numeric against character is Conflicting types: listed, bit 8192, not value-compared", {
  base <- data.frame(id = 1:2, x = c(1, 2), y = c(1, 2))
  compare <- data.frame(id = 1:2, x = c("1", "z"), y = c(1, 3))

  res <- df_compare(as_backend(base), as_backend(compare), id = "id")

  # 8192 Conflicting types + 4096 for the Unequal value of y
  expect_identical(return_code(res), 8192L + 4096L)
  expect_identical(unique(differences(res)$variable), "y")
  expect_snapshot(print(res))
})

test_each_backend("date, datetime, numeric and character are four Type families", {
  day <- as.Date("2024-01-01")
  instant <- as.POSIXct("2024-01-01 00:00:00", tz = "UTC")
  base <- data.frame(id = 1, a = day, b = instant, c = day, d = instant)
  compare <- data.frame(id = 1, a = instant, b = 1, c = "2024-01-01", d = day)

  res <- df_compare(as_backend(base), as_backend(compare), id = "id")

  expect_identical(return_code(res), 8192L)
  expect_identical(nrow(differences(res)), 0L)
  expect_snapshot(print(res))
})

test_each_backend("dates one day apart are unequal under every Comparison method", {
  base <- data.frame(id = 1:2, d = as.Date(c("2024-01-01", "2024-03-01")))
  compare <- data.frame(id = 1:2, d = as.Date(c("2024-01-02", "2024-03-01")))

  for (method in c("exact", "absolute", "relative", "percent")) {
    res <- df_compare(
      as_backend(base), as_backend(compare), id = "id",
      method = method, criterion = 1000
    )
    expect_identical(
      differences(res),
      tibble::tibble(
        id = 1L, variable = "d", base = "2024-01-01", compare = "2024-01-02",
        diff = NA_real_, pct_diff = NA_real_
      )
    )
  }
})

test_each_backend("datetimes are compared as instants, whatever their time zone", {
  utc <- as.POSIXct(c("2024-01-01 12:00:00", "2024-01-01 12:00:00"), tz = "UTC")
  base <- data.frame(id = 1:2, t = utc)
  compare <- data.frame(id = 1:2, t = utc + c(0, 1))
  attr(compare$t, "tzone") <- "America/New_York"

  res <- df_compare(
    as_backend(base), as_backend(compare), id = "id",
    method = "absolute", criterion = 5
  )

  # 12:00 UTC is 07:00 in New York: the same instant. One second later is
  # unequal even though the Criterion is 5.
  expect_identical(differences(res)$id, 2L)
  expect_identical(differences(res)$diff, NA_real_)
})

test_each_backend("NaN is a missing value: equal to NA, unequal to a number", {
  base <- data.frame(id = 1:3, x = c(NaN, NaN, NA))
  compare <- data.frame(id = 1:3, x = c(NA, 1, NaN))

  res <- df_compare(as_backend(base), as_backend(compare), id = "id")

  expect_identical(differences(res)$id, 2L)
  expect_identical(differences(res)$base, NA_character_)
})

# haven's tagged NAs live in the payload bits of a double NA, which arrow and
# duckdb do not keep, so these rules are tested on data frames only.
test_that("special missings are equal only when they carry the same letter", {
  skip_if_not_installed("haven")
  na_a <- haven::tagged_na("a")
  na_b <- haven::tagged_na("b")
  base <- data.frame(id = 1:5, x = c(na_a, na_a, na_a, NA, 1))
  compare <- data.frame(id = 1:5, x = c(na_a, na_b, NA, NaN, na_a))

  res <- df_compare(base, compare, id = "id")

  # .A = .A; .A != .B; .A != . ; . = NaN; 1 != .A
  expect_identical(return_code(res), 4096L)
  expect_identical(
    differences(res),
    tibble::tibble(
      id = c(2L, 3L, 5L), variable = "x",
      base = c("NA(a)", "NA(a)", "1"), compare = c("NA(b)", NA, "NA(a)"),
      diff = NA_real_, pct_diff = NA_real_
    )
  )
})

test_each_backend("an unknown Comparison method is an error", {
  df <- data.frame(id = 1, x = 1)

  expect_snapshot(
    df_compare(as_backend(df), as_backend(df), id = "id", method = "absolut"),
    error = TRUE
  )
})

test_each_backend("an invalid Criterion or relative_delta is an error", {
  df <- data.frame(id = 1, x = 1)
  cmp <- function(...) df_compare(as_backend(df), as_backend(df), id = "id", ...)

  expect_snapshot(error = TRUE, {
    cmp(method = "absolute", criterion = -1)
    cmp(method = "absolute", criterion = NA_real_)
    cmp(method = "absolute", criterion = "0.1")
    cmp(method = "absolute", criterion = c(0.1, 0.2))
    cmp(method = "relative", relative_delta = 2)
    cmp(method = "relative", relative_delta = -0.1)
  })
})
