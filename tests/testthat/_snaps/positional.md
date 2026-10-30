# the Listing says observations were matched by position

    Code
      df_compare(base, compare)
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Variables Summary
        Variables compared: 2
      
      Observation Summary
        Observations in Base:    3
        Observations in Compare: 4
        Matched by position: 3
        Observations in Compare but not in Base: 1
      
      Values Summary
        Variables with Unequal values: 1
        Total Unequal values:          1
      
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

