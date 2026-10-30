COMPARISON_METHODS <- c("exact", "absolute", "relative", "percent")

# Validates the value comparison arguments of df_compare() and bundles them.
comparison_rules <- function(method, criterion, relative_delta,
                             ignore_trailing_blanks, call = rlang::caller_env()) {
  method <- rlang::arg_match0(method, COMPARISON_METHODS, error_call = call)
  check_number(criterion, "a single non-negative number", min = 0, call = call)
  check_number(
    relative_delta, "a single number between 0 and 1",
    min = 0, max = 1, call = call
  )
  if (!rlang::is_bool(ignore_trailing_blanks)) {
    cli::cli_abort(
      "{.arg ignore_trailing_blanks} must be {.code TRUE} or {.code FALSE}, not {.obj_type_friendly {ignore_trailing_blanks}}.",
      call = call
    )
  }
  list(
    method = method,
    criterion = criterion,
    relative_delta = relative_delta,
    ignore_trailing_blanks = ignore_trailing_blanks
  )
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

# Compares every common variable of the matched observations. Returns all
# Unequal values as one long tibble (`differences`) and the number of values
# judged equal under the Comparison method that are not exactly equal
# (`not_exactly_equal`, always 0 for the exact method).
compare_values <- function(matched, base, id, pairs, rules) {
  results <- lapply(seq_along(pairs$common), function(i) {
    unequal_values(
      matched, id, pairs$common[[i]], pairs$base[[i]], pairs$compare[[i]],
      pairs$family[[i]], rules
    )
  })
  list(
    differences = dplyr::bind_rows(
      empty_differences(base, id),
      lapply(results, `[[`, "unequal")
    ),
    not_exactly_equal = sum(vapply(results, `[[`, integer(1), "not_exactly_equal"))
  )
}

# Collects the Unequal values of one common variable. The filter runs in the
# backend, so only unequal observations are brought into R; sorting by ID
# variables then happens in R, independent of the backend's collation.
unequal_values <- function(matched, id, variable, base_var, compare_var, family, rules) {
  b <- rlang::sym(base_var)
  cmp <- rlang::sym(compare_var)
  in_memory <- is.data.frame(matched)
  lazy <- inherits(matched, "tbl_lazy")
  b_missing <- is_missing(b, family, lazy)
  cmp_missing <- is_missing(cmp, family, lazy)
  # Missing equals missing; missing against non-missing is unequal.
  is_unequal <- rlang::expr(
    (!!b_missing != !!cmp_missing) |
      (!(!!b_missing) & !(!!cmp_missing) &
        !!values_unequal(b, cmp, family, rules, in_memory, lazy))
  )
  if (family == "numeric" && in_memory) {
    is_unequal <- rlang::expr(
      !!is_unequal | (!!b_missing & !!cmp_missing & (!!na_tags_differ)(!!b, !!cmp))
    )
  }
  not_exactly_equal <- count_not_exactly_equal(
    matched, b, cmp, b_missing, cmp_missing, is_unequal, family, rules
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
  unequal <- unequal |>
    dplyr::mutate(
      variable = variable,
      base = format_value(.data$base, numeric),
      compare = format_value(.data$compare, numeric),
      diff = diff,
      pct_diff = dplyr::if_else(is.finite(pct_diff), pct_diff, NA_real_),
      .after = dplyr::all_of(id)
    ) |>
    tibble::as_tibble()
  list(unequal = unequal, not_exactly_equal = not_exactly_equal)
}

# Values of a numeric variable judged equal by a non-exact Comparison method
# although they differ, as SAS reports under "Total Number of Values not
# EXACTLY Equal". Counted in the backend; only the count reaches R.
count_not_exactly_equal <- function(matched, b, cmp, b_missing, cmp_missing,
                                    is_unequal, family, rules) {
  if (family != "numeric" || rules$method == "exact") {
    return(0L)
  }
  counted <- matched |>
    dplyr::filter(
      !(!!b_missing) & !(!!cmp_missing) & !(!!is_unequal) &
        as.numeric(!!b) != as.numeric(!!cmp)
    ) |>
    dplyr::summarise(n = dplyr::n()) |>
    dplyr::collect()
  as.integer(dplyr::pull(counted, "n"))
}

# Whether a value is missing, with NaN counted as missing. R and arrow's
# is.na() already include NaN; in duckdb NaN is a value distinct from NULL,
# so lazy tables also test it with duckdb's isnan(), passed through as SQL.
# isnan(NULL) is NULL, which coalesce() turns into missing; a single call
# also keeps the SQL free of operator-precedence surprises.
is_missing <- function(x, family, lazy) {
  if (family == "numeric" && lazy) {
    # Built with call2(): these are SQL names, not R functions.
    rlang::call2("coalesce", rlang::call2("isnan", rlang::expr(as.numeric(!!x))), TRUE)
  } else {
    rlang::expr(is.na(!!x))
  }
}

# The test for two non-missing values of one Type family, as an expression
# the backend can evaluate. Only the numeric family uses the Comparison
# method; dates are compared exactly and datetimes as instants (the stored
# number of seconds, whatever the time zone).
values_unequal <- function(x, y, family, rules, in_memory, lazy) {
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
    character = rlang::expr(
      !!character_label(x, rules, lazy) != !!character_label(y, rules, lazy)
    ),
    rlang::expr(!!x != !!y)
  )
}

# The text a character-family value is compared by: factors by label,
# whatever their levels, and without trailing blanks (spaces) unless asked.
# Leading blanks are kept. Base R's sub() runs in R and arrow; dbplyr has no
# sub() translation for duckdb but translates stringr's str_remove() (to
# regexp_replace) without needing stringr installed.
character_label <- function(x, rules, lazy) {
  label <- rlang::expr(as.character(!!x))
  if (rules$ignore_trailing_blanks) {
    label <- if (lazy) {
      rlang::call2("str_remove", label, " +$")
    } else {
      rlang::expr(sub(" +$", "", !!label))
    }
  }
  label
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

# R-only, so applied to in-memory data alone: special missings (SAS .A-.Z,
# read by haven as tagged NAs) are equal only with the same letter, and a
# plain NA or NaN carries no letter. The tag lives in the payload bits of a
# double NA, which no backend translation can read and arrow and duckdb do
# not keep. Tagged NAs exist only where haven made them, so without haven
# there is nothing to tell apart.
na_tags_differ <- function(x, y) {
  if (!is.double(x) || !is.double(y) || !rlang::is_installed("haven")) {
    return(rep(FALSE, length(x)))
  }
  na_letter(x) != na_letter(y)
}

# The letter of each tagged NA, "" for any other value.
na_letter <- function(x) {
  tag <- haven::na_tag(x)
  tag[is.na(tag)] <- ""
  tag
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
  if (rlang::is_installed("haven")) {
    tagged <- na_letter(x) != ""
    out[tagged] <- paste0("NA(", na_letter(x)[tagged], ")")
  }
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
