# DataComR

DataComR compares a Base dataset with a Compare dataset the way SAS PROC COMPARE does: observations paired by ID variables, SAS's numeric comparison methods, a PROC COMPARE-style Listing and a SYSINFO-style Return code. It gives users familiar with SAS PROC COMPARE a similar tool in R.

DataComR is in early development.

## Installation

```r
# install.packages("pak")
pak::pak("ganhualu/DataComR")
```

## Example

```r
library(DataComR)

base <- data.frame(usubjid = c("01", "02"), aval = c(10.5, 20))
compare <- data.frame(usubjid = c("01", "02"), aval = c(10.5, 21))

comparison <- df_compare(base, compare, id = "usubjid")
comparison
differences(comparison)
return_code(comparison)
```

## Acknowledgements

DataComR is developed with assistance from Claude Code (Anthropic).
