# Pairs Base and Compare observations on their ID values. Returns the
# Matched observations (still in the backend) and the collected Unmatched
# observations.
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
  list(
    matched = dplyr::inner_join(base, compare, by = id),
    unmatched = dplyr::bind_rows(
      unmatched_ids(base, compare, id, "Base"),
      unmatched_ids(compare, base, id, "Compare")
    )
  )
}

# ID values of `data` with no Observation in `other`, collected and sorted in
# R so the order never depends on the backend.
unmatched_ids <- function(data, other, id, dataset) {
  data |>
    dplyr::anti_join(dplyr::select(other, dplyr::all_of(id)), by = id) |>
    dplyr::select(dplyr::all_of(id)) |>
    dplyr::collect() |>
    tibble::as_tibble() |>
    dplyr::arrange(dplyr::across(dplyr::all_of(id))) |>
    dplyr::mutate(dataset = dataset)
}

# Counts observations inside the backend; only the count reaches R.
count_obs <- function(data) {
  counted <- dplyr::collect(dplyr::summarise(data, n = dplyr::n()))
  as.integer(dplyr::pull(counted, "n"))
}
