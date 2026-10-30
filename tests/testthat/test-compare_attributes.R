attr_base <- data.frame(
  usubjid = c("01", "02"),
  aval = c(1.5, 2),
  avalc = c("a", "b")
)

with_attr <- function(x, ...) {
  attrs <- list(...)
  for (name in names(attrs)) attr(x, name) <- attrs[[name]]
  x
}

test_each_backend("a differing variable label is an Attribute difference, not an Unequal value", {
  skip_if_backend_drops_attributes(as_backend(attr_base))
  base <- attr_base
  base$aval <- with_attr(base$aval, label = "Analysis Value")
  compare <- attr_base
  compare$aval <- with_attr(compare$aval, label = "Analysis value")

  res <- df_compare(as_backend(base), as_backend(compare), id = "usubjid")

  expect_identical(return_code(res), 32L)
  expect_identical(nrow(differences(res)), 0L)
})

test_each_backend("a differing SAS format is an Attribute difference with bit 8", {
  skip_if_backend_drops_attributes(as_backend(attr_base))
  base <- attr_base
  base$aval <- with_attr(base$aval, format.sas = "8.2")
  compare <- attr_base
  compare$aval <- with_attr(compare$aval, format.sas = "8.1")

  res <- df_compare(as_backend(base), as_backend(compare), id = "usubjid")

  expect_identical(return_code(res), 8L)
  expect_identical(nrow(differences(res)), 0L)
})

test_each_backend("a differing width is an Attribute difference with bit 16", {
  skip_if_backend_drops_attributes(as_backend(attr_base))
  base <- attr_base
  base$avalc <- with_attr(base$avalc, width = 8L)
  compare <- attr_base
  compare$avalc <- with_attr(compare$avalc, width = 200L)

  res <- df_compare(as_backend(base), as_backend(compare), id = "usubjid")

  expect_identical(return_code(res), 16L)
  expect_identical(nrow(differences(res)), 0L)
})

test_each_backend("an attribute present on only one side is an Attribute difference", {
  skip_if_backend_drops_attributes(as_backend(attr_base))
  base <- attr_base
  base$aval <- with_attr(base$aval, label = "Analysis Value", format.sas = "8.2")
  compare <- attr_base
  compare$avalc <- with_attr(compare$avalc, width = 8L)

  res <- df_compare(as_backend(base), as_backend(compare), id = "usubjid")

  expect_identical(return_code(res), 8L + 16L + 32L)
})

test_each_backend("ID variables are common variables, so their attributes are compared", {
  skip_if_backend_drops_attributes(as_backend(attr_base))
  base <- attr_base
  base$usubjid <- with_attr(base$usubjid, label = "Unique Subject Identifier")
  compare <- attr_base

  res <- df_compare(as_backend(base), as_backend(compare), id = "usubjid")

  expect_identical(return_code(res), 32L)
})

test_each_backend("differing dataset labels set bit 1", {
  skip_if_backend_drops_attributes(as_backend(attr_base))
  base <- with_attr(attr_base, label = "Analysis Dataset")
  compare <- with_attr(attr_base, label = "Analysis dataset")

  res <- df_compare(as_backend(base), as_backend(compare), id = "usubjid")

  expect_identical(return_code(res), 1L)
  expect_identical(nrow(differences(res)), 0L)
})

test_each_backend("datasets read with haven are compared on their labels and SAS formats", {
  skip_if_backend_drops_attributes(as_backend(attr_base))
  skip_if_not_installed("haven")
  round_trip_xpt <- function(df, label) {
    path <- tempfile(fileext = ".xpt")
    on.exit(unlink(path))
    haven::write_xpt(df, path, label = label)
    haven::read_xpt(path)
  }
  base <- attr_base
  base$aval <- with_attr(base$aval, label = "Analysis Value", format.sas = "8.2")
  compare <- attr_base
  compare$aval <- with_attr(compare$aval, label = "Analysis Value", format.sas = "8.1")
  base_xpt <- round_trip_xpt(base, "ADSL")
  compare_xpt <- round_trip_xpt(compare, "ADSL v2")

  same <- df_compare(as_backend(base_xpt), as_backend(base_xpt), id = "usubjid")
  res <- df_compare(as_backend(base_xpt), as_backend(compare_xpt), id = "usubjid")

  expect_identical(return_code(same), 0L)
  expect_identical(return_code(res), 1L + 8L)
  expect_identical(nrow(differences(res)), 0L)
})

test_each_backend("the Listing shows dataset labels and Attribute differences", {
  skip_if_backend_drops_attributes(as_backend(attr_base))
  base <- with_attr(attr_base, label = "Analysis Dataset")
  base$aval <- with_attr(base$aval, label = "Analysis Value", format.sas = "8.2")
  base$avalc <- with_attr(base$avalc, width = 8L)
  compare <- attr_base
  compare$aval <- with_attr(compare$aval, label = "Analysis value", format.sas = "8.2")
  compare$avalc <- with_attr(compare$avalc, width = 200L)

  expect_snapshot(df_compare(as_backend(base), as_backend(compare), id = "usubjid"))
})

# Backend-specific: arrow keeps R attributes in its metadata, duckdb drops them.
# These run outside test_each_backend() because their expected results differ.

test_that("arrow data keeps R attributes, so its Attribute differences are found", {
  skip_if_not_installed("arrow")
  base <- with_attr(attr_base, label = "Analysis Dataset")
  base$aval <- with_attr(base$aval, label = "Analysis Value")
  compare <- attr_base
  compare$aval <- with_attr(compare$aval, label = "Analysis value")

  res <- df_compare(arrow::arrow_table(base), arrow::arrow_table(compare), id = "usubjid")

  expect_identical(return_code(res), 1L + 32L)
})

test_that("duckdb tables carry no R attributes, so they have no Attribute differences", {
  skip_if_not_installed("duckdb")
  skip_if_not_installed("dbplyr")
  con <- DBI::dbConnect(duckdb::duckdb())
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE))
  base <- with_attr(attr_base, label = "Analysis Dataset")
  base$aval <- with_attr(base$aval, label = "Analysis Value", format.sas = "8.2")
  compare <- attr_base
  compare$aval <- with_attr(compare$aval, label = "Analysis value", format.sas = "8.1")
  duckdb::duckdb_register(con, "base", base)
  duckdb::duckdb_register(con, "compare", compare)

  res <- df_compare(dplyr::tbl(con, "base"), dplyr::tbl(con, "compare"), id = "usubjid")

  expect_identical(return_code(res), 0L)
})
