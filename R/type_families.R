# Type families decide whether two variables' values can be compared at all.
# They are read from a zero-row prototype of each dataset, so the backend only
# sends column types, never data.

# One row per common variable: its Type family and type in each dataset.
variable_types <- function(base, compare, common) {
  base_proto <- prototype(base)[common]
  compare_proto <- prototype(compare)[common]
  tibble::tibble(
    variable = common,
    base_family = vapply(base_proto, type_family, character(1), USE.NAMES = FALSE),
    compare_family = vapply(compare_proto, type_family, character(1), USE.NAMES = FALSE),
    base_type = vapply(base_proto, type_name, character(1), USE.NAMES = FALSE),
    compare_type = vapply(compare_proto, type_name, character(1), USE.NAMES = FALSE)
  )
}

prototype <- function(data) {
  dplyr::collect(utils::head(data, 0))
}

# Dates and datetimes are checked first: they are stored as numbers but form
# families of their own. Anything unrecognised is its own family, so it is
# only compared with variables of the same class.
type_family <- function(x) {
  if (inherits(x, "Date")) {
    "date"
  } else if (inherits(x, "POSIXt")) {
    "datetime"
  } else if (is.character(x) || is.factor(x)) {
    "character"
  } else if (is.numeric(x) || is.logical(x)) {
    "numeric"
  } else {
    class(x)[[1]]
  }
}

# The type shown in the Listing: R's storage type for plain vectors, the
# class for classed ones (factor, Date, POSIXct).
type_name <- function(x) {
  if (is.object(x)) class(x)[[1]] else typeof(x)
}
