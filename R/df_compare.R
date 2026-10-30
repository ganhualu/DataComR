#' Compare two datasets the way PROC COMPARE does
#'
#' @param base The Base dataset: the reference the comparison reports against.
#'   A data frame (including tibbles), an arrow Table or Dataset, or a duckdb
#'   table (a dbplyr lazy table on a duckdb connection).
#' @param compare The Compare dataset, checked against `base`. Any of the
#'   types accepted for `base`, in any combination with it.
#' @param id Character vector of ID variables used to pair observations.
#' @return A `df_compare` object.
#'
#' @section Backends:
#' The comparison runs as dplyr verbs inside the datasets' own backend; only
#' observation counts and Unequal values are collected into R, never the full
#' datasets. When the two datasets live in different backends they are brought
#' into one without collecting them:
#'
#' * a data frame compared with a duckdb table is registered in the duckdb
#'   connection as a view;
#' * a data frame compared with arrow data is converted to an arrow Table;
#' * arrow data compared with a duckdb table is registered in the duckdb
#'   connection through arrow's zero-copy interface.
#'
#' Two duckdb tables must share one connection. arrow, duckdb, dbplyr and DBI
#' are optional; an informative error names any that an input needs but that
#' is not installed.
#'
#' Attributes and special missings that a backend does not preserve (for
#' example variable labels, SAS formats or haven tagged `NA`s in a duckdb
#' table) are treated as absent for that dataset.
#' @export
df_compare <- function(base, compare, id) {
  check_id(id)
  inputs <- one_backend(base, compare)
  on.exit(inputs$cleanup(), add = TRUE)
  base <- inputs$base
  compare <- inputs$compare
  check_id_present(id, colnames(base), "Base")
  check_id_present(id, colnames(compare), "Compare")

  common <- setdiff(intersect(colnames(base), colnames(compare)), id)
  pairs <- variable_pairs(common)
  matched <- match_observations(base, compare, id, pairs)

  new_df_compare(
    differences = compare_values(matched, base, id, pairs),
    id = id,
    compared = common,
    n_obs = c(
      base = count_obs(base),
      compare = count_obs(compare),
      matched = count_obs(matched)
    )
  )
}

# Internal names for each common variable's Base and Compare versions after
# the join (.base_1, .compare_1, ...), so original names can never collide.
variable_pairs <- function(common) {
  list(
    common = common,
    base = paste0(".base_", seq_along(common)),
    compare = paste0(".compare_", seq_along(common))
  )
}

# The result holds only collected summaries and results, never references to
# backend tables. Each comparison stage adds its own named fields.
new_df_compare <- function(...) {
  structure(list(...), class = "df_compare")
}

#' Unequal values found by a comparison
#'
#' @param x A `df_compare` object.
#' @return A tibble with one row per Unequal value.
#' @export
differences <- function(x) {
  x$differences
}

check_id <- function(id, call = rlang::caller_env()) {
  if (!is.character(id) || length(id) == 0) {
    cli::cli_abort(
      "{.arg id} must be a character vector naming at least one ID variable.",
      call = call
    )
  }
}

check_id_present <- function(id, variables, dataset, call = rlang::caller_env()) {
  absent <- setdiff(id, variables)
  if (length(absent) > 0) {
    cli::cli_abort(
      paste0("ID variable{?s} {.var {absent}} not found in the ", dataset, " dataset."),
      call = call
    )
  }
}
