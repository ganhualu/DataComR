# the Listing shows dataset labels and Attribute differences [data_frame]

    Code
      df_compare(as_backend(base), as_backend(compare), id = "usubjid")
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Dataset Summary
        Base label:    Analysis Dataset
        Compare label: (none)
      
      Variables Summary
        Variables compared: 2
        Variables with Attribute differences: 2
      
        Attribute differences
          Variable  Attribute  Base            Compare
          aval      label      Analysis Value  Analysis value
          avalc     width      8               200
      
      Observation Summary
        Observations in Base:    2
        Observations in Compare: 2
        Matched on usubjid: 2
      
      Values Summary
        Variables with Unequal values: 0
        Total Unequal values:          0
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 49

# the Listing shows dataset labels and Attribute differences [arrow]

    Code
      df_compare(as_backend(base), as_backend(compare), id = "usubjid")
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Dataset Summary
        Base label:    Analysis Dataset
        Compare label: (none)
      
      Variables Summary
        Variables compared: 2
        Variables with Attribute differences: 2
      
        Attribute differences
          Variable  Attribute  Base            Compare
          aval      label      Analysis Value  Analysis value
          avalc     width      8               200
      
      Observation Summary
        Observations in Base:    2
        Observations in Compare: 2
        Matched on usubjid: 2
      
      Values Summary
        Variables with Unequal values: 0
        Total Unequal values:          0
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 49

