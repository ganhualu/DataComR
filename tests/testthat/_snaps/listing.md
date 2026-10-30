# max_print must be a positive whole number [data_frame]

    Code
      df_compare(as_backend(base), as_backend(base), id = "usubjid", max_print = 0)
    Condition
      Error in `df_compare()`:
      ! `max_print` must be a positive whole number, not 0.

# max_print must be a positive whole number [arrow]

    Code
      df_compare(as_backend(base), as_backend(base), id = "usubjid", max_print = 0)
    Condition
      Error in `df_compare()`:
      ! `max_print` must be a positive whole number, not 0.

# max_print must be a positive whole number [duckdb]

    Code
      df_compare(as_backend(base), as_backend(base), id = "usubjid", max_print = 0)
    Condition
      Error in `df_compare()`:
      ! `max_print` must be a positive whole number, not 0.

# the Listing of fully equal datasets [data_frame]

    Code
      print(df_compare(as_backend(base), as_backend(base), id = "usubjid"))
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        3     4
          Compare     3     4
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of ID Variables: 1.
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid.
        Number of Observations in Common: 4.
        Total Number of Observations Read from Base: 4.
        Total Number of Observations Read from Compare: 4.
      
        Number of Observations with Some Compared Variables Unequal: 0.
        Number of Observations with All Compared Variables Equal: 4.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 2.
        Number of Variables Compared with Some Observations Unequal: 0.
        Total Number of Values which Compare Unequal: 0.
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 0

# the Listing of fully equal datasets [arrow]

    Code
      print(df_compare(as_backend(base), as_backend(base), id = "usubjid"))
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        3     4
          Compare     3     4
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of ID Variables: 1.
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid.
        Number of Observations in Common: 4.
        Total Number of Observations Read from Base: 4.
        Total Number of Observations Read from Compare: 4.
      
        Number of Observations with Some Compared Variables Unequal: 0.
        Number of Observations with All Compared Variables Equal: 4.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 2.
        Number of Variables Compared with Some Observations Unequal: 0.
        Total Number of Values which Compare Unequal: 0.
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 0

# the Listing of fully equal datasets [duckdb]

    Code
      print(df_compare(as_backend(base), as_backend(base), id = "usubjid"))
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        3     4
          Compare     3     4
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of ID Variables: 1.
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid.
        Number of Observations in Common: 4.
        Total Number of Observations Read from Base: 4.
        Total Number of Observations Read from Compare: 4.
      
        Number of Observations with Some Compared Variables Unequal: 0.
        Number of Observations with All Compared Variables Equal: 4.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 2.
        Number of Variables Compared with Some Observations Unequal: 0.
        Total Number of Values which Compare Unequal: 0.
      
      NOTE: No unequal values were found. All values compared are exactly equal.
      
      Return code: 0

# the Listing of datasets with Unequal values only [data_frame]

    Code
      print(df_compare(as_backend(base), as_backend(compare), id = "usubjid"))
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        3     4
          Compare     3     4
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of ID Variables: 1.
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid.
        Number of Observations in Common: 4.
        Total Number of Observations Read from Base: 4.
        Total Number of Observations Read from Compare: 4.
      
        Number of Observations with Some Compared Variables Unequal: 2.
        Number of Observations with All Compared Variables Equal: 2.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 0.
        Number of Variables Compared with Some Observations Unequal: 2.
        Total Number of Values which Compare Unequal: 2.
        Maximum Difference: 1.
      
      Variables with Unequal Values
      
          Variable  Type       Ndif  MaxDif
          aval      numeric       1       1
          avalc     character     1
      
      Value Comparison Results for Variables
      
        _________________________________________________________
                   ||       Base    Compare
        usubjid    ||       aval       aval      Diff.     % Diff
        _________  ||  _________  _________  _________  _________
                   ||
        02         ||         20         21          1          5
        _________________________________________________________
      
        ___________________________________
                   ||       Base    Compare
        usubjid    ||      avalc      avalc
        _________  ||  _________  _________
                   ||
        04         ||  d          z
        ___________________________________
      
      Return code: 4096

# the Listing of datasets with Unequal values only [arrow]

    Code
      print(df_compare(as_backend(base), as_backend(compare), id = "usubjid"))
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        3     4
          Compare     3     4
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of ID Variables: 1.
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid.
        Number of Observations in Common: 4.
        Total Number of Observations Read from Base: 4.
        Total Number of Observations Read from Compare: 4.
      
        Number of Observations with Some Compared Variables Unequal: 2.
        Number of Observations with All Compared Variables Equal: 2.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 0.
        Number of Variables Compared with Some Observations Unequal: 2.
        Total Number of Values which Compare Unequal: 2.
        Maximum Difference: 1.
      
      Variables with Unequal Values
      
          Variable  Type       Ndif  MaxDif
          aval      numeric       1       1
          avalc     character     1
      
      Value Comparison Results for Variables
      
        _________________________________________________________
                   ||       Base    Compare
        usubjid    ||       aval       aval      Diff.     % Diff
        _________  ||  _________  _________  _________  _________
                   ||
        02         ||         20         21          1          5
        _________________________________________________________
      
        ___________________________________
                   ||       Base    Compare
        usubjid    ||      avalc      avalc
        _________  ||  _________  _________
                   ||
        04         ||  d          z
        ___________________________________
      
      Return code: 4096

# the Listing of datasets with Unequal values only [duckdb]

    Code
      print(df_compare(as_backend(base), as_backend(compare), id = "usubjid"))
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        3     4
          Compare     3     4
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of ID Variables: 1.
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid.
        Number of Observations in Common: 4.
        Total Number of Observations Read from Base: 4.
        Total Number of Observations Read from Compare: 4.
      
        Number of Observations with Some Compared Variables Unequal: 2.
        Number of Observations with All Compared Variables Equal: 2.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 0.
        Number of Variables Compared with Some Observations Unequal: 2.
        Total Number of Values which Compare Unequal: 2.
        Maximum Difference: 1.
      
      Variables with Unequal Values
      
          Variable  Type       Ndif  MaxDif
          aval      numeric       1       1
          avalc     character     1
      
      Value Comparison Results for Variables
      
        _________________________________________________________
                   ||       Base    Compare
        usubjid    ||       aval       aval      Diff.     % Diff
        _________  ||  _________  _________  _________  _________
                   ||
        02         ||         20         21          1          5
        _________________________________________________________
      
        ___________________________________
                   ||       Base    Compare
        usubjid    ||      avalc      avalc
        _________  ||  _________  _________
                   ||
        04         ||  d          z
        ___________________________________
      
      Return code: 4096

# the Listing with every summary section populated [data_frame]

    Code
      print(df_compare(as_backend(base_all), as_backend(compare), id = "usubjid"))
    Condition
      Warning in `df_compare()`:
      Duplicate IDs found; their observations are not paired or compared.
      * Base dataset: 1 Duplicate ID.
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        6     5  Base data
          Compare     6     4
      
      Variables Summary
      
        Number of Variables in Common: 5.
        Number of Variables in Base but not in Compare: 1.
        Number of Variables in Compare but not in Base: 1.
        Number of Variables with Conflicting Types: 1.
        Number of Variables with Different Types in the Same Type Family: 1.
        Number of Variables with Differing Attributes: 1.
        Number of ID Variables: 1.
      
        Listing of Variables in Base but not in Compare
          only_b
      
        Listing of Variables in Compare but not in Base
          only_c
      
        Listing of Variables with Conflicting Types
          Variable  Base                   Compare
          kind      character (character)  double (numeric)
      
        Listing of Variables with Different Types in the Same Type Family
          Variable  Base     Compare
          n         integer  double
      
        Listing of Common Variables with Differing Attributes
          Variable  Attribute  Base            Compare
          aval      label      Analysis value  AVAL
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid.
        Number of Observations in Common: 3.
        Number of Observations in Compare but not in Base: 1.
        Number of Duplicate IDs (not compared): 1.
        Total Number of Observations Read from Base: 5.
        Total Number of Observations Read from Compare: 4.
      
        Number of Observations with Some Compared Variables Unequal: 1.
        Number of Observations with All Compared Variables Equal: 2.
      
        Listing of Duplicate IDs
          Dataset  usubjid  Observations
          Base     04                  2
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 2.
        Number of Variables Compared with Some Observations Unequal: 1.
        Total Number of Values which Compare Unequal: 1.
        Maximum Difference: 0.5.
      
      Variables with Unequal Values
      
          Variable  Type     Ndif  MaxDif
          aval      numeric     1     0.5
      
      Value Comparison Results for Variables
      
        _________________________________________________________
                   ||       Base    Compare
        usubjid    ||       aval       aval      Diff.     % Diff
        _________  ||  _________  _________  _________  _________
                   ||
        01         ||         10       10.5        0.5          5
        _________________________________________________________
      
      Return code: 81057

# the Listing with every summary section populated [arrow]

    Code
      print(df_compare(as_backend(base_all), as_backend(compare), id = "usubjid"))
    Condition
      Warning in `df_compare()`:
      Duplicate IDs found; their observations are not paired or compared.
      * Base dataset: 1 Duplicate ID.
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        6     5  Base data
          Compare     6     4
      
      Variables Summary
      
        Number of Variables in Common: 5.
        Number of Variables in Base but not in Compare: 1.
        Number of Variables in Compare but not in Base: 1.
        Number of Variables with Conflicting Types: 1.
        Number of Variables with Different Types in the Same Type Family: 1.
        Number of Variables with Differing Attributes: 1.
        Number of ID Variables: 1.
      
        Listing of Variables in Base but not in Compare
          only_b
      
        Listing of Variables in Compare but not in Base
          only_c
      
        Listing of Variables with Conflicting Types
          Variable  Base                   Compare
          kind      character (character)  double (numeric)
      
        Listing of Variables with Different Types in the Same Type Family
          Variable  Base     Compare
          n         integer  double
      
        Listing of Common Variables with Differing Attributes
          Variable  Attribute  Base            Compare
          aval      label      Analysis value  AVAL
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid.
        Number of Observations in Common: 3.
        Number of Observations in Compare but not in Base: 1.
        Number of Duplicate IDs (not compared): 1.
        Total Number of Observations Read from Base: 5.
        Total Number of Observations Read from Compare: 4.
      
        Number of Observations with Some Compared Variables Unequal: 1.
        Number of Observations with All Compared Variables Equal: 2.
      
        Listing of Duplicate IDs
          Dataset  usubjid  Observations
          Base     04                  2
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 2.
        Number of Variables Compared with Some Observations Unequal: 1.
        Total Number of Values which Compare Unequal: 1.
        Maximum Difference: 0.5.
      
      Variables with Unequal Values
      
          Variable  Type     Ndif  MaxDif
          aval      numeric     1     0.5
      
      Value Comparison Results for Variables
      
        _________________________________________________________
                   ||       Base    Compare
        usubjid    ||       aval       aval      Diff.     % Diff
        _________  ||  _________  _________  _________  _________
                   ||
        01         ||         10       10.5        0.5          5
        _________________________________________________________
      
      Return code: 81057

# the Listing when max_print truncates the Value Comparison Results

    Code
      print(df_compare(base, compare, id = "usubjid", max_print = 2))
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        3     4
          Compare     3     4
      
      Variables Summary
      
        Number of Variables in Common: 3.
        Number of ID Variables: 1.
      
      Observation Summary
      
        Observations are matched on ID variables: usubjid.
        Number of Observations in Common: 4.
        Total Number of Observations Read from Base: 4.
        Total Number of Observations Read from Compare: 4.
      
        Number of Observations with Some Compared Variables Unequal: 4.
        Number of Observations with All Compared Variables Equal: 0.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 1.
        Number of Variables Compared with Some Observations Unequal: 1.
        Total Number of Values which Compare Unequal: 4.
        Maximum Difference: 1.
      
      Variables with Unequal Values
      
          Variable  Type     Ndif  MaxDif
          aval      numeric     4       1
      
      Value Comparison Results for Variables
      
        _________________________________________________________
                   ||       Base    Compare
        usubjid    ||       aval       aval      Diff.     % Diff
        _________  ||  _________  _________  _________  _________
                   ||
        01         ||         10         11          1         10
        02         ||         20         21          1          5
        _________________________________________________________
      NOTE: The MAXPRINT=2 printing limit has been reached for the variable aval. No more values will be printed for this comparison.
      
      Return code: 4096

# the Listing of a positional comparison names the observation number

    Code
      print(df_compare(base, compare))
    Output
      -- The COMPARE Procedure -------------------------------------------------------
      Comparison of Base with Compare
      (Method=EXACT)
      
      Data Set Summary
      
          Dataset  NVar  NObs  Label
          Base        3     4
          Compare     3     3
      
      Variables Summary
      
        Number of Variables in Common: 3.
      
      Observation Summary
      
        Observations are matched by position.
        Number of Observations in Common: 3.
        Number of Observations in Base but not in Compare: 1.
        Total Number of Observations Read from Base: 4.
        Total Number of Observations Read from Compare: 3.
      
        Number of Observations with Some Compared Variables Unequal: 1.
        Number of Observations with All Compared Variables Equal: 2.
      
      Values Comparison Summary
      
        Number of Variables Compared with All Observations Equal: 2.
        Number of Variables Compared with Some Observations Unequal: 1.
        Total Number of Values which Compare Unequal: 1.
        Maximum Difference: 3.
      
      Variables with Unequal Values
      
          Variable  Type     Ndif  MaxDif
          aval      numeric     1       3
      
      Value Comparison Results for Variables
      
        _________________________________________________________
                   ||       Base    Compare
        obs        ||       aval       aval      Diff.     % Diff
        _________  ||  _________  _________  _________  _________
                   ||
        3          ||         30         33          3         10
        _________________________________________________________
      
      Return code: 4160

