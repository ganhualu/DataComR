# DataComR

An R package that compares two datasets the way SAS PROC COMPARE does, aimed first at clinical and pharma validation, where an R result must be shown to match a SAS (or independently programmed) result.

## Datasets and matching

**Base dataset**:
The dataset treated as the reference in a comparison; differences are reported relative to it.
_Avoid_: Reference, source, left, df1, expected

**Compare dataset**:
The dataset checked against the Base dataset.
_Avoid_: Target, right, df2, actual

**Observation**:
One row of a dataset.
_Avoid_: Row, record

**Variable**:
One column of a dataset, identified by its exact, case-sensitive name.
_Avoid_: Column, field, feature

**ID variable**:
A variable whose values together identify which Base observation pairs with which Compare observation.
_Avoid_: Key, join column, by variable

**Matched observation**:
A Base observation and a Compare observation paired by their ID values, or by position when there are no ID variables.

**Unmatched observation**:
An observation present in only one of the two datasets.
_Avoid_: Orphan, extra row, missing row

**Duplicate ID**:
A set of ID values shared by more than one observation within the same dataset; such observations are reported but never paired or compared.
_Avoid_: Duplicate key, non-unique row

## Variables

**Common variable**:
A variable present in both datasets.

**Type family**:
The SAS-like kind a variable belongs to — numeric, character, date or datetime — which decides whether two variables' values can be compared at all.

**Conflicting types**:
A common variable whose Base and Compare versions belong to different type families, so its values are not compared.

**Attribute difference**:
A mismatch in a common variable's label, SAS format or width, reported separately from value differences.

## Values

**Comparison method**:
The rule deciding whether two numeric values are equal: exact, absolute, relative or percent.
_Avoid_: Tolerance mode

**Criterion**:
The threshold a comparison method tests the difference against.
_Avoid_: Tolerance, epsilon

**Unequal value**:
A matched observation where a common variable's Base and Compare values are not equal under the comparison method. Two missing values are equal; a missing value against a non-missing value is unequal; special missings are equal only when they carry the same letter; character values differing only in trailing blanks are equal.
_Avoid_: Mismatch, diff, discrepancy

## Results

**Listing**:
The printed, PROC COMPARE-style report of a comparison.
_Avoid_: Report, output

**Return code**:
A single integer whose bits flag each kind of difference found, laid out as SAS's SYSINFO.
_Avoid_: Status, exit code
