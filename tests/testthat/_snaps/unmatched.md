# the Listing counts Unmatched observations in each dataset [data_frame]

    Code
      df_compare(as_backend(base), as_backend(compare), id = c("usubjid", "visit"))
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        3     3
          Compare     3     3
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of ID Variables: 2.
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid, visit.
        Number of Observations in Common: 2.
        Number of Observations in Base but not in Compare: 1.
        Number of Observations in Compare but not in Base: 1.
        Total Number of Observations Read from Base: 3.
        Total Number of Observations Read from Compare: 3.
      
        Number of Observations with Some Compared Variables Unequal: 0.
        Number of Observations with All Compared Variables Equal: 2.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 1.
        Number of Variables Compared with Some Observations Unequal: 0.
        Total Number of Values which Compare Unequal: 0.
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 192

# the Listing counts Unmatched observations in each dataset [arrow]

    Code
      df_compare(as_backend(base), as_backend(compare), id = c("usubjid", "visit"))
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        3     3
          Compare     3     3
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of ID Variables: 2.
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid, visit.
        Number of Observations in Common: 2.
        Number of Observations in Base but not in Compare: 1.
        Number of Observations in Compare but not in Base: 1.
        Total Number of Observations Read from Base: 3.
        Total Number of Observations Read from Compare: 3.
      
        Number of Observations with Some Compared Variables Unequal: 0.
        Number of Observations with All Compared Variables Equal: 2.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 1.
        Number of Variables Compared with Some Observations Unequal: 0.
        Total Number of Values which Compare Unequal: 0.
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 192

# the Listing counts Unmatched observations in each dataset [duckdb]

    Code
      df_compare(as_backend(base), as_backend(compare), id = c("usubjid", "visit"))
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        3     3
          Compare     3     3
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of ID Variables: 2.
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid, visit.
        Number of Observations in Common: 2.
        Number of Observations in Base but not in Compare: 1.
        Number of Observations in Compare but not in Base: 1.
        Total Number of Observations Read from Base: 3.
        Total Number of Observations Read from Compare: 3.
      
        Number of Observations with Some Compared Variables Unequal: 0.
        Number of Observations with All Compared Variables Equal: 2.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 1.
        Number of Variables Compared with Some Observations Unequal: 0.
        Total Number of Values which Compare Unequal: 0.
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 192

# the Listing names Variables found in only one dataset [data_frame]

    Code
      df_compare(as_backend(base_v), as_backend(compare), id = "usubjid")
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        5     3
          Compare     4     3
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of Variables in Base but not in Compare: 2.
        Number of Variables in Compare but not in Base: 1.
        Number of ID Variables: 1.
      
        Listing of Variables in Base but not in Compare
          only_b1
          only_b2
      
        Listing of Variables in Compare but not in Base
          only_c
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid.
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
      
      Return code: 3072

# the Listing names Variables found in only one dataset [arrow]

    Code
      df_compare(as_backend(base_v), as_backend(compare), id = "usubjid")
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        5     3
          Compare     4     3
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of Variables in Base but not in Compare: 2.
        Number of Variables in Compare but not in Base: 1.
        Number of ID Variables: 1.
      
        Listing of Variables in Base but not in Compare
          only_b1
          only_b2
      
        Listing of Variables in Compare but not in Base
          only_c
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid.
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
      
      Return code: 3072

# the Listing names Variables found in only one dataset [duckdb]

    Code
      df_compare(as_backend(base_v), as_backend(compare), id = "usubjid")
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        5     3
          Compare     4     3
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of Variables in Base but not in Compare: 2.
        Number of Variables in Compare but not in Base: 1.
        Number of ID Variables: 1.
      
        Listing of Variables in Base but not in Compare
          only_b1
          only_b2
      
        Listing of Variables in Compare but not in Base
          only_c
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid.
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
      
      Return code: 3072

# a Duplicate ID in Base gives a warning and Return code 65536 [data_frame]

    Code
      res <- df_compare(as_backend(base_dup), as_backend(base), id = c("usubjid",
        "visit"))
    Condition
      Warning in `df_compare()`:
      Duplicate IDs found; their observations are not paired or compared.
      * Base dataset: 1 Duplicate ID.

# a Duplicate ID in Base gives a warning and Return code 65536 [arrow]

    Code
      res <- df_compare(as_backend(base_dup), as_backend(base), id = c("usubjid",
        "visit"))
    Condition
      Warning in `df_compare()`:
      Duplicate IDs found; their observations are not paired or compared.
      * Base dataset: 1 Duplicate ID.

# a Duplicate ID in Base gives a warning and Return code 65536 [duckdb]

    Code
      res <- df_compare(as_backend(base_dup), as_backend(base), id = c("usubjid",
        "visit"))
    Condition
      Warning in `df_compare()`:
      Duplicate IDs found; their observations are not paired or compared.
      * Base dataset: 1 Duplicate ID.

# the Listing lists Duplicate IDs and does not count them as Matched observations [data_frame]

    Code
      df_compare(as_backend(base_dup), as_backend(compare_dup), id = c("usubjid",
        "visit"))
    Condition
      Warning in `df_compare()`:
      Duplicate IDs found; their observations are not paired or compared.
      * Base dataset: 1 Duplicate ID.
      * Compare dataset: 1 Duplicate ID.
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        3     5
          Compare     3     4
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of ID Variables: 2.
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid, visit.
        Number of Observations in Common: 1.
        Number of Duplicate IDs (not compared): 2.
        Total Number of Observations Read from Base: 5.
        Total Number of Observations Read from Compare: 4.
      
        Number of Observations with Some Compared Variables Unequal: 0.
        Number of Observations with All Compared Variables Equal: 1.
      
        Listing of Duplicate IDs
          Dataset  usubjid  visit  Observations
          Base     01       1                 3
          Compare  03       2                 2
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 1.
        Number of Variables Compared with Some Observations Unequal: 0.
        Total Number of Values which Compare Unequal: 0.
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 65536

# the Listing lists Duplicate IDs and does not count them as Matched observations [arrow]

    Code
      df_compare(as_backend(base_dup), as_backend(compare_dup), id = c("usubjid",
        "visit"))
    Condition
      Warning in `df_compare()`:
      Duplicate IDs found; their observations are not paired or compared.
      * Base dataset: 1 Duplicate ID.
      * Compare dataset: 1 Duplicate ID.
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        3     5
          Compare     3     4
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of ID Variables: 2.
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid, visit.
        Number of Observations in Common: 1.
        Number of Duplicate IDs (not compared): 2.
        Total Number of Observations Read from Base: 5.
        Total Number of Observations Read from Compare: 4.
      
        Number of Observations with Some Compared Variables Unequal: 0.
        Number of Observations with All Compared Variables Equal: 1.
      
        Listing of Duplicate IDs
          Dataset  usubjid  visit  Observations
          Base     01       1                 3
          Compare  03       2                 2
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 1.
        Number of Variables Compared with Some Observations Unequal: 0.
        Total Number of Values which Compare Unequal: 0.
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 65536

# the Listing lists Duplicate IDs and does not count them as Matched observations [duckdb]

    Code
      df_compare(as_backend(base_dup), as_backend(compare_dup), id = c("usubjid",
        "visit"))
    Condition
      Warning in `df_compare()`:
      Duplicate IDs found; their observations are not paired or compared.
      * Base dataset: 1 Duplicate ID.
      * Compare dataset: 1 Duplicate ID.
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        3     5
          Compare     3     4
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of ID Variables: 2.
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid, visit.
        Number of Observations in Common: 1.
        Number of Duplicate IDs (not compared): 2.
        Total Number of Observations Read from Base: 5.
        Total Number of Observations Read from Compare: 4.
      
        Number of Observations with Some Compared Variables Unequal: 0.
        Number of Observations with All Compared Variables Equal: 1.
      
        Listing of Duplicate IDs
          Dataset  usubjid  visit  Observations
          Base     01       1                 3
          Compare  03       2                 2
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 1.
        Number of Variables Compared with Some Observations Unequal: 0.
        Total Number of Values which Compare Unequal: 0.
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 65536

