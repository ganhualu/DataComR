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

