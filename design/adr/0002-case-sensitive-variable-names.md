# Variable names are matched case-sensitively, unlike SAS

SAS PROC COMPARE matches variables case-insensitively, but DataComR matches them by exact name by default, because R names are case-sensitive and silently pairing `a` with `A` would hide real differences between R datasets. The common SAS-to-R case (`USUBJID` vs `usubjid`) is handled by an opt-in `ignore_case = TRUE`, not by changing the default. Don't "fix" this to match SAS.
