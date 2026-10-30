# the Listing shows dataset labels and Attribute differences [data_frame]

    Code
      df_compare(as_backend(base), as_backend(compare), id = "usubjid")
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        3     2  Analysis Dataset
          Compare     3     2
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of Variables with Differing Attributes: 2.
        Number of ID Variables: 1.
      
        Listing of Common Variables with Differing Attributes
          Variable  Attribute  Base            Compare
          aval      label      Analysis Value  Analysis value
          avalc     width      8               200
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid.
        Number of Observations in Common: 2.
        Total Number of Observations Read from Base: 2.
        Total Number of Observations Read from Compare: 2.
      
        Number of Observations with Some Compared Variables Unequal: 0.
        Number of Observations with All Compared Variables Equal: 2.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 2.
        Number of Variables Compared with Some Observations Unequal: 0.
        Total Number of Values which Compare Unequal: 0.
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 49

# the Listing shows dataset labels and Attribute differences [arrow]

    Code
      df_compare(as_backend(base), as_backend(compare), id = "usubjid")
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        3     2  Analysis Dataset
          Compare     3     2
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of Variables with Differing Attributes: 2.
        Number of ID Variables: 1.
      
        Listing of Common Variables with Differing Attributes
          Variable  Attribute  Base            Compare
          aval      label      Analysis Value  Analysis value
          avalc     width      8               200
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid.
        Number of Observations in Common: 2.
        Total Number of Observations Read from Base: 2.
        Total Number of Observations Read from Compare: 2.
      
        Number of Observations with Some Compared Variables Unequal: 0.
        Number of Observations with All Compared Variables Equal: 2.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 2.
        Number of Variables Compared with Some Observations Unequal: 0.
        Total Number of Values which Compare Unequal: 0.
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 49

