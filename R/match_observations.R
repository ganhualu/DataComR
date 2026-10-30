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
