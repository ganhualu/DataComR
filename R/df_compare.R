#' Compare two datasets the way PROC COMPARE does
#'
#' @param base The Base dataset: the reference the comparison reports against.
#' @param compare The Compare dataset, checked against `base`.
#' @param id Character vector of ID variables used to pair observations.
#' @param method The Comparison method for numeric variables: `"exact"`,
#'   `"absolute"`, `"relative"` or `"percent"`, as SAS's `METHOD=`.
#' @param criterion The Criterion the method tests differences against, as
#'   SAS's `CRITERION=`.
#' @param relative_delta The constant δ that `method = "relative"` adds to the
#'   denominator, as in SAS's `METHOD=RELATIVE(δ)`: a number between 0 and 1,
#'   0 by default as in SAS.
#' @return A `df_compare` object.
#' @export
df_compare <- function(base, compare, id, method = "exact", criterion = 1e-5,
                       relative_delta = 0) {
  check_id(id)
  check_id_present(id, colnames(base), "Base")
  check_id_present(id, colnames(compare), "Compare")
  rules <- comparison_rules(method, criterion, relative_delta)

  common <- setdiff(intersect(colnames(base), colnames(compare)), id)
  types <- variable_types(base, compare, common)
  pairs <- variable_pairs(common, types$base_family)
  matched <- match_observations(base, compare, id, pairs)

  new_df_compare(
    differences = compare_values(matched, base, id, pairs, rules),
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
# the join (.base_1, .compare_1, ...), so original names can never collide,
# with the Type family both versions share.
variable_pairs <- function(common, family) {
  list(
    common = common,
    base = paste0(".base_", seq_along(common)),
    compare = paste0(".compare_", seq_along(common)),
    family = family
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
