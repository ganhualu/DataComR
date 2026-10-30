# Compare two datasets the way PROC COMPARE does

Each common variable belongs to a Type family: numeric (integer, double,
logical), character (character, factor compared by labels), date or
datetime (compared as instants, whatever the time zone). Variables of
different families are Conflicting types and their values are not
compared. The Comparison method and Criterion apply to the numeric
family only; other families are compared exactly.

## Usage

``` r
df_compare(
  base,
  compare,
  id = NULL,
  var = NULL,
  with = NULL,
  method = "exact",
  criterion = 1e-05,
  relative_delta = 0,
  ignore_trailing_blanks = TRUE,
  ignore_case = FALSE,
  max_print = 50
)
```

## Arguments

- base:

  The Base dataset: the reference the comparison reports against. A data
  frame (including tibbles), an arrow Table or Dataset, or a duckdb
  table (a dbplyr lazy table on a duckdb connection).

- compare:

  The Compare dataset, checked against `base`. Any of the types accepted
  for `base`, in any combination with it.

- id:

  Character vector of ID variables used to pair observations, or `NULL`
  (the default) to match observations by position, as SAS does without
  an `ID` statement: the first Base observation with the first Compare
  observation, and so on. The extra observations of the longer dataset
  are then Unmatched observations, and
  [`differences()`](https://ganhualu.github.io/DataComR/reference/differences.md)
  and
  [`unmatched_rows()`](https://ganhualu.github.io/DataComR/reference/unmatched_rows.md)
  identify observations by an `obs` column holding the observation
  number. Matching by position needs in-memory data frames, since the
  observation order of arrow and duckdb data is not guaranteed; for
  those, `id` is required.

- var:

  Character vector of Base variables whose values are compared, as SAS's
  `VAR` statement; `NULL` (the default) compares every common variable.
  Each must be in both datasets, unless `with` names its Compare
  variable. `var` and `with` must not name ID variables, whose values
  are equal in every Matched observation by construction. See the
  Variable pairing section.

- with:

  Character vector of Compare variables, as SAS's `WITH` statement: the
  same length as `var`, each paired by position with the `var` variable
  it is compared with. Results report the Base name.

- method:

  The Comparison method for numeric variables: `"exact"`, `"absolute"`,
  `"relative"` or `"percent"`, as SAS's `METHOD=`.

- criterion:

  The Criterion the method tests differences against, as SAS's
  `CRITERION=`.

- relative_delta:

  The constant δ that `method = "relative"` adds to the denominator, as
  in SAS's `METHOD=RELATIVE(δ)`: a number between 0 and 1, 0 by default
  as in SAS.

- ignore_trailing_blanks:

  If `TRUE` (the default), character values that differ only in trailing
  blanks are equal, as in SAS. Leading blanks always count.

- ignore_case:

  If `FALSE` (the default), variable names are matched exactly, so
  `USUBJID` and `usubjid` are different variables. If `TRUE`, names that
  differ only in case are paired; see the Variable pairing section.

- max_print:

  The most Unequal values the Listing shows per variable, as SAS's
  `MAXPRINT=`; the Listing notes when a variable has more.
  [`differences()`](https://ganhualu.github.io/DataComR/reference/differences.md)
  always returns all of them.

## Value

A `df_compare` object.

## Details

Two missing values are equal and `NaN` counts as missing. Special
missings (haven's tagged NAs, SAS's `.A` to `.Z`) are equal only with
the same letter; this rule needs in-memory data frames, since arrow and
duckdb do not keep the tags.

## Variable pairing

A Base variable is paired with the Compare variable of the same name.
Names are case-sensitive by default, unlike in SAS, so that `a` and `A`
are never silently treated as one variable. With `ignore_case = TRUE`,
names that differ only in case are paired instead, and `id`, `var` and
`with` may be written in either dataset's case; results and the Listing
always use the Base names. It is an error when two names in one dataset
differ only in case, since the pairing would then be ambiguous.

As with SAS's `VAR` statement, `var` restricts only the comparison of
values: Unequal values are reported for the `var` variables alone, while
the Variables Summary (variables in only one dataset, Conflicting types,
Attribute differences) still covers every variable, and so does the
Return code. A Base variable paired by `with` is not a variable in only
one dataset, and neither is its Compare variable; its Attribute
differences are reported under the Base name.

## Backends

The comparison runs as dplyr verbs inside the datasets' own backend;
only observation counts and Unequal values are collected into R, never
the full datasets. When the two datasets live in different backends they
are brought into one without collecting them:

- a data frame compared with a duckdb table is registered in the duckdb
  connection as a view;

- a data frame compared with arrow data is converted to an arrow Table;

- arrow data compared with a duckdb table is registered in the duckdb
  connection through arrow's zero-copy interface.

Two duckdb tables must share one connection. arrow, duckdb, dbplyr and
DBI are optional; an informative error names any that an input needs but
that is not installed.

Special missings that a backend does not preserve (for example haven
tagged `NA`s in a duckdb table) are treated as absent for that dataset;
for attributes, see the Attribute differences section.

## Attribute differences

As PROC COMPARE does, `df_compare()` compares metadata as well as
values. For each common variable and each `with` pair, ID variables
included, the `label`, `format.sas` and `width` attributes (as set by
haven when reading SAS files) are compared, and so is the data frame's
own `label` attribute (the dataset label). An attribute present on only
one side is an Attribute difference; one absent on both sides is
ignored. Attribute differences are shown in the Listing's Variables
Summary (dataset labels in its Dataset Summary) and set Return code bits
1 (dataset label), 8 (format), 16 (width) and 32 (variable label). They
are never Unequal values: they don't appear in
[`differences()`](https://ganhualu.github.io/DataComR/reference/differences.md)
and never set bit 4096.

Attributes are R metadata, so they are only as complete as the backend
keeps them. Data frames (including tibbles read with haven) keep them.
Arrow data keeps the R attributes it was created with, stored in its
metadata; arrow data written outside R has none, so it is treated as
having no attributes. Lazy database tables, such as duckdb tables, carry
no R attributes at all: when either dataset is one, no attributes are
compared and no Attribute differences are reported, rather than
reporting false ones.
