# Unmatched observations found by a comparison

Unmatched observations found by a comparison

## Usage

``` r
unmatched_rows(x)
```

## Arguments

- x:

  A `df_compare` object.

## Value

A tibble with the ID variables of each Unmatched observation and a
`dataset` column, `"Base"` or `"Compare"`, naming the only dataset it is
in. Sorted by `dataset`, then by ID variables. ID values that are a
Duplicate ID in either dataset are never Unmatched observations; the
Listing reports them as Duplicate IDs instead. When observations were
matched by position (no `id`), an `obs` column with the observation
number takes the place of the ID variables.
