# Resolves which Compare variable each Base variable is paired with. A Base
# variable's partner is the Compare variable of the same name (ignoring case
# when `ignore_case` is TRUE); `with` gives a `var` variable a differently
# named partner instead. `id`, `var` and `with` are matched to the datasets'
# names the same way. Returns a list of
# - `id`, `compare_id`: the ID variables' names in Base and in Compare;
# - `base`, `compare`: the paired Base and Compare variable names, ID
#   variables included, in Base order; results report the Base names;
# - `compared`: the Base names of the paired variables whose values are
#   compared: the `var` variables, or every pair except the ID variables;
# - `base_only`, `compare_only`: variables paired with nothing.
pair_variables <- function(base_names, compare_names, id, var, with, ignore_case,
                           call = rlang::caller_env()) {
  if (!rlang::is_bool(ignore_case)) {
    cli::cli_abort(
      "{.arg ignore_case} must be {.code TRUE} or {.code FALSE}, not {.obj_type_friendly {ignore_case}}.",
      call = call
    )
  }
  check_var_with(var, with, call)
  key <- if (ignore_case) tolower else identity
  if (ignore_case) {
    check_no_case_collisions(base_names, "Base", call)
    check_no_case_collisions(compare_names, "Compare", call)
  }
  # A name as it is spelled in `variables`; left as given when absent there.
  in_dataset <- function(names, variables) {
    found <- variables[match(key(names), key(variables))]
    ifelse(is.na(found), names, found)
  }

  compare_id <- in_dataset(id, compare_names)
  id <- in_dataset(id, base_names)
  check_id_present(id, base_names, "Base", call)
  check_id_present(compare_id, compare_names, "Compare", call)

  partner <- rlang::set_names(
    compare_names[match(key(base_names), key(compare_names))],
    base_names
  )
  if (!is.null(var)) {
    var <- in_dataset(var, base_names)
    abort_absent(setdiff(var, base_names), "var", "Base", call)
    check_var_not_id(var, id, call)
    if (is.null(with)) {
      abort_absent(
        var[is.na(partner[var])], "var", "Compare", call,
        hint = c(i = "Use {.arg with} to pair a {.arg var} variable with a differently named Compare variable.")
      )
    } else {
      with <- in_dataset(with, compare_names)
      abort_absent(setdiff(with, compare_names), "with", "Compare", call)
      check_var_not_id(with, compare_id, call, arg = "with")
      partner[var] <- with
    }
  }

  paired <- !is.na(partner)
  base <- base_names[paired]
  list(
    id = id,
    compare_id = compare_id,
    base = base,
    compare = unname(partner[paired]),
    compared = if (is.null(var)) setdiff(base, id) else var,
    base_only = base_names[!paired],
    compare_only = setdiff(compare_names, partner)
  )
}

# With `ignore_case = TRUE`, two names in one dataset that differ only in case
# would make the pairing ambiguous.
check_no_case_collisions <- function(names, dataset, call) {
  groups <- split(names, tolower(names))
  groups <- groups[lengths(groups) > 1]
  if (length(groups) > 0) {
    colliding <- unlist(groups, use.names = FALSE)
    cli::cli_abort(
      c(
        paste0(
          "With {.code ignore_case = TRUE}, variable names in the ", dataset,
          " dataset must differ by more than case."
        ),
        x = "These names are the same ignoring case: {.var {colliding}}."
      ),
      call = call
    )
  }
}

# ID values are equal in every Matched observation by construction, so an ID
# variable in `var` could only ever be reported as equal.
check_var_not_id <- function(var, id, call, arg = "var") {
  id_in_var <- intersect(var, id)
  if (length(id_in_var) > 0) {
    cli::cli_abort(
      c(
        "{.arg {arg}} must not name ID variables, but names {.var {id_in_var}}.",
        i = "ID variables pair observations, so their values are never compared."
      ),
      call = call
    )
  }
}

abort_absent <- function(absent, arg, dataset, call, hint = NULL) {
  if (length(absent) > 0) {
    cli::cli_abort(
      c(
        paste0("{.arg {arg}} variable{?s} {.var {absent}} not found in the ", dataset, " dataset."),
        hint
      ),
      call = call
    )
  }
}

check_var_with <- function(var, with, call) {
  for (arg in c("var", "with")) {
    names <- if (arg == "var") var else with
    if (!is.null(names) && (!is.character(names) || length(names) == 0 || anyNA(names))) {
      cli::cli_abort(
        "{.arg {arg}} must be {.code NULL} or a character vector naming at least one variable, not {.obj_type_friendly {names}}.",
        call = call
      )
    }
  }
  repeated <- unique(var[duplicated(var)])
  if (length(repeated) > 0) {
    cli::cli_abort(
      "{.arg var} must name each Base variable once, but names {.var {repeated}} more than once.",
      call = call
    )
  }
  if (!is.null(with) && is.null(var)) {
    cli::cli_abort(
      "{.arg with} needs {.arg var}: each {.arg with} variable is paired with the {.arg var} variable in the same position.",
      call = call
    )
  }
  if (!is.null(with) && length(with) != length(var)) {
    cli::cli_abort(
      c(
        "{.arg var} and {.arg with} must name the same number of variables.",
        i = "{.arg var} names {length(var)} variable{?s}; {.arg with} names {length(with)}."
      ),
      call = call
    )
  }
}
