# an ID variable missing from either dataset is an error [data_frame]

    Code
      df_compare(as_backend(base), as_backend(compare), id = c("usubjid", "visit"))
    Condition
      Error in `df_compare()`:
      ! ID variable `visit` not found in the Compare dataset.

---

    Code
      df_compare(as_backend(compare), as_backend(base), id = c("usubjid", "visit"))
    Condition
      Error in `df_compare()`:
      ! ID variable `visit` not found in the Base dataset.

# printing shows a minimal Listing [data_frame]

    Code
      df_compare(as_backend(base), as_backend(base), id = c("usubjid", "visit"))
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Observation Summary
        Observations in Base:    3
        Observations in Compare: 3
        Matched on usubjid, visit: 3
      
      Values Summary
        Variables compared:            2
        Variables with Unequal values: 0
        Total Unequal values:          0
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 0
    Code
      df_compare(as_backend(base), as_backend(compare), id = c("usubjid", "visit"))
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      
      Observation Summary
        Observations in Base:    3
        Observations in Compare: 3
        Matched on usubjid, visit: 3
      
      Values Summary
        Variables compared:            2
        Variables with Unequal values: 1
        Total Unequal values:          1
      
      Return code: 4096

# id must name at least one ID variable [data_frame]

    Code
      df_compare(as_backend(base), as_backend(base), id = character())
    Condition
      Error in `df_compare()`:
      ! `id` must be a character vector naming at least one ID variable.

---

    Code
      df_compare(as_backend(base), as_backend(base), id = 1)
    Condition
      Error in `df_compare()`:
      ! `id` must be a character vector naming at least one ID variable.

