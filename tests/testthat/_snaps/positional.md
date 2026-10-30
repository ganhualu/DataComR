# the Listing says observations were matched by position

    Code
      df_compare(base, compare)
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        2     3
          Compare     2     4
      
      Variables Summary
      
        Number of Variables in Common: 2.
      
      Observation Summary
      
        Observations are matched by position.
        Number of Observations in Common: 3.
        Number of Observations in Compare but not in Base: 1.
        Total Number of Observations Read from Base: 3.
        Total Number of Observations Read from Compare: 4.
      
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
      
        _________________________________________________________
                   ||       Base    Compare
        obs        ||       aval       aval      Diff.     % Diff
        _________  ||  _________  _________  _________  _________
                   ||
        2          ||         20         21          1          5
        _________________________________________________________
      
      Return code: 4224

# without ID variables, a variable named obs is an error rather than being overwritten

    Code
      df_compare(base_obs, base)
    Condition
      Error in `df_compare()`:
      ! The Base dataset has a variable named `obs`, which DataComR uses for observation numbers when matching by position.
      i Name the ID variables in `id`, or rename `obs`.

---

    Code
      df_compare(base, base_obs)
    Condition
      Error in `df_compare()`:
      ! The Compare dataset has a variable named `obs`, which DataComR uses for observation numbers when matching by position.
      i Name the ID variables in `id`, or rename `obs`.

# without ID variables, a Base dataset as data_frame with a Compare dataset as arrow is an error

    Code
      df_compare(base_data, compare_data)
    Condition
      Error in `df_compare()`:
      ! ID variables are required to compare arrow or duckdb data.
      i Without `id`, observations are matched by position, but the observation order of arrow and duckdb data is not guaranteed.
      x The Compare dataset is not a data frame.
      i Name the ID variables in `id`.

# without ID variables, a Base dataset as data_frame with a Compare dataset as duckdb is an error

    Code
      df_compare(base_data, compare_data)
    Condition
      Error in `df_compare()`:
      ! ID variables are required to compare arrow or duckdb data.
      i Without `id`, observations are matched by position, but the observation order of arrow and duckdb data is not guaranteed.
      x The Compare dataset is not a data frame.
      i Name the ID variables in `id`.

# without ID variables, a Base dataset as arrow with a Compare dataset as data_frame is an error

    Code
      df_compare(base_data, compare_data)
    Condition
      Error in `df_compare()`:
      ! ID variables are required to compare arrow or duckdb data.
      i Without `id`, observations are matched by position, but the observation order of arrow and duckdb data is not guaranteed.
      x The Base dataset is not a data frame.
      i Name the ID variables in `id`.

# without ID variables, a Base dataset as arrow with a Compare dataset as arrow is an error

    Code
      df_compare(base_data, compare_data)
    Condition
      Error in `df_compare()`:
      ! ID variables are required to compare arrow or duckdb data.
      i Without `id`, observations are matched by position, but the observation order of arrow and duckdb data is not guaranteed.
      x The Base and Compare datasets are not data frames.
      i Name the ID variables in `id`.

# without ID variables, a Base dataset as arrow with a Compare dataset as duckdb is an error

    Code
      df_compare(base_data, compare_data)
    Condition
      Error in `df_compare()`:
      ! ID variables are required to compare arrow or duckdb data.
      i Without `id`, observations are matched by position, but the observation order of arrow and duckdb data is not guaranteed.
      x The Base and Compare datasets are not data frames.
      i Name the ID variables in `id`.

# without ID variables, a Base dataset as duckdb with a Compare dataset as data_frame is an error

    Code
      df_compare(base_data, compare_data)
    Condition
      Error in `df_compare()`:
      ! ID variables are required to compare arrow or duckdb data.
      i Without `id`, observations are matched by position, but the observation order of arrow and duckdb data is not guaranteed.
      x The Base dataset is not a data frame.
      i Name the ID variables in `id`.

# without ID variables, a Base dataset as duckdb with a Compare dataset as arrow is an error

    Code
      df_compare(base_data, compare_data)
    Condition
      Error in `df_compare()`:
      ! ID variables are required to compare arrow or duckdb data.
      i Without `id`, observations are matched by position, but the observation order of arrow and duckdb data is not guaranteed.
      x The Base and Compare datasets are not data frames.
      i Name the ID variables in `id`.

# without ID variables, a Base dataset as duckdb with a Compare dataset as duckdb is an error

    Code
      df_compare(base_data, compare_data)
    Condition
      Error in `df_compare()`:
      ! ID variables are required to compare arrow or duckdb data.
      i Without `id`, observations are matched by position, but the observation order of arrow and duckdb data is not guaranteed.
      x The Base and Compare datasets are not data frames.
      i Name the ID variables in `id`.

