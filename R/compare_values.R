COMPARISON_METHODS <- c("exact", "absolute", "relative", "percent")

# Validates the value comparison arguments of df_compare() and bundles them.
comparison_rules <- function(method, criterion, relative_delta,
                             call = rlang::caller_env()) {
  method <- rlang::arg_match0(method, COMPARISON_METHODS, error_call = call)
  check_number(criterion, "a single non-negative number", min = 0, call = call)
  check_number(
    relative_delta, "a single number between 0 and 1",
    min = 0, max = 1, call = call
  )
  list(method = method, criterion = criterion, relative_delta = relative_delta)
}

# SAS reads a negative CRITERION= as a multiple of machine precision; DataComR
# rejects it instead of silently changing its meaning.
check_number <- function(x, what, min, max = Inf, call = rlang::caller_env(),
                         arg = rlang::caller_arg(x)) {
  if (!is.numeric(x) || length(x) != 1 || is.na(x)) {
    cli::cli_abort(
      "{.arg {arg}} must be {what}, not {.obj_type_friendly {x}}.",
      call = call
    )
  }
  if (x < min || x > max) {
    cli::cli_abort("{.arg {arg}} must be {what}, not {x}.", call = call)
  }
}

# Compares every common variable of the matched observations and returns all
# Unequal values as one long tibble.
compare_values <- function(matched, base, id, pairs, rules) {
  unequal <- lapply(seq_along(pairs$common), function(i) {
    unequal_values(
      matched, id, pairs$common[[i]], pairs$base[[i]], pairs$compare[[i]],
      pairs$family[[i]], rules
    )
  })
  dplyr::bind_rows(empty_differences(base, id), unequal)
}

# Collects the Unequal values of one common variable. The filter runs in the
# backend, so only unequal observations are brought into R; sorting by ID
# variables then happens in R, independent of the backend's collation.
unequal_values <- function(matched, id, variable, base_var, compare_var, family, rules) {
  b <- rlang::sym(base_var)
  cmp <- rlang::sym(compare_var)
  in_memory <- is.data.frame(matched)
  is_unequal <- rlang::expr(
    (is.na(!!b) != is.na(!!cmp)) |
      (!is.na(!!b) & !is.na(!!cmp) & !!values_unequal(b, cmp, family, rules, in_memory))
  )
  unequal <- matched |>
    dplyr::filter(!!is_unequal) |>
    dplyr::select(dplyr::all_of(id), base = !!b, compare = !!cmp) |>
    dplyr::collect() |>
    dplyr::arrange(dplyr::across(dplyr::all_of(id)))
  numeric <- family == "numeric"
  # diff and pct_diff are computed on the collected Unequal values only.
  diff <- if (numeric) as.double(unequal$compare) - as.double(unequal$base) else NA_real_
  pct_diff <- if (numeric) 100 * diff / as.double(unequal$base) else NA_real_
  unequal |>
    dplyr::mutate(
      variable = variable,
      base = format_value(.data$base, numeric),
      compare = format_value(.data$compare, numeric),
      diff = diff,
      pct_diff = dplyr::if_else(is.finite(pct_diff), pct_diff, NA_real_),
      .after = dplyr::all_of(id)
    ) |>
    tibble::as_tibble()
}

# The test for two non-missing values of one Type family, as an expression
# the backend can evaluate. Only the numeric family uses the Comparison
# method; dates are compared exactly and datetimes as instants (the stored
# number of seconds, whatever the time zone).
values_unequal <- function(x, y, family, rules, in_memory) {
  if (family == "datetime" && in_memory) {
    # R-only: comparing POSIXct with different time zones warns, although it
    # already compares instants. Backends store instants and compare them
    # directly, and have no translation for unclass().
    return(rlang::expr(unclass(!!x) != unclass(!!y)))
  }
  switch(family,
    # One storage type for both sides, so integer, double and logical compare
    # by value.
    numeric = numeric_unequal(
      rlang::expr(as.numeric(!!x)), rlang::expr(as.numeric(!!y)), rules
    ),
    # Factors compare by label, whatever their levels.
    character = rlang::expr(as.character(!!x) != as.character(!!y)),
    rlang::expr(!!x != !!y)
  )
}

# SAS PROC COMPARE's test for two non-missing numeric values, x in Base and
# y in Compare, as an expression the backend can evaluate.
numeric_unequal <- function(x, y, rules) {
  criterion <- rules$criterion
  delta <- rules$relative_delta
  switch(rules$method,
    exact = rlang::expr(!!x != !!y),
    absolute = rlang::expr(abs(!!y - !!x) > !!criterion),
    # x = y = 0 is equal; the guard also keeps 0 / 0 out of the test.
    relative = rlang::expr(
      !(!!x == 0 & !!y == 0) &
        abs(!!y - !!x) / ((abs(!!x) + abs(!!y)) / 2 + !!delta) > !!criterion
    ),
    # Relative to the Base value; when that is 0, only y = 0 is equal.
    percent = rlang::expr(
      (!!x != 0 & 100 * abs(!!y - !!x) / abs(!!x) > !!criterion) |
        (!!x == 0 & !!y != 0)
    )
  )
}

# Shows a value as text without losing precision: doubles use the shortest
# representation (up to 17 significant digits) that reads back to the same
# number, so values that compare unequal never display identically. Other
# families (and factors) show as their labels.
format_value <- function(x, numeric) {
  if (!numeric || !is.double(x)) {
    return(as.character(x))
  }
  out <- formatC(x, digits = 15, format = "g")
  lossy <- !is.na(x)
  lossy[lossy] <- as.numeric(out[lossy]) != x[lossy]
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
    dplyr::mutate(
      variable = character(),
      base = character(),
      compare = character(),
      diff = double(),
      pct_diff = double()
    )
}
