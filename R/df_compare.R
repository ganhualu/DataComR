#' Compare two datasets the way PROC COMPARE does
#'
#' Each common variable belongs to a Type family: numeric (integer, double,
#' logical), character (character, factor compared by labels), date or
#' datetime (compared as instants, whatever the time zone). Variables of
#' different families are Conflicting types and their values are not
#' compared. The Comparison method and Criterion apply to the numeric family
#' only; other families are compared exactly.
#'
#' Two missing values are equal and `NaN` counts as missing. Special missings
#' (haven's tagged NAs, SAS's `.A` to `.Z`) are equal only with the same
#' letter; this rule needs in-memory data frames, since arrow and duckdb do
#' not keep the tags.
#'
#' @param base The Base dataset: the reference the comparison reports against.
#'   A data frame (including tibbles), an arrow Table or Dataset, or a duckdb
#'   table (a dbplyr lazy table on a duckdb connection).
#' @param compare The Compare dataset, checked against `base`. Any of the
#'   types accepted for `base`, in any combination with it.
#' @param id Character vector of ID variables used to pair observations.
#' @param method The Comparison method for numeric variables: `"exact"`,
#'   `"absolute"`, `"relative"` or `"percent"`, as SAS's `METHOD=`.
#' @param criterion The Criterion the method tests differences against, as
#'   SAS's `CRITERION=`.
#' @param relative_delta The constant δ that `method = "relative"` adds to the
#'   denominator, as in SAS's `METHOD=RELATIVE(δ)`: a number between 0 and 1,
#'   0 by default as in SAS.
#' @param ignore_trailing_blanks If `TRUE` (the default), character values
#'   that differ only in trailing blanks are equal, as in SAS. Leading blanks
#'   always count.
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
df_compare <- function(base, compare, id, method = "exact", criterion = 1e-5,
                       relative_delta = 0, ignore_trailing_blanks = TRUE) {
  check_id(id)
  inputs <- one_backend(base, compare)
  on.exit(inputs$cleanup(), add = TRUE)
  base <- inputs$base
  compare <- inputs$compare
  check_id_present(id, colnames(base), "Base")
  check_id_present(id, colnames(compare), "Compare")
  rules <- comparison_rules(method, criterion, relative_delta, ignore_trailing_blanks)

  common <- setdiff(intersect(colnames(base), colnames(compare)), id)
  types <- variable_types(base, compare, common)
  compared <- types[types$base_family == types$compare_family, ]
  pairs <- variable_pairs(compared$variable, compared$base_family)
  matched <- match_observations(base, compare, id, pairs)

  new_df_compare(
    differences = compare_values(matched, base, id, pairs, rules),
    conflicting_types = conflicting_types(types),
    type_differences = type_differences(types),
    id = id,
    compared = compared$variable,
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
#' @return A tibble with one row per Unequal value: the ID variables,
#'   `variable`, the `base` and `compare` values as text, and for numeric
#'   variables `diff` (Compare minus Base) and `pct_diff` (`100 * diff / base`,
#'   missing when the Base value is 0). `diff` and `pct_diff` are missing for
#'   the other Type families.
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
