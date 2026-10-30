# The R attribute behind each kind of Attribute difference, in reporting order.
ATTRIBUTES <- c(label = "label", format = "format.sas", width = "width")

# Compares the dataset labels and the attributes of every pair of Base and
# Compare variables (`base_vars`, `compare_vars`), reported by Base name.
# Returns a list of
# - `dataset_labels`: the Base and Compare dataset labels (NA where absent);
# - `attribute_differences`: a tibble with one row per Attribute difference:
#   variable, attribute, base, compare (character; NA where absent).
# When either dataset's backend carries no R attributes, nothing is compared,
# so a backend that drops attributes never produces Attribute differences.
compare_attributes <- function(base, compare, base_vars, compare_vars) {
  base <- attribute_prototype(base)
  compare <- attribute_prototype(compare)
  if (is.null(base) || is.null(compare)) {
    base <- compare <- NULL
    base_vars <- compare_vars <- character()
  }
  list(
    dataset_labels = c(
      base = attribute_text(base, "label"),
      compare = attribute_text(compare, "label")
    ),
    attribute_differences = dplyr::bind_rows(
      tibble::tibble(
        variable = character(), attribute = character(),
        base = character(), compare = character()
      ),
      Map(function(variable, compare_variable) {
        variable_attribute_differences(variable, base[[variable]], compare[[compare_variable]])
      }, base_vars, compare_vars, USE.NAMES = FALSE)
    )
  )
}

variable_attribute_differences <- function(variable, base_values, compare_values) {
  b <- vapply(ATTRIBUTES, function(a) attribute_text(base_values, a), character(1))
  cmp <- vapply(ATTRIBUTES, function(a) attribute_text(compare_values, a), character(1))
  differs <- attribute_differs(b, cmp)
  tibble::tibble(
    variable = rep(variable, sum(differs)),
    attribute = names(ATTRIBUTES)[differs],
    base = unname(b[differs]),
    compare = unname(cmp[differs])
  )
}

# An in-memory data frame whose dataset and variable attributes are those the
# backend exposes, or NULL when the backend carries no R attributes. Data
# frames are used as they are (subsetting rows would drop variable
# attributes); arrow restores R attributes from its metadata when a zero-row
# slice is collected; lazy database tables (duckdb via dbplyr) have none.
attribute_prototype <- function(data) {
  if (is.data.frame(data)) {
    return(data)
  }
  if (inherits(data, "tbl_lazy")) {
    return(NULL)
  }
  dplyr::collect(utils::head(data, 0))
}

# An attribute present on only one side differs; absent on both does not.
attribute_differs <- function(b, cmp) {
  dplyr::coalesce(b != cmp, is.na(b) != is.na(cmp))
}

# An attribute as text, or NA when absent. Widths of 8L and 8 are equal.
attribute_text <- function(x, which) {
  value <- attr(x, which, exact = TRUE)
  if (is.null(value)) {
    return(NA_character_)
  }
  paste(as.character(value), collapse = " ")
}
