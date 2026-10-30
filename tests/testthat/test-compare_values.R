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
