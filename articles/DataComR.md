# DataComR for PROC COMPARE users

DataComR compares a **Base dataset** with a **Compare dataset** the way
SAS PROC COMPARE does. If you know PROC COMPARE, you already know most
of DataComR: the same concepts, the same comparison rules, a Listing
laid out like the SAS one, and a Return code with the same bits as
`SYSINFO`.

``` r

library(DataComR)
```

## A first comparison

In SAS you would write:

``` sas
proc compare base=base compare=compare;
  id subject visit;
run;
```

In R:

``` r

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

Printing the result gives the Listing. The same information is available
as data:

``` r

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

[`differences()`](https://ganhualu.github.io/DataComR/reference/differences.md)
has one row per Unequal value. `base` and `compare` are character, so
values of every type fit in one table, and numbers are shown at full
precision: two values that compare unequal never look the same. For
numeric variables, `diff` is Compare minus Base and `pct_diff` is `diff`
as a percentage of the Base value.

## From PROC COMPARE to `df_compare()`

| PROC COMPARE | DataComR |
|----|----|
| `BASE=` | `base` |
| `COMPARE=` | `compare` |
| `ID` statement | `id` |
| no `ID` statement (by position) | `id = NULL` (data frames only) |
| `VAR` statement | `var` |
| `WITH` statement | `with` |
| `METHOD=` | `method`: `"exact"`, `"absolute"`, `"relative"`, `"percent"` |
| `METHOD=RELATIVE(δ)` | `method = "relative", relative_delta = δ` |
| `CRITERION=` | `criterion` (default `1e-5`) |
| `MAXPRINT=` | `max_print` (default 50, per variable) |
| the Listing | [`print()`](https://rdrr.io/r/base/print.html) |
| `OUT=` differences | [`differences()`](https://ganhualu.github.io/DataComR/reference/differences.md) |
| `&SYSINFO` | [`return_code()`](https://ganhualu.github.io/DataComR/reference/return_code.md) |

## The Return code

[`return_code()`](https://ganhualu.github.io/DataComR/reference/return_code.md)
returns an integer whose bits flag each kind of difference, with the
same values as SAS’s `SYSINFO`, so checks written for SAS carry over. 0
means the datasets are fully equal.

|   Bit | Meaning                              |
|------:|--------------------------------------|
|     1 | Dataset labels differ                |
|     8 | Variable formats differ              |
|    16 | Variable widths differ               |
|    32 | Variable labels differ               |
|    64 | Base has observations not in Compare |
|   128 | Compare has observations not in Base |
|  1024 | Base has variables not in Compare    |
|  2048 | Compare has variables not in Base    |
|  4096 | A value compares unequal             |
|  8192 | Conflicting types                    |
| 65536 | Duplicate IDs (DataComR only)        |

SAS bits that have no meaning in R (dataset type, informat, BY groups)
are never set. Test a single condition with
[`bitwAnd()`](https://rdrr.io/r/base/bitwise.html):

``` r

bitwAnd(return_code(comparison), 4096) > 0
#> [1] TRUE
```

## Matching observations

With `id`, observations are paired on their ID values; neither dataset
needs to be sorted first. Without `id`, observations are paired by
position, as SAS does without an `ID` statement, and results identify
observations by an `obs` column:

``` r

differences(df_compare(base, compare))
#> # A tibble: 4 × 6
#>     obs variable base  compare  diff pct_diff
#>   <int> <chr>    <chr> <chr>   <dbl>    <dbl>
#> 1     4 subject  C     D        NA     NA    
#> 2     2 weight   71    71.5      0.5    0.704
#> 3     4 weight   64.2  58       -6.2   -9.66 
#> 4     3 group    y     w        NA     NA
```

An ID value shared by more than one observation in a dataset is a
Duplicate ID. SAS pairs duplicates in the order they appear; DataComR
warns, lists them in the Listing, sets bit 65536, and leaves them out of
the comparison, so they are never paired arbitrarily.

## Comparing values

### Comparison methods

`method` and `criterion` follow SAS’s formulas, with `b` the Base value
and `c` the Compare value:

- `"exact"` (the default): `b == c`
- `"absolute"`: `|b - c| <= criterion`
- `"relative"`:
  `|b - c| / ((|b| + |c|) / 2 + relative_delta) <= criterion`
- `"percent"`: `100 * |b - c| / |b| <= criterion`

They apply to numeric variables only. A value computed in R, such as
`0.1 + 0.2`, fails the exact comparison against a stored `0.3`; a small
criterion accepts it:

``` r

b <- data.frame(id = 1, x = 0.1 + 0.2)
c <- data.frame(id = 1, x = 0.3)
return_code(df_compare(b, c, id = "id"))
#> [1] 4096
return_code(df_compare(b, c, id = "id", method = "absolute", criterion = 1e-9))
#> [1] 0
```

### Type families

SAS has numeric and character variables; R has many more types. DataComR
groups them into SAS-like Type families:

- **numeric**: integer, double and logical, so `1L` equals `1`;
- **character**: character and factor, compared by their labels;
- **date**: compared exactly, never with a criterion;
- **datetime**: compared as instants, so the same moment in two time
  zones is equal.

A type difference within a family (integer against double) is listed in
the Listing but sets no bit. Variables from different families have
Conflicting types: they are listed, set bit 8192, and their values are
not compared.

### Missing values and blanks

- Missing equals missing; `NaN` counts as missing.
- Special missings (haven’s tagged `NA`s, SAS’s `.A` to `.Z`) are equal
  only when they carry the same letter.
- A missing value against a non-missing value is unequal.
- Trailing blanks are ignored in character values, as SAS pads them; set
  `ignore_trailing_blanks = FALSE` to compare them. Leading blanks
  always count.

## Choosing variables

`var` restricts which variables have their values compared; `with` pairs
each `var` variable with a differently named Compare variable:

``` r

renamed <- compare
names(renamed)[names(renamed) == "weight"] <- "wt"
differences(df_compare(
  base, renamed,
  id = c("subject", "visit"), var = "weight", with = "wt"
))
#> # A tibble: 1 × 7
#>   subject visit variable base  compare  diff pct_diff
#>   <chr>   <dbl> <chr>    <chr> <chr>   <dbl>    <dbl>
#> 1 A           2 weight   71    71.5      0.5    0.704
```

As in SAS, `var` limits only the value comparison: variables found in
only one dataset, Conflicting types and Attribute differences are still
reported.

## Labels, formats and widths

Like PROC COMPARE, DataComR compares metadata as well as values. The
`label`, `format.sas` and `width` attributes that haven sets when it
reads SAS files, and the dataset label, are compared and reported as
Attribute differences. They set their own Return code bits and never
count as Unequal values.

``` r

labelled <- base
attr(labelled$weight, "label") <- "Weight (kg)"
attr(labelled$weight, "format.sas") <- "8.1"
relabelled <- base
attr(relabelled$weight, "label") <- "Body weight"
attr(relabelled$weight, "format.sas") <- "8.1"

return_code(df_compare(labelled, relabelled, id = c("subject", "visit")))
#> [1] 32
```

## Large data: arrow and duckdb

`base` and `compare` can also be arrow Tables or Datasets, or duckdb
tables, in any combination with data frames. The comparison then runs
inside arrow or duckdb, and only counts and Unequal values are brought
into R, so datasets larger than memory can be compared:

``` r

con <- DBI::dbConnect(duckdb::duckdb())
#> duckdb keeps downloaded extensions and secrets in a temporary directory:
#> ℹ /tmp/Rtmpi9028t/duckdb
#> This is removed when the R session ends.
#> • Extensions are re-downloaded each session.
#> • Secrets are lost.
#> ℹ Run duckdb(shared_home = TRUE) (or create ~/.duckdb) to keep them (suitable for most users).
#> ℹ Run duckdb(shared_home = FALSE) to accept the temporary directory (and silence this message).
#> ℹ See ?duckdb_storage for details and alternatives.
base_db <- dplyr::copy_to(con, base, "base")

differences(df_compare(base_db, compare, id = c("subject", "visit")))
#> # A tibble: 2 × 7
#>   subject visit variable base  compare  diff pct_diff
#>   <chr>   <dbl> <chr>    <chr> <chr>   <dbl>    <dbl>
#> 1 A           2 weight   71    71.5      0.5    0.704
#> 2 B           1 group    y     w        NA     NA

DBI::dbDisconnect(con, shutdown = TRUE)
```

arrow and duckdb are optional; install them only if you need them.
Matching by position needs data frames, because the order of rows in
arrow and duckdb isn’t guaranteed, and duckdb tables carry no R
attributes, so no Attribute differences are reported for them.

## Where DataComR differs from PROC COMPARE

- **Variable names are case-sensitive**, as R’s are: `USUBJID` and
  `usubjid` are different variables. Set `ignore_case = TRUE` to match
  names regardless of case, as SAS does.
- **Duplicate IDs are not paired** (see above), and set their own bit.
- **A negative `criterion` is an error**; SAS reads it as a multiple of
  machine precision.
- **Mismatched `var` and `with`** (different lengths, or a `var`
  variable missing from the Compare dataset) are errors rather than
  warnings.
- **Not supported**: BY groups, comparing variables within a single
  dataset, and `OUT=`/`OUTSTATS=` datasets (use
  [`differences()`](https://ganhualu.github.io/DataComR/reference/differences.md)
  instead).
