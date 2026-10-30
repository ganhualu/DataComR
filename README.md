# DataComR

<!-- badges: start -->
[![R-CMD-check](https://github.com/ganhualu/DataComR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ganhualu/DataComR/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

DataComR compares a Base dataset with a Compare dataset the way SAS PROC COMPARE does. It gives users familiar with SAS PROC COMPARE a similar tool in R: the same concepts, the same comparison rules, a Listing laid out like the SAS one, and a Return code with the same bits as `SYSINFO`.

- Observations paired by **ID variables** (no sorting needed), or **by position** when there are none.
- SAS's comparison **methods** (`exact`, `absolute`, `relative`, `percent`) and **criterion**.
- **`var` and `with`** to choose and pair variables; opt-in `ignore_case`.
- SAS-like **type families**, **missing values** (including special missings) and **trailing blanks**.
- **Attribute differences**: labels, SAS formats and widths, as read by haven.
- A **PROC COMPARE-style Listing**, every Unequal value as a tibble, and a **`SYSINFO`-style Return code**.
- **Data frames, arrow and duckdb**: with arrow or duckdb the comparison runs inside the backend, so large datasets never have to fit in memory.

## Installation

```r
# install.packages("pak")
pak::pak("ganhualu/DataComR")
```

## Example

```r
library(DataComR)

base <- data.frame(
  subject = c("A", "A", "B", "C"),
  visit = c(1, 2, 1, 1),
  weight = c(70.5, 71, 82, 64.2),
  group = c("x", "x", "y", "z")
)
compare <- data.frame(
  subject = c("A", "A", "B", "D"),
  visit = c(1, 2, 1, 1),
  weight = c(70.5, 71.5, 82, 58),
  group = c("x", "x", "w", "z")
)

comparison <- df_compare(base, compare, id = c("subject", "visit"))
comparison
#> ── The COMPARE Procedure ───────────────────────────────────────────────────────
#> Comparison of Base with Compare
#> (Method=EXACT)
#> 
#> Data Set Summary
#> 
#>     Dataset  NVar  NObs  Label
#>     Base        4     4
#>     Compare     4     4
#> 
#> Variables Summary
#> 
#>   Number of Variables in Common: 4.
#>   Number of ID Variables: 2.
#> 
#> Observation Summary
#> 
#>   Observations are matched on ID variables: subject, visit.
#>   Number of Observations in Common: 3.
#>   Number of Observations in Base but not in Compare: 1.
#>   Number of Observations in Compare but not in Base: 1.
#>   Total Number of Observations Read from Base: 4.
#>   Total Number of Observations Read from Compare: 4.
#> 
#>   Number of Observations with Some Compared Variables Unequal: 2.
#>   Number of Observations with All Compared Variables Equal: 1.
#> 
#> Values Comparison Summary
#> 
#>   Number of Variables Compared with All Observations Equal: 0.
#>   Number of Variables Compared with Some Observations Unequal: 2.
#>   Total Number of Values which Compare Unequal: 2.
#>   Maximum Difference: 0.5.
#> 
#> Variables with Unequal Values
#> 
#>     Variable  Type       Ndif  MaxDif
#>     weight    numeric       1     0.5
#>     group     character     1
#> 
#> Value Comparison Results for Variables
#> 
#>   ____________________________________________________________________
#>                         ||       Base    Compare
#>   subject    visit      ||     weight     weight      Diff.     % Diff
#>   _________  _________  ||  _________  _________  _________  _________
#>                         ||
#>   A          2          ||         71       71.5        0.5   0.704225
#>   ____________________________________________________________________
#> 
#>   ______________________________________________
#>                         ||       Base    Compare
#>   subject    visit      ||      group      group
#>   _________  _________  ||  _________  _________
#>                         ||
#>   B          1          ||  y          w
#>   ______________________________________________
#> 
#> Return code: 4288
```

The results are also available as data:

```r
differences(comparison)
#> # A tibble: 2 × 7
#>   subject visit variable base  compare  diff pct_diff
#>   <chr>   <dbl> <chr>    <chr> <chr>   <dbl>    <dbl>
#> 1 A           2 weight   71    71.5      0.5    0.704
#> 2 B           1 group    y     w        NA     NA
unmatched_rows(comparison)
#> # A tibble: 2 × 3
#>   subject visit dataset
#>   <chr>   <dbl> <chr>  
#> 1 C           1 Base   
#> 2 D           1 Compare
return_code(comparison)
#> [1] 4288
```

## From PROC COMPARE to `df_compare()`

| PROC COMPARE                    | DataComR                                    |
|---------------------------------|---------------------------------------------|
| `BASE=`, `COMPARE=`             | `base`, `compare`                           |
| `ID` statement                  | `id` (`NULL` matches by position)           |
| `VAR`, `WITH` statements        | `var`, `with`                               |
| `METHOD=`, `CRITERION=`         | `method`, `criterion`                       |
| `MAXPRINT=`                     | `max_print`                                 |
| the Listing                     | `print()`                                   |
| `OUT=` differences              | `differences()`, `unmatched_rows()`         |
| `&SYSINFO`                      | `return_code()`                             |

See `vignette("DataComR")` for the full guide, including the Return code bits and where DataComR deliberately differs from PROC COMPARE. One difference to know up front: variable names are **case-sensitive** by default, as R's are; set `ignore_case = TRUE` to match names regardless of case, as SAS does.

## Status

DataComR is in early development; its interface may still change.

## Acknowledgements

DataComR is developed with assistance from Claude Code (Anthropic).
