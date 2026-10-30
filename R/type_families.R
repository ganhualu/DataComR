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

# Common variables whose versions belong to different Type families: listed
# with type and family on each side, and never value-compared.
conflicting_types <- function(types) {
  conflicting <- types[types$base_family != types$compare_family, ]
  tibble::tibble(
    variable = conflicting$variable,
    base_type = paste0(conflicting$base_type, " (", conflicting$base_family, ")"),
    compare_type = paste0(conflicting$compare_type, " (", conflicting$compare_family, ")")
  )
}

# Common variables of one Type family stored as different types (e.g.
# integer and double): compared as usual, listed for information only.
type_differences <- function(types) {
  differ <- types[types$base_family == types$compare_family &
    types$base_type != types$compare_type, ]
  differ[c("variable", "base_type", "compare_type")]
}

# A named list of zero-length columns (a list, so that `[` selects columns
# whatever the input class, data.table included).
prototype <- function(data) {
  as.list(dplyr::collect(utils::head(data, 0)))
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
