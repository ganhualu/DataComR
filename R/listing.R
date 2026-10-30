#' @export
print.df_compare <- function(x, ...) {
  cli::cat_rule("The COMPARE Procedure")
  cli::cat_line("Comparison of Base with Compare")
  listing_dataset_summary(x)
  listing_variables_summary(x)
  listing_observation_summary(x)
  listing_values_summary(x)
  listing_return_code(x)
  invisible(x)
}

# Listing sections, in PROC COMPARE's order. Each starts with a blank line.

# Shown only when either dataset has a label, the one dataset attribute
# compared.
listing_dataset_summary <- function(x) {
  labels <- x$dataset_labels
  if (all(is.na(labels))) {
    return(invisible())
  }
  cli::cat_line()
  cli::cat_line("Dataset Summary")
  cli::cat_line("  Base label:    ", absent_as_none(labels[["base"]]))
  cli::cat_line("  Compare label: ", absent_as_none(labels[["compare"]]))
}

listing_variables_summary <- function(x) {
  cli::cat_line()
  cli::cat_line("Variables Summary")
  cli::cat_line("  Variables compared: ", length(x$compared))
  listing_one_sided_variables(x$base_only, "Base", "Compare")
  listing_one_sided_variables(x$compare_only, "Compare", "Base")
  listing_type_lines(
    x$conflicting_types,
    "Variables with Conflicting types"
  )
  listing_type_lines(
    x$type_differences,
    "Variables with different types in the same Type family"
  )
  listing_attribute_differences(x$attribute_differences)
}

listing_one_sided_variables <- function(variables, dataset, other) {
  if (length(variables) > 0) {
    cli::cat_line(
      "  Variables in ", dataset, " but not in ", other, ": ", length(variables),
      " (", paste(variables, collapse = ", "), ")"
    )
  }
}

# One line per variable, showing its type in each dataset. Nothing is shown
# when there are no such variables.
listing_type_lines <- function(types, heading) {
  if (is.null(types) || nrow(types) == 0) {
    return(invisible())
  }
  cli::cat_line("  ", heading, ": ", nrow(types))
  cli::cat_line(paste0(
    "    ", types$variable, ": ", types$base_type, " in Base, ",
    types$compare_type, " in Compare"
  ))
}

listing_attribute_differences <- function(attribute_differences) {
  if (nrow(attribute_differences) == 0) {
    return(invisible())
  }
  cli::cat_line(
    "  Variables with Attribute differences: ",
    length(unique(attribute_differences$variable))
  )
  cli::cat_line()
  cli::cat_line("  Attribute differences")
  listing_table(list(
    Variable = attribute_differences$variable,
    Attribute = attribute_differences$attribute,
    Base = absent_as_none(attribute_differences$base),
    Compare = absent_as_none(attribute_differences$compare)
  ))
}

# Prints named columns as a left-aligned table under their names.
listing_table <- function(columns) {
  padded <- Map(function(name, values) format(c(name, values)), names(columns), columns)
  rows <- do.call(paste, c(unname(padded), sep = "  "))
  cli::cat_line("    ", trimws(rows, which = "right"))
}

absent_as_none <- function(x) {
  ifelse(is.na(x), "(none)", x)
}

listing_observation_summary <- function(x) {
  n_obs <- x$n_obs
  cli::cat_line()
  cli::cat_line("Observation Summary")
  cli::cat_line("  Observations in Base:    ", n_obs[["base"]])
  cli::cat_line("  Observations in Compare: ", n_obs[["compare"]])
  cli::cat_line("  Matched on ", paste(x$id, collapse = ", "), ": ", n_obs[["matched"]])
  unmatched <- unmatched_rows(x)
  listing_unmatched_count(sum(unmatched$dataset == "Base"), "Base", "Compare")
  listing_unmatched_count(sum(unmatched$dataset == "Compare"), "Compare", "Base")
  listing_duplicate_ids(x$duplicates, x$id)
}

# One line per Duplicate ID: the dataset, its ID values and how many
# observations share them.
listing_duplicate_ids <- function(duplicates, id) {
  if (nrow(duplicates) == 0) {
    return(invisible())
  }
  id_values <- lapply(id, function(v) {
    paste0(v, "=", format_value(duplicates[[v]], numeric = is.numeric(duplicates[[v]])))
  })
  id_values <- do.call(paste, c(id_values, sep = ", "))
  cli::cat_line("  Duplicate IDs (not compared): ", nrow(duplicates))
  cli::cat_line(
    "    ", format(duplicates$dataset), "  ", id_values,
    " (", duplicates$.n, " observations)"
  )
}

# Like PROC COMPARE, a line only for datasets that have Unmatched observations.
listing_unmatched_count <- function(n, dataset, other) {
  if (n > 0) {
    cli::cat_line("  Observations in ", dataset, " but not in ", other, ": ", n)
  }
}

listing_values_summary <- function(x) {
  unequal <- differences(x)
  cli::cat_line()
  cli::cat_line("Values Summary")
  cli::cat_line("  Variables with Unequal values: ", length(unique(unequal$variable)))
  cli::cat_line("  Total Unequal values:          ", nrow(unequal))
  if (nrow(unequal) == 0) {
    cli::cat_line()
    cli::cat_line("NOTE: No unequal values were found. All values compared are exactly equal.")
  }
}

listing_return_code <- function(x) {
  cli::cat_line()
  cli::cat_line("Return code: ", return_code(x))
}
