#' Compare two datasets the way PROC COMPARE does
#'
#' @param base The Base dataset: the reference the comparison reports against.
#' @param compare The Compare dataset, checked against `base`.
#' @param id Character vector of ID variables used to pair observations.
#' @return A `df_compare` object.
#' @export
df_compare <- function(base, compare, id) {
  check_id(id, colnames(base), "Base")
  check_id(id, colnames(compare), "Compare")
  common <- setdiff(intersect(colnames(base), colnames(compare)), id)
  matched <- match_observations(base, compare, id, common)
  diffs <- lapply(seq_along(common), function(i) unequal_values(matched, id, common[[i]], i))
  new_df_compare(
    differences = dplyr::bind_rows(empty_differences(base, id), diffs),
    id = id,
    compared = common,
    n_obs = c(base = count_obs(base), compare = count_obs(compare), matched = count_obs(matched))
  )
}

# Counts observations inside the backend; only the count reaches R.
count_obs <- function(data) {
  as.integer(dplyr::pull(dplyr::collect(dplyr::summarise(data, n = dplyr::n())), "n"))
}

# Pairs Base and Compare observations on their ID values. Common variables are
# renamed to positional names (.base_1, .compare_1, ...) so that original
# names can never collide with each other after the join.
match_observations <- function(base, compare, id, common) {
  base <- dplyr::select(base, dplyr::all_of(id), dplyr::all_of(stats::setNames(common, paste0(".base_", seq_along(common)))))
  compare <- dplyr::select(compare, dplyr::all_of(id), dplyr::all_of(stats::setNames(common, paste0(".compare_", seq_along(common)))))
  dplyr::inner_join(base, compare, by = id)
}

# Collects the Unequal values of the i-th common variable. The filter runs in
# the backend, so only unequal observations are brought into R.
unequal_values <- function(matched, id, variable, i) {
  b <- rlang::sym(paste0(".base_", i))
  c <- rlang::sym(paste0(".compare_", i))
  unequal <- rlang::expr(
    (is.na(!!b) != is.na(!!c)) | (!is.na(!!b) & !is.na(!!c) & !!b != !!c)
  )
  matched |>
    dplyr::filter(!!unequal) |>
    dplyr::select(dplyr::all_of(id), base = !!b, compare = !!c) |>
    dplyr::collect() |>
    dplyr::arrange(dplyr::across(dplyr::all_of(id))) |>
    dplyr::mutate(
      variable = variable,
      base = as.character(.data$base),
      compare = as.character(.data$compare),
      .after = dplyr::all_of(id)
    ) |>
    tibble::as_tibble()
}

# A zero-row differences tibble whose ID columns keep the Base types.
empty_differences <- function(base, id) {
  base |>
    dplyr::select(dplyr::all_of(id)) |>
    utils::head(0) |>
    dplyr::collect() |>
    tibble::as_tibble() |>
    dplyr::mutate(variable = character(), base = character(), compare = character())
}

new_df_compare <- function(differences, id, compared, n_obs) {
  structure(
    list(differences = differences, id = id, compared = compared, n_obs = n_obs),
    class = "df_compare"
  )
}

#' Unequal values found by a comparison
#'
#' @param x A `df_compare` object.
#' @return A tibble with one row per Unequal value.
#' @export
differences <- function(x) {
  x$differences
}

#' Return code of a comparison
#'
#' @param x A `df_compare` object.
#' @return An integer laid out as SAS's SYSINFO: 0 when the datasets are equal.
#' @export
return_code <- function(x) {
  if (nrow(x$differences) > 0) 4096L else 0L
}

check_id <- function(id, variables, dataset, call = rlang::caller_env()) {
  missing <- setdiff(id, variables)
  if (length(missing) > 0) {
    cli::cli_abort(
      paste0("ID variable{?s} {.var {missing}} not found in the ", dataset, " dataset."),
      call = call
    )
  }
}
