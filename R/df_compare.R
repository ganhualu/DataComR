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
  matched <- match_observations(base, compare, id, pairs)
  unequal <- lapply(seq_along(common), function(i) {
    unequal_values(matched, id, pairs$common[[i]], pairs$base[[i]], pairs$compare[[i]])
  })

  new_df_compare(
    differences = dplyr::bind_rows(empty_differences(base, id), unequal),
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

# Pairs Base and Compare observations on their ID values.
match_observations <- function(base, compare, id, pairs) {
  base <- dplyr::select(
    base,
    dplyr::all_of(id),
    !!!rlang::set_names(rlang::syms(pairs$common), pairs$base)
  )
  compare <- dplyr::select(
    compare,
    dplyr::all_of(id),
    !!!rlang::set_names(rlang::syms(pairs$common), pairs$compare)
  )
  dplyr::inner_join(base, compare, by = id)
}

# Counts observations inside the backend; only the count reaches R.
count_obs <- function(data) {
  counted <- dplyr::collect(dplyr::summarise(data, n = dplyr::n()))
  as.integer(dplyr::pull(counted, "n"))
}

# Collects the Unequal values of one common variable. The filter runs in the
# backend, so only unequal observations are brought into R; sorting by ID
# variables then happens in R, independent of the backend's collation.
unequal_values <- function(matched, id, variable, base_var, compare_var) {
  b <- rlang::sym(base_var)
  cmp <- rlang::sym(compare_var)
  is_unequal <- rlang::expr(
    (is.na(!!b) != is.na(!!cmp)) | (!is.na(!!b) & !is.na(!!cmp) & !!b != !!cmp)
  )
  matched |>
    dplyr::filter(!!is_unequal) |>
    dplyr::select(dplyr::all_of(id), base = !!b, compare = !!cmp) |>
    dplyr::collect() |>
    dplyr::arrange(dplyr::across(dplyr::all_of(id))) |>
    dplyr::mutate(
      variable = variable,
      base = format_value(.data$base),
      compare = format_value(.data$compare),
      .after = dplyr::all_of(id)
    ) |>
    tibble::as_tibble()
}

# Shows a value as text without losing precision: doubles use the shortest
# representation (up to 17 significant digits) that reads back to the same
# number, so values that compare unequal never display identically.
format_value <- function(x) {
  if (!is.double(x)) {
    return(as.character(x))
  }
  out <- formatC(x, digits = 15, format = "g")
  lossy <- !is.na(x) & as.numeric(out) != x
  out[lossy] <- formatC(x[lossy], digits = 17, format = "g")
  out[is.na(x)] <- NA_character_
  trimws(out)
}

# A zero-row differences tibble whose ID variables keep the Base types.
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

# SYSINFO bit set when at least one Unequal value is found.
RC_UNEQUAL_VALUE <- 4096L

#' Return code of a comparison
#'
#' @param x A `df_compare` object.
#' @return An integer laid out as SAS's SYSINFO: 0 when the datasets are equal.
#' @export
return_code <- function(x) {
  if (nrow(differences(x)) > 0) RC_UNEQUAL_VALUE else 0L
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
