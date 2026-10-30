# the attributes of a with pair are compared and reported by the Base name [data_frame]

    Code
      res
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 1
        Variables with Attribute differences: 1
      
        Attribute differences
          Variable  Attribute  Base       Compare
          ady       label      Study Day  Analysis Day
      
      Observation Summary
        Observations in Base:    2
        Observations in Compare: 2
        Matched on usubjid: 2
      
      Values Summary
        Variables with Unequal values: 0
        Total Unequal values:          0
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 32

# the attributes of a with pair are compared and reported by the Base name [arrow]

    Code
      res
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 1
        Variables with Attribute differences: 1
      
        Attribute differences
          Variable  Attribute  Base       Compare
          ady       label      Study Day  Analysis Day
      
      Observation Summary
        Observations in Base:    2
        Observations in Compare: 2
        Matched on usubjid: 2
      
      Values Summary
        Variables with Unequal values: 0
        Total Unequal values:          0
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 32

# var still reports variables in only one dataset [data_frame]

    Code
      res
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 1
        Variables in Base but not in Compare: 1 (base_extra)
        Variables in Compare but not in Base: 1 (compare_extra)
      
      Observation Summary
        Observations in Base:    2
        Observations in Compare: 2
        Matched on usubjid: 2
      
      Values Summary
        Variables with Unequal values: 0
        Total Unequal values:          0
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 3072

# var still reports variables in only one dataset [arrow]

    Code
      res
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 1
        Variables in Base but not in Compare: 1 (base_extra)
        Variables in Compare but not in Base: 1 (compare_extra)
      
      Observation Summary
        Observations in Base:    2
        Observations in Compare: 2
        Matched on usubjid: 2
      
      Values Summary
        Variables with Unequal values: 0
        Total Unequal values:          0
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 3072

# var still reports variables in only one dataset [duckdb]

    Code
      res
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 1
        Variables in Base but not in Compare: 1 (base_extra)
        Variables in Compare but not in Base: 1 (compare_extra)
      
      Observation Summary
        Observations in Base:    2
        Observations in Compare: 2
        Matched on usubjid: 2
      
      Values Summary
        Variables with Unequal values: 0
        Total Unequal values:          0
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 3072

# with without var is an error [data_frame]

    Code
      df_compare(as_backend(pairing_base), as_backend(pairing_base), id = "usubjid",
      with = "aval")
    Condition
      Error in `df_compare()`:
      ! `with` needs `var`: each `with` variable is paired with the `var` variable in the same position.

# with without var is an error [arrow]

    Code
      df_compare(as_backend(pairing_base), as_backend(pairing_base), id = "usubjid",
      with = "aval")
    Condition
      Error in `df_compare()`:
      ! `with` needs `var`: each `with` variable is paired with the `var` variable in the same position.

# with without var is an error [duckdb]

    Code
      df_compare(as_backend(pairing_base), as_backend(pairing_base), id = "usubjid",
      with = "aval")
    Condition
      Error in `df_compare()`:
      ! `with` needs `var`: each `with` variable is paired with the `var` variable in the same position.

# var and with of different lengths are an error [data_frame]

    Code
      df_compare(as_backend(pairing_base), as_backend(pairing_base), id = "usubjid",
      var = c("aval", "ady"), with = "aval")
    Condition
      Error in `df_compare()`:
      ! `var` and `with` must name the same number of variables.
      i `var` names 2 variables; `with` names 1.

# var and with of different lengths are an error [arrow]

    Code
      df_compare(as_backend(pairing_base), as_backend(pairing_base), id = "usubjid",
      var = c("aval", "ady"), with = "aval")
    Condition
      Error in `df_compare()`:
      ! `var` and `with` must name the same number of variables.
      i `var` names 2 variables; `with` names 1.

# var and with of different lengths are an error [duckdb]

    Code
      df_compare(as_backend(pairing_base), as_backend(pairing_base), id = "usubjid",
      var = c("aval", "ady"), with = "aval")
    Condition
      Error in `df_compare()`:
      ! `var` and `with` must name the same number of variables.
      i `var` names 2 variables; `with` names 1.

# var and with naming variables not in their dataset are an error [data_frame]

    Code
      df_compare(as_backend(pairing_base), as_backend(compare), id = "usubjid", var = c(
        "aval", "chg"))
    Condition
      Error in `df_compare()`:
      ! `var` variable `chg` not found in the Base dataset.
    Code
      df_compare(as_backend(pairing_base), as_backend(compare), id = "usubjid", var = c(
        "aval", "ady"))
    Condition
      Error in `df_compare()`:
      ! `var` variable `ady` not found in the Compare dataset.
      i Use `with` to pair a `var` variable with a differently named Compare variable.
    Code
      df_compare(as_backend(pairing_base), as_backend(compare), id = "usubjid", var = c(
        "aval", "ady"), with = c("aval", "study_day"))
    Condition
      Error in `df_compare()`:
      ! `with` variable `study_day` not found in the Compare dataset.

# var and with naming variables not in their dataset are an error [arrow]

    Code
      df_compare(as_backend(pairing_base), as_backend(compare), id = "usubjid", var = c(
        "aval", "chg"))
    Condition
      Error in `df_compare()`:
      ! `var` variable `chg` not found in the Base dataset.
    Code
      df_compare(as_backend(pairing_base), as_backend(compare), id = "usubjid", var = c(
        "aval", "ady"))
    Condition
      Error in `df_compare()`:
      ! `var` variable `ady` not found in the Compare dataset.
      i Use `with` to pair a `var` variable with a differently named Compare variable.
    Code
      df_compare(as_backend(pairing_base), as_backend(compare), id = "usubjid", var = c(
        "aval", "ady"), with = c("aval", "study_day"))
    Condition
      Error in `df_compare()`:
      ! `with` variable `study_day` not found in the Compare dataset.

# var and with naming variables not in their dataset are an error [duckdb]

    Code
      df_compare(as_backend(pairing_base), as_backend(compare), id = "usubjid", var = c(
        "aval", "chg"))
    Condition
      Error in `df_compare()`:
      ! `var` variable `chg` not found in the Base dataset.
    Code
      df_compare(as_backend(pairing_base), as_backend(compare), id = "usubjid", var = c(
        "aval", "ady"))
    Condition
      Error in `df_compare()`:
      ! `var` variable `ady` not found in the Compare dataset.
      i Use `with` to pair a `var` variable with a differently named Compare variable.
    Code
      df_compare(as_backend(pairing_base), as_backend(compare), id = "usubjid", var = c(
        "aval", "ady"), with = c("aval", "study_day"))
    Condition
      Error in `df_compare()`:
      ! `with` variable `study_day` not found in the Compare dataset.

# var or with naming an ID variable is an error [data_frame]

    Code
      df_compare(b, cmp, id = "usubjid", var = c("usubjid", "aval"))
    Condition
      Error in `df_compare()`:
      ! `var` must not name ID variables, but names `usubjid`.
      i ID variables pair observations, so their values are never compared.
    Code
      df_compare(b, cmp, id = "usubjid", var = "avalc", with = "usubjid")
    Condition
      Error in `df_compare()`:
      ! `with` must not name ID variables, but names `usubjid`.
      i ID variables pair observations, so their values are never compared.

# var or with naming an ID variable is an error [arrow]

    Code
      df_compare(b, cmp, id = "usubjid", var = c("usubjid", "aval"))
    Condition
      Error in `df_compare()`:
      ! `var` must not name ID variables, but names `usubjid`.
      i ID variables pair observations, so their values are never compared.
    Code
      df_compare(b, cmp, id = "usubjid", var = "avalc", with = "usubjid")
    Condition
      Error in `df_compare()`:
      ! `with` must not name ID variables, but names `usubjid`.
      i ID variables pair observations, so their values are never compared.

# var or with naming an ID variable is an error [duckdb]

    Code
      df_compare(b, cmp, id = "usubjid", var = c("usubjid", "aval"))
    Condition
      Error in `df_compare()`:
      ! `var` must not name ID variables, but names `usubjid`.
      i ID variables pair observations, so their values are never compared.
    Code
      df_compare(b, cmp, id = "usubjid", var = "avalc", with = "usubjid")
    Condition
      Error in `df_compare()`:
      ! `with` must not name ID variables, but names `usubjid`.
      i ID variables pair observations, so their values are never compared.

# var and with must be character vectors naming each Base variable once [data_frame]

    Code
      df_compare(b, cmp, id = "usubjid", var = 1)
    Condition
      Error in `df_compare()`:
      ! `var` must be `NULL` or a character vector naming at least one variable, not a number.
    Code
      df_compare(b, cmp, id = "usubjid", var = character())
    Condition
      Error in `df_compare()`:
      ! `var` must be `NULL` or a character vector naming at least one variable, not an empty character vector.
    Code
      df_compare(b, cmp, id = "usubjid", var = "aval", with = 2)
    Condition
      Error in `df_compare()`:
      ! `with` must be `NULL` or a character vector naming at least one variable, not a number.
    Code
      df_compare(b, cmp, id = "usubjid", var = c("aval", "aval"), with = c("aval",
        "ady"))
    Condition
      Error in `df_compare()`:
      ! `var` must name each Base variable once, but names `aval` more than once.

# var and with must be character vectors naming each Base variable once [arrow]

    Code
      df_compare(b, cmp, id = "usubjid", var = 1)
    Condition
      Error in `df_compare()`:
      ! `var` must be `NULL` or a character vector naming at least one variable, not a number.
    Code
      df_compare(b, cmp, id = "usubjid", var = character())
    Condition
      Error in `df_compare()`:
      ! `var` must be `NULL` or a character vector naming at least one variable, not an empty character vector.
    Code
      df_compare(b, cmp, id = "usubjid", var = "aval", with = 2)
    Condition
      Error in `df_compare()`:
      ! `with` must be `NULL` or a character vector naming at least one variable, not a number.
    Code
      df_compare(b, cmp, id = "usubjid", var = c("aval", "aval"), with = c("aval",
        "ady"))
    Condition
      Error in `df_compare()`:
      ! `var` must name each Base variable once, but names `aval` more than once.

# var and with must be character vectors naming each Base variable once [duckdb]

    Code
      df_compare(b, cmp, id = "usubjid", var = 1)
    Condition
      Error in `df_compare()`:
      ! `var` must be `NULL` or a character vector naming at least one variable, not a number.
    Code
      df_compare(b, cmp, id = "usubjid", var = character())
    Condition
      Error in `df_compare()`:
      ! `var` must be `NULL` or a character vector naming at least one variable, not an empty character vector.
    Code
      df_compare(b, cmp, id = "usubjid", var = "aval", with = 2)
    Condition
      Error in `df_compare()`:
      ! `with` must be `NULL` or a character vector naming at least one variable, not a number.
    Code
      df_compare(b, cmp, id = "usubjid", var = c("aval", "aval"), with = c("aval",
        "ady"))
    Condition
      Error in `df_compare()`:
      ! `var` must name each Base variable once, but names `aval` more than once.

# by default variable names are case-sensitive, so USUBJID is not usubjid [data_frame]

    Code
      res
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 0
        Variables in Base but not in Compare: 2 (usubjid, aval)
        Variables in Compare but not in Base: 2 (USUBJID, AVAL)
      
      Observation Summary
        Observations in Base:    2
        Observations in Compare: 2
        Matched on visit: 2
      
      Values Summary
        Variables with Unequal values: 0
        Total Unequal values:          0
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 3072

# by default variable names are case-sensitive, so USUBJID is not usubjid [arrow]

    Code
      res
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 0
        Variables in Base but not in Compare: 2 (usubjid, aval)
        Variables in Compare but not in Base: 2 (USUBJID, AVAL)
      
      Observation Summary
        Observations in Base:    2
        Observations in Compare: 2
        Matched on visit: 2
      
      Values Summary
        Variables with Unequal values: 0
        Total Unequal values:          0
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 3072

# by default variable names are case-sensitive, so USUBJID is not usubjid [duckdb]

    Code
      res
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 0
        Variables in Base but not in Compare: 2 (usubjid, aval)
        Variables in Compare but not in Base: 2 (USUBJID, AVAL)
      
      Observation Summary
        Observations in Base:    2
        Observations in Compare: 2
        Matched on visit: 2
      
      Values Summary
        Variables with Unequal values: 0
        Total Unequal values:          0
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 3072

# with ignore_case = TRUE, id, var and with match in any case and results use Base names [data_frame]

    Code
      res
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 2
        Variables in Base but not in Compare: 1 (avalc)
      
      Observation Summary
        Observations in Base:    2
        Observations in Compare: 3
        Matched on usubjid: 2
        Observations in Compare but not in Base: 1
      
      Values Summary
        Variables with Unequal values: 2
        Total Unequal values:          2
      
      Return code: 5248

# with ignore_case = TRUE, id, var and with match in any case and results use Base names [arrow]

    Code
      res
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 2
        Variables in Base but not in Compare: 1 (avalc)
      
      Observation Summary
        Observations in Base:    2
        Observations in Compare: 3
        Matched on usubjid: 2
        Observations in Compare but not in Base: 1
      
      Values Summary
        Variables with Unequal values: 2
        Total Unequal values:          2
      
      Return code: 5248

# with ignore_case = TRUE, id, var and with match in any case and results use Base names [duckdb]

    Code
      res
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 2
        Variables in Base but not in Compare: 1 (avalc)
      
      Observation Summary
        Observations in Base:    2
        Observations in Compare: 3
        Matched on usubjid: 2
        Observations in Compare but not in Base: 1
      
      Values Summary
        Variables with Unequal values: 2
        Total Unequal values:          2
      
      Return code: 5248

# with ignore_case = TRUE, names differing only in case within one dataset are an error [data_frame]

    Code
      df_compare(as_backend(colliding), as_backend(pairing_base), id = "usubjid",
      ignore_case = TRUE)
    Condition
      Error in `df_compare()`:
      ! With `ignore_case = TRUE`, variable names in the Base dataset must differ by more than case.
      x These names are the same ignoring case: `ady`, `Ady`, `aval`, and `AVAL`.
    Code
      df_compare(as_backend(pairing_base), as_backend(colliding), id = "usubjid",
      ignore_case = TRUE)
    Condition
      Error in `df_compare()`:
      ! With `ignore_case = TRUE`, variable names in the Compare dataset must differ by more than case.
      x These names are the same ignoring case: `ady`, `Ady`, `aval`, and `AVAL`.

# with ignore_case = TRUE, names differing only in case within one dataset are an error [arrow]

    Code
      df_compare(as_backend(colliding), as_backend(pairing_base), id = "usubjid",
      ignore_case = TRUE)
    Condition
      Error in `df_compare()`:
      ! With `ignore_case = TRUE`, variable names in the Base dataset must differ by more than case.
      x These names are the same ignoring case: `ady`, `Ady`, `aval`, and `AVAL`.
    Code
      df_compare(as_backend(pairing_base), as_backend(colliding), id = "usubjid",
      ignore_case = TRUE)
    Condition
      Error in `df_compare()`:
      ! With `ignore_case = TRUE`, variable names in the Compare dataset must differ by more than case.
      x These names are the same ignoring case: `ady`, `Ady`, `aval`, and `AVAL`.

# ignore_case must be TRUE or FALSE [data_frame]

    Code
      df_compare(as_backend(pairing_base), as_backend(pairing_base), id = "usubjid",
      ignore_case = "yes")
    Condition
      Error in `df_compare()`:
      ! `ignore_case` must be `TRUE` or `FALSE`, not a string.

# ignore_case must be TRUE or FALSE [arrow]

    Code
      df_compare(as_backend(pairing_base), as_backend(pairing_base), id = "usubjid",
      ignore_case = "yes")
    Condition
      Error in `df_compare()`:
      ! `ignore_case` must be `TRUE` or `FALSE`, not a string.

# ignore_case must be TRUE or FALSE [duckdb]

    Code
      df_compare(as_backend(pairing_base), as_backend(pairing_base), id = "usubjid",
      ignore_case = "yes")
    Condition
      Error in `df_compare()`:
      ! `ignore_case` must be `TRUE` or `FALSE`, not a string.

