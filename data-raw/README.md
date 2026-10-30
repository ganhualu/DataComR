# data-raw

## DataComPy conformance fixtures

`datacompy_fixtures.py` builds Base and Compare datasets, compares them with
[DataComPy](https://github.com/capitalone/datacompy), and writes the datasets
and DataComPy's results to `tests/testthat/fixtures/datacompy/`.
`tests/testthat/test-datacompy.R` checks that `df_compare()` agrees with them
on every backend. The generated files are committed, so the tests don't need
Python.

Generated with Python 3.12.7, pandas 3.1.0 and DataComPy 1.2.0 (also recorded
in `tests/testthat/fixtures/datacompy/VERSIONS`).

### Rerun

From the repository root, with [uv](https://docs.astral.sh/uv/):

```sh
uv run --with datacompy==1.2.0 --with pandas==3.1.0 python data-raw/datacompy_fixtures.py
```

uv runs the script in a throwaway environment; nothing is installed into your
own Python. Then run `devtools::test(filter = "datacompy")`.

### Files written

- `manifest.csv`: one row per fixture: dataset pair, ID variables, method,
  criterion, and DataComPy's Matched / Unmatched observation counts.
- `<dataset>_base.csv`, `<dataset>_compare.csv`, `<dataset>_types.csv`: the
  datasets and the R class of each variable.
- `<fixture>_unmatched.csv`: ID values of the Unmatched observations and the
  dataset they are in.
- `<fixture>_unequal_counts.csv`: Unequal value count per compared variable.
- `<fixture>_unequal.csv`: ID values and variable of each Unequal value.

### Semantics covered and excluded

Covered: matching on ID variables, Unmatched observations in both datasets,
numeric and character Unequal values, missing values (missing equals missing,
missing against non-missing is unequal), and `method = "exact"` and
`method = "absolute"` (DataComPy with `rel_tol = 0`, whose
`|a - b| <= abs_tol` is SAS's `METHOD=ABSOLUTE`), including differences just
inside, exactly at and just outside the Criterion. Numeric values are
multiples of 1/8, exact in binary floating point.

Excluded, because the packages deliberately differ:

- Trailing blanks: DataComR ignores them by default, as SAS does; DataComPy
  compares them unless `ignore_spaces = True`, which also strips leading
  blanks. Fixtures have no trailing blanks; a leading-blank difference is
  included (unequal in both).
- Duplicate IDs: DataComPy pairs them; DataComR excludes them.
- Variable names differing in case: DataComPy lower-cases names by default
  (the script turns this off).
- Relative and percent methods (DataComPy's relative tolerance is not SAS's
  formula), and Type families other than numeric and character.
