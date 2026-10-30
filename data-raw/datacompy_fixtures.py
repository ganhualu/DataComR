"""Generate DataComPy conformance fixtures for DataComR's tests.

Builds Base and Compare datasets, compares them with DataComPy, and writes the
datasets and DataComPy's results to tests/testthat/fixtures/datacompy/ as CSV
files, which tests/testthat/test-datacompy.R checks df_compare() against.

Generated with:
    Python     3.12.7
    pandas     3.1.0
    DataComPy  1.2.0

Rerun from the repository root (see data-raw/README.md):
    uv run --with datacompy==1.2.0 --with pandas==3.1.0 python data-raw/datacompy_fixtures.py

Semantics shared by both packages, and kept to by the fixtures:
- Observations are matched on ID variables; no Duplicate IDs (DataComPy pairs
  duplicates by row order, DataComR excludes them).
- Numeric values are equal when |base - compare| <= abs_tol + rel_tol * |compare|
  (numpy.isclose). With rel_tol = 0 this is SAS METHOD=ABSOLUTE with
  CRITERION = abs_tol; with abs_tol = rel_tol = 0 it is METHOD=EXACT.
- Two missing values are equal (equal_nan=True); missing against non-missing is
  unequal.
- Character values are compared as is (ignore_spaces=False, ignore_case=False):
  leading blanks and case count in both packages.

Excluded, because the packages deliberately differ:
- Trailing blanks: DataComR ignores them by default, as SAS does; DataComPy
  only ignores (leading and trailing) blanks with ignore_spaces=True.
- Variable names differing in case: DataComPy lower-cases them by default.
- Duplicate IDs (see above), and Type families other than numeric and
  character.

Numeric values are exact in binary floating point (multiples of 1/8), so
values at, just inside and just outside the Criterion are compared without
rounding noise.
"""

import csv
import platform
from pathlib import Path

import datacompy
import numpy as np
import pandas as pd

OUT = Path(__file__).resolve().parent.parent / "tests" / "testthat" / "fixtures" / "datacompy"
NA = np.nan

# Each dataset pair: ID variables, variable types for R, Base and Compare.
DATASETS = {
    # Unmatched observations on both sides, numeric and character Unequal
    # values, missing values, on a two-variable ID.
    "subjects": {
        "id": ["usubjid", "visit"],
        "types": {"usubjid": "character", "visit": "numeric", "aval": "numeric",
                  "avalc": "character", "flag": "character"},
        "base": pd.DataFrame({
            "usubjid": ["01", "01", "02", "02", "03", "04", "05"],
            "visit": [1.0, 2.0, 1.0, 2.0, 1.0, 1.0, 1.0],
            "aval": [10.0, 11.5, 20.0, NA, 30.0, 40.0, NA],
            "avalc": ["low", "high", "low", "low", None, "mid", "x"],
            "flag": ["Y", "Y", "N", "Y", "N", "N", "Y"],
        }),
        "compare": pd.DataFrame({
            "usubjid": ["01", "01", "02", "02", "03", "06", "05", "07"],
            "visit": [1.0, 2.0, 1.0, 3.0, 1.0, 1.0, 1.0, 2.0],
            "aval": [10.0, 11.75, 20.0, 5.0, NA, 60.0, NA, 70.0],
            "avalc": ["low", "High", " low", "low", None, "mid", None, "y"],
            "flag": ["Y", "Y", "N", "Y", "N", "N", "Y", "N"],
        }),
    },
    # Absolute-criterion boundaries: differences below, exactly at and above
    # 0.25, in both directions and at larger magnitudes.
    "boundaries": {
        "id": ["id"],
        "types": {"id": "integer", "x": "numeric", "y": "numeric"},
        "base": pd.DataFrame({
            "id": list(range(1, 11)),
            "x": [1.0, 1.0, 1.0, 1.0, -1.0, -1.0, 1024.0, 1024.0, 0.0, NA],
            "y": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
        }),
        "compare": pd.DataFrame({
            "id": list(range(1, 11)),
            # diffs: 0, 0.125, 0.25, 0.375, -0.25, -0.375, 0.25, 0.5, -0.125, NA vs 0
            "x": [1.0, 1.125, 1.25, 1.375, -1.25, -1.375, 1024.25, 1024.5, -0.125, 0.0],
            "y": [0.0, 0.25, 0.5, -0.25, -0.5, 0.0, 0.125, 0.0, 0.0, 0.0],
        }),
    },
}

# Each fixture: a dataset pair compared under one Comparison method.
FIXTURES = [
    ("subjects_exact", "subjects", "exact", 0.0),
    ("subjects_absolute", "subjects", "absolute", 0.25),
    ("boundaries_exact", "boundaries", "exact", 0.0),
    ("boundaries_absolute", "boundaries", "absolute", 0.25),
    ("boundaries_absolute_wide", "boundaries", "absolute", 0.5),
]


def write_csv(df, path):
    df.to_csv(path, index=False, na_rep="NA", quoting=csv.QUOTE_MINIMAL)


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for name, data in DATASETS.items():
        write_csv(data["base"], OUT / f"{name}_base.csv")
        write_csv(data["compare"], OUT / f"{name}_compare.csv")
        pd.DataFrame({"variable": list(data["types"]), "type": list(data["types"].values())}).to_csv(
            OUT / f"{name}_types.csv", index=False
        )

    manifest = []
    for fixture, dataset, method, criterion in FIXTURES:
        data = DATASETS[dataset]
        id_vars = data["id"]
        cmp = datacompy.PandasCompare(
            data["base"], data["compare"], join_columns=id_vars,
            abs_tol=criterion, rel_tol=0, ignore_spaces=False, ignore_case=False,
            cast_column_names_lower=False,
        )
        if cmp._any_dupes:
            raise RuntimeError(f"{fixture}: Duplicate IDs are not supported")

        unmatched = pd.concat([
            cmp.df1_unq_rows[id_vars].assign(dataset="Base"),
            cmp.df2_unq_rows[id_vars].assign(dataset="Compare"),
        ])
        write_csv(unmatched, OUT / f"{fixture}_unmatched.csv")

        stats = [s for s in cmp.column_stats if s["column"] not in id_vars]
        pd.DataFrame({
            "variable": [s["column"] for s in stats],
            "unequal": [int(s["unequal_cnt"]) for s in stats],
        }).to_csv(OUT / f"{fixture}_unequal_counts.csv", index=False)

        rows = cmp.intersect_rows
        unequal = pd.concat([
            rows.loc[~rows[f"{s['column']}_match"], id_vars].assign(variable=s["column"])
            for s in stats
        ])
        write_csv(unequal, OUT / f"{fixture}_unequal.csv")

        manifest.append({
            "fixture": fixture, "dataset": dataset, "id": " ".join(id_vars),
            "method": method, "criterion": criterion,
            "matched": len(rows),
            "unmatched_base": len(cmp.df1_unq_rows),
            "unmatched_compare": len(cmp.df2_unq_rows),
        })

    pd.DataFrame(manifest).to_csv(OUT / "manifest.csv", index=False)
    (OUT / "VERSIONS").write_text(
        f"python {platform.python_version()}\n"
        f"pandas {pd.__version__}\n"
        f"datacompy {datacompy.__version__}\n"
    )


if __name__ == "__main__":
    main()
