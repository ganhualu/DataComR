# Compares every common variable of the matched observations and returns all
# Unequal values as one long tibble.
compare_values <- function(matched, base, id, pairs) {
  unequal <- lapply(seq_along(pairs$common), function(i) {
    unequal_values(matched, id, pairs$common[[i]], pairs$base[[i]], pairs$compare[[i]])
  })
  dplyr::bind_rows(empty_differences(base, id), unequal)
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
