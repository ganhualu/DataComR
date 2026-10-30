# Comparisons run as dplyr verbs inside the data's own backend

DataComR accepts in-memory data frames, arrow datasets and duckdb tables, and must compare clinical datasets that may not fit in memory. So the whole comparison (matching, value checks, summaries) is expressed in dplyr verbs that translate to each backend, and only summary counts and the unequal values are collected into R. This is why a package aimed at validated pharma environments depends on the tidyverse rather than staying base-R-only.

## Consequences

- Matching observations by position is only possible for in-memory data frames; arrow and duckdb inputs require ID variables, since their row order is not guaranteed.
- Duplicate ID values cannot be paired by row order as SAS does; they are reported and excluded from value comparison instead.
- Every comparison rule must have a dplyr translation that the backends support; a rule that only works in R code needs a backend-specific fallback.
