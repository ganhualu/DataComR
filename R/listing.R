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
  listing_type_lines(
    x$conflicting_types,
    "Variables with Conflicting types"
  )
  listing_type_lines(
    x$type_differences,
    "Variables with different types in the same Type family"
  )
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

listing_observation_summary <- function(x) {
  n_obs <- x$n_obs
  cli::cat_line()
  cli::cat_line("Observation Summary")
  cli::cat_line("  Observations in Base:    ", n_obs[["base"]])
  cli::cat_line("  Observations in Compare: ", n_obs[["compare"]])
  cli::cat_line("  Matched on ", paste(x$id, collapse = ", "), ": ", n_obs[["matched"]])
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
