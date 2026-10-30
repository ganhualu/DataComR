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
#' @param var Character vector of Base variables whose values are compared,
#'   as SAS's `VAR` statement; `NULL` (the default) compares every common
#'   variable. Each must be in both datasets, unless `with` names its Compare
#'   variable. `var` and `with` must not name ID variables, whose values
#'   are equal in every Matched observation by construction. See the Variable pairing
#'   section.
#' @param with Character vector of Compare variables, as SAS's `WITH`
#'   statement: the same length as `var`, each paired by position with the
#'   `var` variable it is compared with. Results report the Base name.
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
#' @param ignore_case If `FALSE` (the default), variable names are matched
#'   exactly, so `USUBJID` and `usubjid` are different variables. If `TRUE`,
#'   names that differ only in case are paired; see the Variable pairing
#'   section.
#' @return A `df_compare` object.
#'
#' @section Variable pairing:
#' A Base variable is paired with the Compare variable of the same name. Names
#' are case-sensitive by default, unlike in SAS, so that `a` and `A` are never
#' silently treated as one variable. With `ignore_case = TRUE`, names that
#' differ only in case are paired instead, and `id`, `var` and `with` may be
#' written in either dataset's case; results and the Listing always use the
#' Base names. It is an error when two names in one dataset differ only in
#' case, since the pairing would then be ambiguous.
#'
#' As with SAS's `VAR` statement, `var` restricts only the comparison of
#' values: Unequal values are reported for the `var` variables alone, while
#' the Variables Summary (variables in only one dataset, Conflicting types,
#' Attribute differences) still covers every variable, and so does the Return
#' code. A Base variable paired by `with` is not a variable in only one
#' dataset, and neither is its Compare variable; its Attribute differences are
#' reported under the Base name.
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
#' Special missings that a backend does not preserve (for example haven
#' tagged `NA`s in a duckdb table) are treated as absent for that dataset; for
#' attributes, see the Attribute differences section.
#'
#' @section Attribute differences:
#' As PROC COMPARE does, `df_compare()` compares metadata as well as values.
#' For each common variable and each `with` pair, ID variables included, the
#' `label`, `format.sas` and `width` attributes (as set by haven when reading
#' SAS files) are compared, and so is the data
#' frame's own `label` attribute (the dataset label). An attribute present on
#' only one side is an Attribute difference; one absent on both sides is
#' ignored. Attribute differences are shown in the Listing's Variables Summary
#' (dataset labels in its Dataset Summary) and set Return code bits 1 (dataset
#' label), 8 (format), 16 (width) and 32 (variable label). They are never
#' Unequal values: they don't appear in [differences()] and never set bit 4096.
#'
#' Attributes are R metadata, so they are only as complete as the backend
#' keeps them. Data frames (including tibbles read with haven) keep them.
#' Arrow data keeps the R attributes it was created with, stored in its
#' metadata; arrow data written outside R has none, so it is treated as having
#' no attributes. Lazy database tables, such as duckdb tables, carry no R
#' attributes at all: when either dataset is one, no attributes are compared
#' and no Attribute differences are reported, rather than reporting false
#' ones.
#' @export
df_compare <- function(base, compare, id, var = NULL, with = NULL,
                       method = "exact", criterion = 1e-5,
                       relative_delta = 0, ignore_trailing_blanks = TRUE,
                       ignore_case = FALSE) {
  check_id(id)
  # Attributes are read from the datasets as given, before one_backend() may
  # move one of them into another backend that drops R attributes.
  original <- list(base = base, compare = compare)
  inputs <- one_backend(base, compare)
  on.exit(inputs$cleanup(), add = TRUE)
  base <- inputs$base
  compare <- inputs$compare
  variables <- pair_variables(
    colnames(base), colnames(compare), id, var, with, ignore_case
  )
  # From here on, ID variables go by their Base names.
  id <- variables$id
  rules <- comparison_rules(method, criterion, relative_delta, ignore_trailing_blanks)

  not_id <- !variables$base %in% id
  types <- variable_types(
    base, compare, variables$base[not_id], variables$compare[not_id]
  )
  compared <- types[types$base_family == types$compare_family &
    types$variable %in% variables$compared, ]
  pairs <- variable_pairs(compared$variable, compared$compare_variable, compared$base_family)
  observations <- match_observations(base, compare, id, pairs, variables$compare_id)
  matched <- observations$matched
  warn_duplicate_ids(observations$duplicates)
  attribute_results <- compare_attributes(
    original$base, original$compare, variables$base, variables$compare
  )

  new_df_compare(
    differences = compare_values(matched, base, id, pairs, rules),
    unmatched = observations$unmatched,
    duplicates = observations$duplicates,
    conflicting_types = conflicting_types(types),
    type_differences = type_differences(types),
    id = id,
    compared = compared$variable,
    base_only = variables$base_only,
    compare_only = variables$compare_only,
    dataset_labels = attribute_results$dataset_labels,
    attribute_differences = attribute_results$attribute_differences,
    n_obs = c(
      base = count_obs(base),
      compare = count_obs(compare),
      matched = count_obs(matched)
    )
  )
}

# Internal names for each compared variable's Base and Compare versions after
# the join (.base_1, .compare_1, ...), so original names can never collide,
# with the Compare variable it is paired with and the Type family both
# versions share. `common` holds the Base names, which results report.
variable_pairs <- function(common, compare_source, family) {
  list(
    common = common,
    compare_source = compare_source,
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
