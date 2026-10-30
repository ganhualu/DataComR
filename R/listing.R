#' @export
print.df_compare <- function(x, ..., max_print = x$max_print) {
  cli::cat_rule("The COMPARE Procedure")
  cli::cat_line("Comparison of Base with Compare")
  cli::cat_line(listing_method(x$rules))
  listing_dataset_summary(x)
  listing_variables_summary(x)
  listing_observation_summary(x)
  listing_values_summary(x)
  listing_unequal_variables(x)
  listing_value_comparison_results(x, max_print)
  listing_return_code(x)
  invisible(x)
}

# Listing sections, in PROC COMPARE's order and with its wording. Each starts
# with a blank line; lines and listings with nothing to report are left out,
# as PROC COMPARE does.

listing_method <- function(rules) {
  method <- toupper(rules$method)
  if (rules$method == "exact") {
    return("(Method=EXACT)")
  }
  if (rules$method == "relative") {
    method <- paste0(method, "(", rules$relative_delta, ")")
  }
  paste0("(Method=", method, ", Criterion=", format(rules$criterion), ")")
}

listing_dataset_summary <- function(x) {
  labels <- x$dataset_labels
  listing_heading("Data Set Summary")
  listing_table(list(
    Dataset = c("Base", "Compare"),
    NVar = c(x$n_vars[["base"]], x$n_vars[["compare"]]),
    NObs = c(x$n_obs[["base"]], x$n_obs[["compare"]]),
    Label = ifelse(is.na(labels), "", labels)
  ), right = c("NVar", "NObs"))
}

listing_variables_summary <- function(x) {
  listing_heading("Variables Summary")
  listing_count("Number of Variables in Common", x$n_vars[["base"]] - length(x$base_only), always = TRUE)
  listing_count("Number of Variables in Base but not in Compare", length(x$base_only))
  listing_count("Number of Variables in Compare but not in Base", length(x$compare_only))
  listing_count("Number of Variables with Conflicting Types", nrow(x$conflicting_types))
  listing_count(
    "Number of Variables with Different Types in the Same Type Family",
    nrow(x$type_differences)
  )
  listing_count(
    "Number of Variables with Differing Attributes",
    length(unique(x$attribute_differences$variable))
  )
  if (!x$by_position) {
    listing_count("Number of ID Variables", length(x$id))
  }
  listing_count("Number of VAR Statement Variables", length(x$var))

  listing_names("Listing of Variables in Base but not in Compare", x$base_only)
  listing_names("Listing of Variables in Compare but not in Base", x$compare_only)
  listing_types("Listing of Variables with Conflicting Types", x$conflicting_types)
  listing_types(
    "Listing of Variables with Different Types in the Same Type Family",
    x$type_differences
  )
  listing_attribute_differences(x$attribute_differences)
}

listing_observation_summary <- function(x) {
  n_obs <- x$n_obs
  unmatched <- unmatched_rows(x)
  unequal_obs <- nrow(dplyr::distinct(differences(x)[x$id]))
  listing_heading("Observation Summary")
  matching <- if (x$by_position) {
    "Observations are matched by position."
  } else {
    paste0("Observations are matched on ID variables: ", paste(x$id, collapse = ", "), ".")
  }
  cli::cat_line("  ", matching)
  listing_count("Number of Observations in Common", n_obs[["matched"]], always = TRUE)
  listing_count("Number of Observations in Base but not in Compare", sum(unmatched$dataset == "Base"))
  listing_count("Number of Observations in Compare but not in Base", sum(unmatched$dataset == "Compare"))
  listing_count("Number of Duplicate IDs (not compared)", nrow(x$duplicates))
  listing_count("Total Number of Observations Read from Base", n_obs[["base"]], always = TRUE)
  listing_count("Total Number of Observations Read from Compare", n_obs[["compare"]], always = TRUE)
  cli::cat_line()
  listing_count("Number of Observations with Some Compared Variables Unequal", unequal_obs, always = TRUE)
  listing_count(
    "Number of Observations with All Compared Variables Equal",
    n_obs[["matched"]] - unequal_obs,
    always = TRUE
  )
  listing_duplicate_ids(x$duplicates, x$id)
}

listing_values_summary <- function(x) {
  unequal <- differences(x)
  n_unequal_vars <- length(unique(unequal$variable))
  listing_heading("Values Comparison Summary")
  listing_count(
    "Number of Variables Compared with All Observations Equal",
    length(x$compared) - n_unequal_vars,
    always = TRUE
  )
  listing_count("Number of Variables Compared with Some Observations Unequal", n_unequal_vars, always = TRUE)
  listing_count("Total Number of Values which Compare Unequal", nrow(unequal), always = TRUE)
  listing_count("Total Number of Values not EXACTLY Equal", x$not_exactly_equal)
  if (any(!is.na(unequal$diff))) {
    cli::cat_line("  Maximum Difference: ", format_number(max(abs(unequal$diff), na.rm = TRUE)), ".")
  }
  if (nrow(unequal) == 0) {
    cli::cat_line()
    if (x$not_exactly_equal == 0) {
      cli::cat_line("NOTE: No unequal values were found. All values compared are exactly equal.")
    } else {
      cli::cat_line(
        "NOTE: All values compared are within the equality criterion used. However, ",
        x$not_exactly_equal, " of the values compared are not exactly equal."
      )
    }
  }
}

listing_unequal_variables <- function(x) {
  unequal <- differences(x)
  if (nrow(unequal) == 0) {
    return(invisible())
  }
  variables <- unique(unequal$variable)
  max_dif <- vapply(variables, function(v) {
    d <- unequal$diff[unequal$variable == v]
    if (all(is.na(d))) "" else format_number(max(abs(d), na.rm = TRUE))
  }, character(1))
  listing_heading("Variables with Unequal Values")
  listing_table(list(
    Variable = variables,
    Type = unname(x$families[variables]),
    Ndif = as.vector(table(factor(unequal$variable, levels = variables))),
    MaxDif = unname(max_dif)
  ), right = c("Ndif", "MaxDif"))
}

# One table per variable with Unequal values: the ID values (or observation
# number), Base and Compare values, and for numeric variables Diff. and
# % Diff, as PROC COMPARE prints them. At most `max_print` rows per variable.
listing_value_comparison_results <- function(x, max_print) {
  unequal <- differences(x)
  if (nrow(unequal) == 0) {
    return(invisible())
  }
  listing_heading("Value Comparison Results for Variables")
  for (variable in unique(unequal$variable)) {
    if (variable != unequal$variable[[1]]) {
      cli::cat_line()
    }
    rows <- unequal[unequal$variable == variable, ]
    shown <- utils::head(rows, max_print)
    numeric <- x$families[[variable]] == "numeric"
    value_columns <- list(shown$base, shown$compare)
    headers <- list(c("Base", variable), c("Compare", x$compare_names[[variable]]))
    if (numeric) {
      value_columns <- c(value_columns, list(format_number(shown$diff), format_number(shown$pct_diff)))
      headers <- c(headers, list(c("", "Diff."), c("", "% Diff")))
    }
    id_columns <- lapply(x$id, function(v) format_value(shown[[v]], numeric = is.numeric(shown[[v]])))
    listing_value_table(id_columns, x$id, value_columns, headers, right = numeric)
    if (nrow(rows) > max_print) {
      cli::cat_line(
        "NOTE: The MAXPRINT=", max_print, " printing limit has been reached for the variable ",
        variable, ". No more values will be printed for this comparison."
      )
    }
  }
}

listing_return_code <- function(x) {
  cli::cat_line()
  cli::cat_line("Return code: ", return_code(x))
}

# Building blocks -------------------------------------------------------------

listing_heading <- function(heading) {
  cli::cat_line()
  cli::cat_line(heading)
  cli::cat_line()
}

# A "Number of ...: n." line, left out when n is 0 unless `always`.
listing_count <- function(label, n, always = FALSE) {
  if (always || n > 0) {
    cli::cat_line("  ", label, ": ", n, ".")
  }
}

listing_names <- function(heading, variables) {
  if (length(variables) == 0) {
    return(invisible())
  }
  cli::cat_line()
  cli::cat_line("  ", heading)
  cli::cat_line("    ", variables)
}

listing_types <- function(heading, types) {
  if (is.null(types) || nrow(types) == 0) {
    return(invisible())
  }
  cli::cat_line()
  cli::cat_line("  ", heading)
  listing_table(list(
    Variable = types$variable,
    Base = types$base_type,
    Compare = types$compare_type
  ))
}

listing_attribute_differences <- function(attribute_differences) {
  if (nrow(attribute_differences) == 0) {
    return(invisible())
  }
  cli::cat_line()
  cli::cat_line("  Listing of Common Variables with Differing Attributes")
  listing_table(list(
    Variable = attribute_differences$variable,
    Attribute = attribute_differences$attribute,
    Base = absent_as_none(attribute_differences$base),
    Compare = absent_as_none(attribute_differences$compare)
  ))
}

# One line per Duplicate ID: the dataset, its ID values and how many
# observations share them.
listing_duplicate_ids <- function(duplicates, id) {
  if (nrow(duplicates) == 0) {
    return(invisible())
  }
  cli::cat_line()
  cli::cat_line("  Listing of Duplicate IDs")
  columns <- c(
    list(Dataset = duplicates$dataset),
    rlang::set_names(
      lapply(id, function(v) format_value(duplicates[[v]], numeric = is.numeric(duplicates[[v]]))),
      id
    ),
    list(Observations = duplicates$.n)
  )
  listing_table(columns, right = "Observations")
}

# Prints named columns as a table under their names; `right` names the
# columns to right-align.
listing_table <- function(columns, right = character()) {
  padded <- Map(function(name, values) {
    format(c(name, as.character(values)), justify = if (name %in% right) "right" else "left")
  }, names(columns), columns)
  rows <- do.call(paste, c(unname(padded), sep = "  "))
  cli::cat_line("    ", trimws(rows, which = "right"))
}

# A PROC COMPARE value table: ID columns, a `||` separator, then value
# columns under two-line headers, framed by rules.
listing_value_table <- function(id_columns, id_names, value_columns, headers, right) {
  width <- function(header, values) max(9, nchar(c(header, values)), na.rm = TRUE)
  id_widths <- unlist(Map(width, id_names, id_columns))
  value_widths <- unlist(Map(width, headers, value_columns))
  pad <- function(text, w, right) formatC(text, width = if (right) w else -w)
  id_part <- function(cells) paste(unlist(Map(pad, cells, id_widths, FALSE)), collapse = "  ")
  value_part <- function(cells, right) paste(unlist(Map(pad, cells, value_widths, right)), collapse = "  ")
  line <- function(ids, values, right = TRUE) {
    trimws(paste0("  ", id_part(ids), "  ||  ", value_part(values, right)), which = "right")
  }
  blank_ids <- rep("", length(id_widths))
  rows <- vapply(seq_along(value_columns[[1]]), function(i) {
    ids <- vapply(id_columns, `[[`, character(1), i)
    values <- vapply(value_columns, function(col) {
      v <- col[[i]]
      if (is.na(v)) "." else v
    }, character(1))
    line(ids, values, right)
  }, character(1))
  header_1 <- line(blank_ids, vapply(headers, `[[`, character(1), 1))
  header_2 <- line(id_names, vapply(headers, `[[`, character(1), 2))
  underline <- line(strrep("_", id_widths), strrep("_", value_widths))
  rule <- paste0("  ", strrep("_", max(nchar(c(header_1, header_2, underline, rows))) - 2))
  cli::cat_line(c(rule, header_1, header_2, underline, line(blank_ids, rep("", length(value_widths))), rows, rule))
}

# Diff., % Diff and MaxDif: six significant digits, as a summary rather than
# a full-precision value; missing shown as SAS's ".".
format_number <- function(x) {
  out <- formatC(x, digits = 6, format = "g")
  out[is.na(x)] <- "."
  trimws(out)
}

absent_as_none <- function(x) {
  ifelse(is.na(x), "(none)", x)
}
