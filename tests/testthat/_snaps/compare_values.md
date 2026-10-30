# a type difference within a Type family is listed but sets no bit [data_frame]

    Code
      print(res)
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        4     2
          Compare     4     2
      
      Variables Summary
      
        Number of Variables in Common: 4.
        Number of Variables with Different Types in the Same Type Family: 2.
        Number of ID Variables: 1.
      
        Listing of Variables with Different Types in the Same Type Family
          Variable  Base     Compare
          n         integer  double
          s         factor   character
      
      Observation Summary
      
        Observations are matched on ID variables: id.
        Number of Observations in Common: 2.
        Total Number of Observations Read from Base: 2.
        Total Number of Observations Read from Compare: 2.
      
        Number of Observations with Some Compared Variables Unequal: 0.
        Number of Observations with All Compared Variables Equal: 2.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 3.
        Number of Variables Compared with Some Observations Unequal: 0.
        Total Number of Values which Compare Unequal: 0.
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 0

# a type difference within a Type family is listed but sets no bit [arrow]

    Code
      print(res)
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        4     2
          Compare     4     2
      
      Variables Summary
      
        Number of Variables in Common: 4.
        Number of Variables with Different Types in the Same Type Family: 2.
        Number of ID Variables: 1.
      
        Listing of Variables with Different Types in the Same Type Family
          Variable  Base     Compare
          n         integer  double
          s         factor   character
      
      Observation Summary
      
        Observations are matched on ID variables: id.
        Number of Observations in Common: 2.
        Total Number of Observations Read from Base: 2.
        Total Number of Observations Read from Compare: 2.
      
        Number of Observations with Some Compared Variables Unequal: 0.
        Number of Observations with All Compared Variables Equal: 2.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 3.
        Number of Variables Compared with Some Observations Unequal: 0.
        Total Number of Values which Compare Unequal: 0.
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 0

# a type difference within a Type family is listed but sets no bit [duckdb]

    Code
      print(res)
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        4     2
          Compare     4     2
      
      Variables Summary
      
        Number of Variables in Common: 4.
        Number of Variables with Different Types in the Same Type Family: 2.
        Number of ID Variables: 1.
      
        Listing of Variables with Different Types in the Same Type Family
          Variable  Base     Compare
          n         integer  double
          s         factor   character
      
      Observation Summary
      
        Observations are matched on ID variables: id.
        Number of Observations in Common: 2.
        Total Number of Observations Read from Base: 2.
        Total Number of Observations Read from Compare: 2.
      
        Number of Observations with Some Compared Variables Unequal: 0.
        Number of Observations with All Compared Variables Equal: 2.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 3.
        Number of Variables Compared with Some Observations Unequal: 0.
        Total Number of Values which Compare Unequal: 0.
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 0

# numeric against character is Conflicting types: listed, bit 8192, not value-compared [data_frame]

    Code
      print(res)
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        3     2
          Compare     3     2
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of Variables with Conflicting Types: 1.
        Number of ID Variables: 1.
      
        Listing of Variables with Conflicting Types
          Variable  Base              Compare
          x         double (numeric)  character (character)
      
      Observation Summary
      
        Observations are matched on ID variables: id.
        Number of Observations in Common: 2.
        Total Number of Observations Read from Base: 2.
        Total Number of Observations Read from Compare: 2.
      
        Number of Observations with Some Compared Variables Unequal: 1.
        Number of Observations with All Compared Variables Equal: 1.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 0.
        Number of Variables Compared with Some Observations Unequal: 1.
        Total Number of Values which Compare Unequal: 1.
        Maximum Difference: 1.
      
      Variables with Unequal Values
      
          Variable  Type     Ndif  MaxDif
          y         numeric     1       1
      
      Value Comparison Results for Variables
      
        _________________________________________________________
                   ||       Base    Compare
        id         ||          y          y      Diff.     % Diff
        _________  ||  _________  _________  _________  _________
                   ||
        2          ||          2          3          1         50
        _________________________________________________________
      
      Return code: 12288

# numeric against character is Conflicting types: listed, bit 8192, not value-compared [arrow]

    Code
      print(res)
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        3     2
          Compare     3     2
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of Variables with Conflicting Types: 1.
        Number of ID Variables: 1.
      
        Listing of Variables with Conflicting Types
          Variable  Base              Compare
          x         double (numeric)  character (character)
      
      Observation Summary
      
        Observations are matched on ID variables: id.
        Number of Observations in Common: 2.
        Total Number of Observations Read from Base: 2.
        Total Number of Observations Read from Compare: 2.
      
        Number of Observations with Some Compared Variables Unequal: 1.
        Number of Observations with All Compared Variables Equal: 1.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 0.
        Number of Variables Compared with Some Observations Unequal: 1.
        Total Number of Values which Compare Unequal: 1.
        Maximum Difference: 1.
      
      Variables with Unequal Values
      
          Variable  Type     Ndif  MaxDif
          y         numeric     1       1
      
      Value Comparison Results for Variables
      
        _________________________________________________________
                   ||       Base    Compare
        id         ||          y          y      Diff.     % Diff
        _________  ||  _________  _________  _________  _________
                   ||
        2          ||          2          3          1         50
        _________________________________________________________
      
      Return code: 12288

# numeric against character is Conflicting types: listed, bit 8192, not value-compared [duckdb]

    Code
      print(res)
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        3     2
          Compare     3     2
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of Variables with Conflicting Types: 1.
        Number of ID Variables: 1.
      
        Listing of Variables with Conflicting Types
          Variable  Base              Compare
          x         double (numeric)  character (character)
      
      Observation Summary
      
        Observations are matched on ID variables: id.
        Number of Observations in Common: 2.
        Total Number of Observations Read from Base: 2.
        Total Number of Observations Read from Compare: 2.
      
        Number of Observations with Some Compared Variables Unequal: 1.
        Number of Observations with All Compared Variables Equal: 1.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 0.
        Number of Variables Compared with Some Observations Unequal: 1.
        Total Number of Values which Compare Unequal: 1.
        Maximum Difference: 1.
      
      Variables with Unequal Values
      
          Variable  Type     Ndif  MaxDif
          y         numeric     1       1
      
      Value Comparison Results for Variables
      
        _________________________________________________________
                   ||       Base    Compare
        id         ||          y          y      Diff.     % Diff
        _________  ||  _________  _________  _________  _________
                   ||
        2          ||          2          3          1         50
        _________________________________________________________
      
      Return code: 12288

# date, datetime, numeric and character are four Type families [data_frame]

    Code
      print(res)
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        5     1
          Compare     5     1
      
      Variables Summary
      
        Number of Variables in Common: 5.
        Number of Variables with Conflicting Types: 4.
        Number of ID Variables: 1.
      
        Listing of Variables with Conflicting Types
          Variable  Base                Compare
          a         Date (date)         POSIXct (datetime)
          b         POSIXct (datetime)  double (numeric)
          c         Date (date)         character (character)
          d         POSIXct (datetime)  Date (date)
      
      Observation Summary
      
        Observations are matched on ID variables: id.
        Number of Observations in Common: 1.
        Total Number of Observations Read from Base: 1.
        Total Number of Observations Read from Compare: 1.
      
        Number of Observations with Some Compared Variables Unequal: 0.
        Number of Observations with All Compared Variables Equal: 1.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 0.
        Number of Variables Compared with Some Observations Unequal: 0.
        Total Number of Values which Compare Unequal: 0.
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 8192

# date, datetime, numeric and character are four Type families [arrow]

    Code
      print(res)
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        5     1
          Compare     5     1
      
      Variables Summary
      
        Number of Variables in Common: 5.
        Number of Variables with Conflicting Types: 4.
        Number of ID Variables: 1.
      
        Listing of Variables with Conflicting Types
          Variable  Base                Compare
          a         Date (date)         POSIXct (datetime)
          b         POSIXct (datetime)  double (numeric)
          c         Date (date)         character (character)
          d         POSIXct (datetime)  Date (date)
      
      Observation Summary
      
        Observations are matched on ID variables: id.
        Number of Observations in Common: 1.
        Total Number of Observations Read from Base: 1.
        Total Number of Observations Read from Compare: 1.
      
        Number of Observations with Some Compared Variables Unequal: 0.
        Number of Observations with All Compared Variables Equal: 1.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 0.
        Number of Variables Compared with Some Observations Unequal: 0.
        Total Number of Values which Compare Unequal: 0.
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 8192

# date, datetime, numeric and character are four Type families [duckdb]

    Code
      print(res)
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        5     1
          Compare     5     1
      
      Variables Summary
      
        Number of Variables in Common: 5.
        Number of Variables with Conflicting Types: 4.
        Number of ID Variables: 1.
      
        Listing of Variables with Conflicting Types
          Variable  Base                Compare
          a         Date (date)         POSIXct (datetime)
          b         POSIXct (datetime)  double (numeric)
          c         Date (date)         character (character)
          d         POSIXct (datetime)  Date (date)
      
      Observation Summary
      
        Observations are matched on ID variables: id.
        Number of Observations in Common: 1.
        Total Number of Observations Read from Base: 1.
        Total Number of Observations Read from Compare: 1.
      
        Number of Observations with Some Compared Variables Unequal: 0.
        Number of Observations with All Compared Variables Equal: 1.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 0.
        Number of Variables Compared with Some Observations Unequal: 0.
        Total Number of Values which Compare Unequal: 0.
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 8192

# an unknown Comparison method is an error [data_frame]

    Code
      df_compare(as_backend(df), as_backend(df), id = "id", method = "absolut")
    Condition
      Error in `df_compare()`:
      ! `method` must be one of "exact", "absolute", "relative", or "percent", not "absolut".
      i Did you mean "absolute"?

# an unknown Comparison method is an error [arrow]

    Code
      df_compare(as_backend(df), as_backend(df), id = "id", method = "absolut")
    Condition
      Error in `df_compare()`:
      ! `method` must be one of "exact", "absolute", "relative", or "percent", not "absolut".
      i Did you mean "absolute"?

# an unknown Comparison method is an error [duckdb]

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

# an invalid Criterion or relative_delta is an error [arrow]

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

# an invalid Criterion or relative_delta is an error [duckdb]

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

# ignore_trailing_blanks must be TRUE or FALSE [data_frame]

    Code
      df_compare(as_backend(df), as_backend(df), id = "id", ignore_trailing_blanks = NA)
    Condition
      Error in `df_compare()`:
      ! `ignore_trailing_blanks` must be `TRUE` or `FALSE`, not `NA`.

# ignore_trailing_blanks must be TRUE or FALSE [arrow]

    Code
      df_compare(as_backend(df), as_backend(df), id = "id", ignore_trailing_blanks = NA)
    Condition
      Error in `df_compare()`:
      ! `ignore_trailing_blanks` must be `TRUE` or `FALSE`, not `NA`.

# ignore_trailing_blanks must be TRUE or FALSE [duckdb]

    Code
      df_compare(as_backend(df), as_backend(df), id = "id", ignore_trailing_blanks = NA)
    Condition
      Error in `df_compare()`:
      ! `ignore_trailing_blanks` must be `TRUE` or `FALSE`, not `NA`.

