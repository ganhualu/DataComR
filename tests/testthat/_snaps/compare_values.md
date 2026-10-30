# a type difference within a Type family is listed but sets no bit [data_frame]

    Code
      print(res)
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 3
        Variables with different types in the same Type family: 2
          n: integer in Base, double in Compare
          s: factor in Base, character in Compare
      
      Observation Summary
        Observations in Base:    2
        Observations in Compare: 2
        Matched on id: 2
      
      Values Summary
        Variables with Unequal values: 0
        Total Unequal values:          0
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 0

# numeric against character is Conflicting types: listed, bit 8192, not value-compared [data_frame]

    Code
      print(res)
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 1
        Variables with Conflicting types: 1
          x: double (numeric) in Base, character (character) in Compare
      
      Observation Summary
        Observations in Base:    2
        Observations in Compare: 2
        Matched on id: 2
      
      Values Summary
        Variables with Unequal values: 1
        Total Unequal values:          1
      
      Return code: 12288

# date, datetime, numeric and character are four Type families [data_frame]

    Code
      print(res)
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 0
        Variables with Conflicting types: 4
          a: Date (date) in Base, POSIXct (datetime) in Compare
          b: POSIXct (datetime) in Base, double (numeric) in Compare
          c: Date (date) in Base, character (character) in Compare
          d: POSIXct (datetime) in Base, Date (date) in Compare
      
      Observation Summary
        Observations in Base:    1
        Observations in Compare: 1
        Matched on id: 1
      
      Values Summary
        Variables with Unequal values: 0
        Total Unequal values:          0
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 8192

# an unknown Comparison method is an error [data_frame]

    Code
      df_compare(as_backend(df), as_backend(df), id = "id", method = "absolut")
    Condition
      Error in `df_compare()`:
      ! `method` must be one of "exact", "absolute", "relative", or "percent", not "absolut".
      i Did you mean "absolute"?

# an invalid Criterion or relative_delta is an error [data_frame]

    Code
      cmp(method = "absolute", criterion = -1)
    Condition
      Error in `df_compare()`:
      ! `criterion` must be a single non-negative number, not -1.
    Code
      cmp(method = "absolute", criterion = NA_real_)
    Condition
      Error in `df_compare()`:
      ! `criterion` must be a single non-negative number, not a numeric `NA`.
    Code
      cmp(method = "absolute", criterion = "0.1")
    Condition
      Error in `df_compare()`:
      ! `criterion` must be a single non-negative number, not a string.
    Code
      cmp(method = "absolute", criterion = c(0.1, 0.2))
    Condition
      Error in `df_compare()`:
      ! `criterion` must be a single non-negative number, not a double vector.
    Code
      cmp(method = "relative", relative_delta = 2)
    Condition
      Error in `df_compare()`:
      ! `relative_delta` must be a single number between 0 and 1, not 2.
    Code
      cmp(method = "relative", relative_delta = -0.1)
    Condition
      Error in `df_compare()`:
      ! `relative_delta` must be a single number between 0 and 1, not -0.1.

