# Unequal values found by a comparison

Unequal values found by a comparison

## Usage

``` r
differences(x)
```

## Arguments

- x:

  A `df_compare` object.

## Value

A tibble with one row per Unequal value: the ID variables, `variable`,
the `base` and `compare` values as text, and for numeric variables
`diff` (Compare minus Base) and `pct_diff` (`100 * diff / base`, missing
when the Base value is 0). `diff` and `pct_diff` are missing for the
other Type families. When observations were matched by position (no
`id`), an `obs` column with the observation number takes the place of
the ID variables.
