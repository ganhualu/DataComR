# an ID variable missing from either dataset is an error [data_frame]

    Code
      df_compare(as_backend(base), as_backend(compare), id = c("usubjid", "visit"))
    Condition
      Error in `df_compare()`:
      ! ID variable `visit` not found in the Compare dataset.

---

    Code
      df_compare(as_backend(compare), as_backend(base), id = c("usubjid", "visit"))
    Condition
      Error in `df_compare()`:
      ! ID variable `visit` not found in the Base dataset.

# an ID variable missing from either dataset is an error [arrow]

    Code
      df_compare(as_backend(base), as_backend(compare), id = c("usubjid", "visit"))
    Condition
      Error in `df_compare()`:
      ! ID variable `visit` not found in the Compare dataset.

---

    Code
      df_compare(as_backend(compare), as_backend(base), id = c("usubjid", "visit"))
    Condition
      Error in `df_compare()`:
      ! ID variable `visit` not found in the Base dataset.

# an ID variable missing from either dataset is an error [duckdb]

    Code
      df_compare(as_backend(base), as_backend(compare), id = c("usubjid", "visit"))
    Condition
      Error in `df_compare()`:
      ! ID variable `visit` not found in the Compare dataset.

---

    Code
      df_compare(as_backend(compare), as_backend(base), id = c("usubjid", "visit"))
    Condition
      Error in `df_compare()`:
      ! ID variable `visit` not found in the Base dataset.

# printing shows a minimal Listing [data_frame]

    Code
      df_compare(as_backend(base), as_backend(base), id = c("usubjid", "visit"))
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        4     3
          Compare     4     3
      
      Variables Summary
      
        Number of Variables in Common: 4.
        Number of ID Variables: 2.
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid, visit.
        Number of Observations in Common: 3.
        Total Number of Observations Read from Base: 3.
        Total Number of Observations Read from Compare: 3.
      
        Number of Observations with Some Compared Variables Unequal: 0.
        Number of Observations with All Compared Variables Equal: 3.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 2.
        Number of Variables Compared with Some Observations Unequal: 0.
        Total Number of Values which Compare Unequal: 0.
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 0
    Code
      df_compare(as_backend(base), as_backend(compare), id = c("usubjid", "visit"))
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        4     3
          Compare     4     3
      
      Variables Summary
      
        Number of Variables in Common: 4.
        Number of ID Variables: 2.
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid, visit.
        Number of Observations in Common: 3.
        Total Number of Observations Read from Base: 3.
        Total Number of Observations Read from Compare: 3.
      
        Number of Observations with Some Compared Variables Unequal: 1.
        Number of Observations with All Compared Variables Equal: 2.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 1.
        Number of Variables Compared with Some Observations Unequal: 1.
        Total Number of Values which Compare Unequal: 1.
        Maximum Difference: 1.
      
      Variables with Unequal Values
      
          Variable  Type     Ndif  MaxDif
          aval      numeric     1       1
      
      Value Comparison Results for Variables
      
        ____________________________________________________________________
                              ||       Base    Compare
        usubjid    visit      ||       aval       aval      Diff.     % Diff
        _________  _________  ||  _________  _________  _________  _________
                              ||
        02         1          ||         20         21          1          5
        ____________________________________________________________________
      
      Return code: 4096

# printing shows a minimal Listing [arrow]

    Code
      df_compare(as_backend(base), as_backend(base), id = c("usubjid", "visit"))
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        4     3
          Compare     4     3
      
      Variables Summary
      
        Number of Variables in Common: 4.
        Number of ID Variables: 2.
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid, visit.
        Number of Observations in Common: 3.
        Total Number of Observations Read from Base: 3.
        Total Number of Observations Read from Compare: 3.
      
        Number of Observations with Some Compared Variables Unequal: 0.
        Number of Observations with All Compared Variables Equal: 3.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 2.
        Number of Variables Compared with Some Observations Unequal: 0.
        Total Number of Values which Compare Unequal: 0.
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 0
    Code
      df_compare(as_backend(base), as_backend(compare), id = c("usubjid", "visit"))
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        4     3
          Compare     4     3
      
      Variables Summary
      
        Number of Variables in Common: 4.
        Number of ID Variables: 2.
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid, visit.
        Number of Observations in Common: 3.
        Total Number of Observations Read from Base: 3.
        Total Number of Observations Read from Compare: 3.
      
        Number of Observations with Some Compared Variables Unequal: 1.
        Number of Observations with All Compared Variables Equal: 2.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 1.
        Number of Variables Compared with Some Observations Unequal: 1.
        Total Number of Values which Compare Unequal: 1.
        Maximum Difference: 1.
      
      Variables with Unequal Values
      
          Variable  Type     Ndif  MaxDif
          aval      numeric     1       1
      
      Value Comparison Results for Variables
      
        ____________________________________________________________________
                              ||       Base    Compare
        usubjid    visit      ||       aval       aval      Diff.     % Diff
        _________  _________  ||  _________  _________  _________  _________
                              ||
        02         1          ||         20         21          1          5
        ____________________________________________________________________
      
      Return code: 4096

# printing shows a minimal Listing [duckdb]

    Code
      df_compare(as_backend(base), as_backend(base), id = c("usubjid", "visit"))
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        4     3
          Compare     4     3
      
      Variables Summary
      
        Number of Variables in Common: 4.
        Number of ID Variables: 2.
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid, visit.
        Number of Observations in Common: 3.
        Total Number of Observations Read from Base: 3.
        Total Number of Observations Read from Compare: 3.
      
        Number of Observations with Some Compared Variables Unequal: 0.
        Number of Observations with All Compared Variables Equal: 3.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 2.
        Number of Variables Compared with Some Observations Unequal: 0.
        Total Number of Values which Compare Unequal: 0.
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 0
    Code
      df_compare(as_backend(base), as_backend(compare), id = c("usubjid", "visit"))
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        4     3
          Compare     4     3
      
      Variables Summary
      
        Number of Variables in Common: 4.
        Number of ID Variables: 2.
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid, visit.
        Number of Observations in Common: 3.
        Total Number of Observations Read from Base: 3.
        Total Number of Observations Read from Compare: 3.
      
        Number of Observations with Some Compared Variables Unequal: 1.
        Number of Observations with All Compared Variables Equal: 2.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 1.
        Number of Variables Compared with Some Observations Unequal: 1.
        Total Number of Values which Compare Unequal: 1.
        Maximum Difference: 1.
      
      Variables with Unequal Values
      
          Variable  Type     Ndif  MaxDif
          aval      numeric     1       1
      
      Value Comparison Results for Variables
      
        ____________________________________________________________________
                              ||       Base    Compare
        usubjid    visit      ||       aval       aval      Diff.     % Diff
        _________  _________  ||  _________  _________  _________  _________
                              ||
        02         1          ||         20         21          1          5
        ____________________________________________________________________
      
      Return code: 4096

# id must name at least one ID variable [data_frame]

    Code
      df_compare(as_backend(base), as_backend(base), id = character())
    Condition
      Error in `df_compare()`:
      ! `id` must be a character vector naming at least one ID variable.

---

    Code
      df_compare(as_backend(base), as_backend(base), id = 1)
    Condition
      Error in `df_compare()`:
      ! `id` must be a character vector naming at least one ID variable.

# id must name at least one ID variable [arrow]

    Code
      df_compare(as_backend(base), as_backend(base), id = character())
    Condition
      Error in `df_compare()`:
      ! `id` must be a character vector naming at least one ID variable.

---

    Code
      df_compare(as_backend(base), as_backend(base), id = 1)
    Condition
      Error in `df_compare()`:
      ! `id` must be a character vector naming at least one ID variable.

# id must name at least one ID variable [duckdb]

    Code
      df_compare(as_backend(base), as_backend(base), id = character())
    Condition
      Error in `df_compare()`:
      ! `id` must be a character vector naming at least one ID variable.

---

    Code
      df_compare(as_backend(base), as_backend(base), id = 1)
    Condition
      Error in `df_compare()`:
      ! `id` must be a character vector naming at least one ID variable.

