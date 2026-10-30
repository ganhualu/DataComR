# a Base dataset as data_frame can be compared with a Compare dataset as arrow

    Code
      print(res)
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 2
      
      Observation Summary
        Observations in Base:    3
        Observations in Compare: 3
        Matched on usubjid, visit: 3
      
      Values Summary
        Variables with Unequal values: 2
        Total Unequal values:          2
      
      Return code: 4096

# a Base dataset as data_frame can be compared with a Compare dataset as duckdb

    Code
      print(res)
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 2
      
      Observation Summary
        Observations in Base:    3
        Observations in Compare: 3
        Matched on usubjid, visit: 3
      
      Values Summary
        Variables with Unequal values: 2
        Total Unequal values:          2
      
      Return code: 4096

# a Base dataset as arrow can be compared with a Compare dataset as data_frame

    Code
      print(res)
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 2
      
      Observation Summary
        Observations in Base:    3
        Observations in Compare: 3
        Matched on usubjid, visit: 3
      
      Values Summary
        Variables with Unequal values: 2
        Total Unequal values:          2
      
      Return code: 4096

# a Base dataset as arrow can be compared with a Compare dataset as duckdb

    Code
      print(res)
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 2
      
      Observation Summary
        Observations in Base:    3
        Observations in Compare: 3
        Matched on usubjid, visit: 3
      
      Values Summary
        Variables with Unequal values: 2
        Total Unequal values:          2
      
      Return code: 4096

# a Base dataset as duckdb can be compared with a Compare dataset as data_frame

    Code
      print(res)
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 2
      
      Observation Summary
        Observations in Base:    3
        Observations in Compare: 3
        Matched on usubjid, visit: 3
      
      Values Summary
        Variables with Unequal values: 2
        Total Unequal values:          2
      
      Return code: 4096

# a Base dataset as duckdb can be compared with a Compare dataset as arrow

    Code
      print(res)
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 2
      
      Observation Summary
        Observations in Base:    3
        Observations in Compare: 3
        Matched on usubjid, visit: 3
      
      Values Summary
        Variables with Unequal values: 2
        Total Unequal values:          2
      
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

