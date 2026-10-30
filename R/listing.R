#' @export
print.df_compare <- function(x, ...) {
  cli::cat_rule("The COMPARE Procedure")
  cli::cat_line("Comparison of Base with Compare")
  listing_variables_summary(x)
  listing_observation_summary(x)
  listing_values_summary(x)
  listing_return_code(x)
  invisible(x)
}

# Listing sections, in PROC COMPARE's order. Each starts with a blank line.

listing_variables_summary <- function(x) {
  cli::cat_line()
  cli::cat_line("Variables Summary")
  cli::cat_line("  Variables compared: ", length(x$compared))
  listing_one_sided_variables(x$base_only, "Base", "Compare")
  listing_one_sided_variables(x$compare_only, "Compare", "Base")
}

listing_one_sided_variables <- function(variables, dataset, other) {
  if (length(variables) > 0) {
    cli::cat_line(
      "  Variables in ", dataset, " but not in ", other, ": ", length(variables),
      " (", paste(variables, collapse = ", "), ")"
    )
  }
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
  id_values <- lapply(id, function(v) paste0(v, "=", format_value(duplicates[[v]])))
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
