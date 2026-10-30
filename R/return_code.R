# SYSINFO bit values from SAS PROC COMPARE, plus DataComR's own Duplicate ID
# bit. Bits with no R meaning (2 dataset type, 4 informat, 256/512/16384 BY
# groups) are deliberately absent and never set.
RC_BITS <- c(
  dataset_label = 1L,
  format = 8L,
  width = 16L,
  label = 32L,
  base_obs = 64L,
  compare_obs = 128L,
  base_var = 1024L,
  compare_var = 2048L,
  unequal_value = 4096L,
  conflicting_type = 8192L,
  fatal_error = 32768L,
  duplicate_id = 65536L
)

#' Return code of a comparison
#'
#' @param x A `df_compare` object.
#' @return An integer laid out as SAS's SYSINFO: 0 when the datasets are equal.
#' @export
return_code <- function(x) {
  flags <- return_code_flags(x)
  sum(RC_BITS[names(flags)[flags]])
}

# One logical per condition found, named after its RC_BITS entry.
return_code_flags <- function(x) {
  unmatched <- unmatched_rows(x)
  c(
    base_obs = any(unmatched$dataset == "Base"),
    compare_obs = any(unmatched$dataset == "Compare"),
    base_var = length(x$base_only) > 0,
    compare_var = length(x$compare_only) > 0,
    unequal_value = nrow(differences(x)) > 0
  )
}
