#' @export
print.df_compare <- function(x, ...) {
  n_obs <- x$n_obs
  diffs <- x$differences
  cli::cat_rule("The COMPARE Procedure")
  cli::cat_line("Comparison of Base with Compare")
  cli::cat_line()
  cli::cat_line("Observation Summary")
  cli::cat_line("  Observations in Base:    ", n_obs[["base"]])
  cli::cat_line("  Observations in Compare: ", n_obs[["compare"]])
  cli::cat_line("  Matched on ", paste(x$id, collapse = ", "), ": ", n_obs[["matched"]])
  cli::cat_line()
  cli::cat_line("Values Summary")
  cli::cat_line("  Variables compared:            ", length(x$compared))
  cli::cat_line("  Variables with Unequal values: ", length(unique(diffs$variable)))
  cli::cat_line("  Total Unequal values:          ", nrow(diffs))
  if (nrow(diffs) == 0) {
    cli::cat_line()
    cli::cat_line("NOTE: No unequal values were found. All values compared are exactly equal.")
  }
  cli::cat_line()
  cli::cat_line("Return code: ", return_code(x))
  invisible(x)
}
