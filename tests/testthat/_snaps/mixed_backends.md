# a Base dataset as data_frame can be compared with a Compare dataset as arrow

    Code
      print(res)
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
      
        Number of Observations with Some Compared Variables Unequal: 2.
        Number of Observations with All Compared Variables Equal: 1.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 0.
        Number of Variables Compared with Some Observations Unequal: 2.
        Total Number of Values which Compare Unequal: 2.
        Maximum Difference: 1.
      
      Variables with Unequal Values
      
          Variable  Type       Ndif  MaxDif
          aval      numeric       1       1
          aval_c    character     1
      
      Value Comparison Results for Variables
      
        ____________________________________________________________________
                              ||       Base    Compare
        usubjid    visit      ||       aval       aval      Diff.     % Diff
        _________  _________  ||  _________  _________  _________  _________
                              ||
        02         1          ||         20         21          1          5
        ____________________________________________________________________
      
        ______________________________________________
                              ||       Base    Compare
        usubjid    visit      ||     aval_c     aval_c
        _________  _________  ||  _________  _________
                              ||
        03         2          ||  c          .
        ______________________________________________
      
      Return code: 4096

# a Base dataset as data_frame can be compared with a Compare dataset as duckdb

    Code
      print(res)
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
      
        Number of Observations with Some Compared Variables Unequal: 2.
        Number of Observations with All Compared Variables Equal: 1.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 0.
        Number of Variables Compared with Some Observations Unequal: 2.
        Total Number of Values which Compare Unequal: 2.
        Maximum Difference: 1.
      
      Variables with Unequal Values
      
          Variable  Type       Ndif  MaxDif
          aval      numeric       1       1
          aval_c    character     1
      
      Value Comparison Results for Variables
      
        ____________________________________________________________________
                              ||       Base    Compare
        usubjid    visit      ||       aval       aval      Diff.     % Diff
        _________  _________  ||  _________  _________  _________  _________
                              ||
        02         1          ||         20         21          1          5
        ____________________________________________________________________
      
        ______________________________________________
                              ||       Base    Compare
        usubjid    visit      ||     aval_c     aval_c
        _________  _________  ||  _________  _________
                              ||
        03         2          ||  c          .
        ______________________________________________
      
      Return code: 4096

# a Base dataset as arrow can be compared with a Compare dataset as data_frame

    Code
      print(res)
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
      
        Number of Observations with Some Compared Variables Unequal: 2.
        Number of Observations with All Compared Variables Equal: 1.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 0.
        Number of Variables Compared with Some Observations Unequal: 2.
        Total Number of Values which Compare Unequal: 2.
        Maximum Difference: 1.
      
      Variables with Unequal Values
      
          Variable  Type       Ndif  MaxDif
          aval      numeric       1       1
          aval_c    character     1
      
      Value Comparison Results for Variables
      
        ____________________________________________________________________
                              ||       Base    Compare
        usubjid    visit      ||       aval       aval      Diff.     % Diff
        _________  _________  ||  _________  _________  _________  _________
                              ||
        02         1          ||         20         21          1          5
        ____________________________________________________________________
      
        ______________________________________________
                              ||       Base    Compare
        usubjid    visit      ||     aval_c     aval_c
        _________  _________  ||  _________  _________
                              ||
        03         2          ||  c          .
        ______________________________________________
      
      Return code: 4096

# a Base dataset as arrow can be compared with a Compare dataset as duckdb

    Code
      print(res)
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
      
        Number of Observations with Some Compared Variables Unequal: 2.
        Number of Observations with All Compared Variables Equal: 1.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 0.
        Number of Variables Compared with Some Observations Unequal: 2.
        Total Number of Values which Compare Unequal: 2.
        Maximum Difference: 1.
      
      Variables with Unequal Values
      
          Variable  Type       Ndif  MaxDif
          aval      numeric       1       1
          aval_c    character     1
      
      Value Comparison Results for Variables
      
        ____________________________________________________________________
                              ||       Base    Compare
        usubjid    visit      ||       aval       aval      Diff.     % Diff
        _________  _________  ||  _________  _________  _________  _________
                              ||
        02         1          ||         20         21          1          5
        ____________________________________________________________________
      
        ______________________________________________
                              ||       Base    Compare
        usubjid    visit      ||     aval_c     aval_c
        _________  _________  ||  _________  _________
                              ||
        03         2          ||  c          .
        ______________________________________________
      
      Return code: 4096

# a Base dataset as duckdb can be compared with a Compare dataset as data_frame

    Code
      print(res)
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
      
        Number of Observations with Some Compared Variables Unequal: 2.
        Number of Observations with All Compared Variables Equal: 1.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 0.
        Number of Variables Compared with Some Observations Unequal: 2.
        Total Number of Values which Compare Unequal: 2.
        Maximum Difference: 1.
      
      Variables with Unequal Values
      
          Variable  Type       Ndif  MaxDif
          aval      numeric       1       1
          aval_c    character     1
      
      Value Comparison Results for Variables
      
        ____________________________________________________________________
                              ||       Base    Compare
        usubjid    visit      ||       aval       aval      Diff.     % Diff
        _________  _________  ||  _________  _________  _________  _________
                              ||
        02         1          ||         20         21          1          5
        ____________________________________________________________________
      
        ______________________________________________
                              ||       Base    Compare
        usubjid    visit      ||     aval_c     aval_c
        _________  _________  ||  _________  _________
                              ||
        03         2          ||  c          .
        ______________________________________________
      
      Return code: 4096

# a Base dataset as duckdb can be compared with a Compare dataset as arrow

    Code
      print(res)
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
      
        Number of Observations with Some Compared Variables Unequal: 2.
        Number of Observations with All Compared Variables Equal: 1.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 0.
        Number of Variables Compared with Some Observations Unequal: 2.
        Total Number of Values which Compare Unequal: 2.
        Maximum Difference: 1.
      
      Variables with Unequal Values
      
          Variable  Type       Ndif  MaxDif
          aval      numeric       1       1
          aval_c    character     1
      
      Value Comparison Results for Variables
      
        ____________________________________________________________________
                              ||       Base    Compare
        usubjid    visit      ||       aval       aval      Diff.     % Diff
        _________  _________  ||  _________  _________  _________  _________
                              ||
        02         1          ||         20         21          1          5
        ____________________________________________________________________
      
        ______________________________________________
                              ||       Base    Compare
        usubjid    visit      ||     aval_c     aval_c
        _________  _________  ||  _________  _________
                              ||
        03         2          ||  c          .
        ______________________________________________
      
      Return code: 4096

# duckdb tables in different connections are an error

    Code
      df_compare(backends$duckdb(base), other, id = c("usubjid", "visit"))
    Condition
      Error in `df_compare()`:
      ! The Base and Compare duckdb tables must share one duckdb connection.

# a dataset that is not a data frame, arrow or duckdb table is an error

    Code
      df_compare(base, list(a = 1), id = "usubjid")
    Condition
      Error in `df_compare()`:
      ! The Compare dataset must be a data frame, an arrow table or dataset, or a duckdb table, not a list.

