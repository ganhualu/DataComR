# Pairs Base and Compare observations on their ID values. Returns the
# Matched observations (still in the backend), the collected Unmatched
# observations and the collected Duplicate IDs. An ID value that is a
# Duplicate ID in either dataset is set aside in both before pairing, so it
# is neither a Matched nor an Unmatched observation.
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
  base_dups <- duplicate_ids(base, id)
  compare_dups <- duplicate_ids(compare, id)
  base <- exclude_ids(base, list(base_dups, compare_dups), id)
  compare <- exclude_ids(compare, list(base_dups, compare_dups), id)
  list(
    matched = dplyr::inner_join(base, compare, by = id),
    duplicates = dplyr::bind_rows(
      collect_duplicate_ids(base_dups, id, "Base"),
      collect_duplicate_ids(compare_dups, id, "Compare")
    ),
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

# ID values shared by more than one Observation, with how many share them
# (`.n`). Stays in the backend.
duplicate_ids <- function(data, id) {
  data |>
    dplyr::group_by(!!!rlang::syms(id)) |>
    dplyr::summarise(.n = dplyr::n(), .groups = "drop") |>
    dplyr::filter(.data$.n > 1)
}

exclude_ids <- function(data, excluded, id) {
  for (ids in excluded) {
    data <- dplyr::anti_join(data, dplyr::select(ids, dplyr::all_of(id)), by = id)
  }
  data
}

collect_duplicate_ids <- function(dups, id, dataset) {
  dups |>
    dplyr::collect() |>
    tibble::as_tibble() |>
    dplyr::arrange(dplyr::across(dplyr::all_of(id))) |>
    dplyr::mutate(dataset = dataset, .n = as.integer(.data$.n)) |>
    dplyr::relocate(".n", .after = "dataset")
}

warn_duplicate_ids <- function(duplicates, call = rlang::caller_env()) {
  if (nrow(duplicates) == 0) {
    return(invisible())
  }
  counts <- table(factor(duplicates$dataset, levels = c("Base", "Compare")))
  counts <- counts[counts > 0]
  cli::cli_warn(
    c(
      "Duplicate IDs found; their observations are not paired or compared.",
      rlang::set_names(
        paste0(names(counts), " dataset: ", counts, " Duplicate ID", ifelse(counts > 1, "s", ""), "."),
        rep("*", length(counts))
      )
    ),
    call = call
  )
}

# Counts observations inside the backend; only the count reaches R.
count_obs <- function(data) {
  counted <- dplyr::collect(dplyr::summarise(data, n = dplyr::n()))
  as.integer(dplyr::pull(counted, "n"))
}
