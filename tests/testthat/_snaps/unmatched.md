# the Listing counts Unmatched observations in each dataset [data_frame]

    Code
      df_compare(as_backend(base), as_backend(compare), id = c("usubjid", "visit"))
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 1
      
      Observation Summary
        Observations in Base:    3
        Observations in Compare: 3
        Matched on usubjid, visit: 2
        Observations in Base but not in Compare: 1
        Observations in Compare but not in Base: 1
      
      Values Summary
        Variables with Unequal values: 0
        Total Unequal values:          0
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 192

# the Listing names Variables found in only one dataset [data_frame]

    Code
      df_compare(as_backend(base_v), as_backend(compare), id = "usubjid")
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 2
        Variables in Base but not in Compare: 2 (only_b1, only_b2)
        Variables in Compare but not in Base: 1 (only_c)
      
      Observation Summary
        Observations in Base:    3
        Observations in Compare: 3
        Matched on usubjid: 3
      
      Values Summary
        Variables with Unequal values: 0
        Total Unequal values:          0
      
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
      
      Variables Summary
        Variables compared: 1
      
      Observation Summary
        Observations in Base:    5
        Observations in Compare: 4
        Matched on usubjid, visit: 1
        Duplicate IDs (not compared): 2
          Base     usubjid=01, visit=1 (3 observations)
          Compare  usubjid=03, visit=2 (2 observations)
      
      Values Summary
        Variables with Unequal values: 0
        Total Unequal values:          0
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 65536

