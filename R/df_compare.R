#' Compare two datasets the way PROC COMPARE does
#'
#' @param base The Base dataset: the reference the comparison reports against.
#' @param compare The Compare dataset, checked against `base`.
#' @param id Character vector of ID variables used to pair observations.
#' @return A `df_compare` object.
#' @export
df_compare <- function(base, compare, id) {
  check_id(id)
  check_id_present(id, colnames(base), "Base")
  check_id_present(id, colnames(compare), "Compare")

  common <- setdiff(intersect(colnames(base), colnames(compare)), id)
  pairs <- variable_pairs(common)
  observations <- match_observations(base, compare, id, pairs)
  matched <- observations$matched
  warn_duplicate_ids(observations$duplicates)

  new_df_compare(
    differences = compare_values(matched, base, id, pairs),
    unmatched = observations$unmatched,
    duplicates = observations$duplicates,
    id = id,
    compared = common,
    base_only = setdiff(colnames(base), colnames(compare)),
    compare_only = setdiff(colnames(compare), colnames(base)),
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

#' Unmatched observations found by a comparison
#'
#' @param x A `df_compare` object.
#' @return A tibble with the ID variables of each Unmatched observation and a
#'   `dataset` column, `"Base"` or `"Compare"`, naming the only dataset it is
#'   in. Sorted by `dataset`, then by ID variables. ID values that are a
#'   Duplicate ID in either dataset are never Unmatched observations; the
#'   Listing reports them as Duplicate IDs instead.
#' @export
unmatched_rows <- function(x) {
  x$unmatched
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
