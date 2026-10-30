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

