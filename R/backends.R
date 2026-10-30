# Brings the Base and Compare datasets into one backend so they can be joined,
# without collecting either into R. Returns the two datasets and a `cleanup`
# function that removes anything registered in a backend along the way.
#
# - Same backend: used as they are (two duckdb tables must share a connection).
# - Data frame with duckdb: the data frame is registered in the duckdb
#   connection as a view; nothing is copied.
# - Data frame with arrow: the data frame becomes an Arrow Table.
# - Arrow with duckdb: the arrow data is registered in the duckdb connection
#   through arrow's zero-copy interface.
one_backend <- function(base, compare, call = rlang::caller_env()) {
  kinds <- c(base = backend_of(base, "Base", call), compare = backend_of(compare, "Compare", call))
  inputs <- list(base = base, compare = compare, cleanup = function() invisible())

  if (kinds[["base"]] == kinds[["compare"]]) {
    if (kinds[["base"]] == "duckdb") {
      check_same_connection(base, compare, call)
    }
    return(inputs)
  }

  if ("duckdb" %in% kinds) {
    target <- names(kinds)[kinds == "duckdb"]
    other <- names(kinds)[kinds != "duckdb"]
    con <- dbplyr::remote_con(inputs[[target]])
    name <- backend_table_name()
    if (kinds[[other]] == "arrow") {
      inputs[[other]] <- arrow::to_duckdb(
        inputs[[other]],
        con = con, table_name = name, auto_disconnect = FALSE
      )
      inputs$cleanup <- function() duckdb::duckdb_unregister_arrow(con, name)
    } else {
      duckdb::duckdb_register(con, name, inputs[[other]])
      inputs[[other]] <- dplyr::tbl(con, name)
      inputs$cleanup <- function() duckdb::duckdb_unregister(con, name)
    }
    return(inputs)
  }

  other <- names(kinds)[kinds == "data_frame"]
  inputs[[other]] <- arrow::arrow_table(inputs[[other]])
  inputs
}

# Names the backend a dataset lives in, checking the optional packages that
# backend needs are installed.
backend_of <- function(data, dataset, call) {
  if (inherits(data, "tbl_lazy")) {
    rlang::check_installed(c("dbplyr", "duckdb", "DBI"), "to compare duckdb tables.", call = call)
    if (!inherits(dbplyr::remote_con(data), "duckdb_connection")) {
      cli::cli_abort(
        "The {dataset} dataset is a database table that is not in duckdb; only duckdb tables are supported.",
        call = call
      )
    }
    return("duckdb")
  }
  if (inherits(data, c("ArrowTabular", "Dataset", "arrow_dplyr_query"))) {
    rlang::check_installed("arrow", "to compare arrow data.", call = call)
    return("arrow")
  }
  if (is.data.frame(data)) {
    return("data_frame")
  }
  cli::cli_abort(
    "The {dataset} dataset must be a data frame, an arrow table or dataset, or a duckdb table, not {.obj_type_friendly {data}}.",
    call = call
  )
}

check_same_connection <- function(base, compare, call) {
  if (!identical(dbplyr::remote_con(base), dbplyr::remote_con(compare))) {
    cli::cli_abort(
      "The Base and Compare duckdb tables must share one duckdb connection.",
      call = call
    )
  }
}

# A table name unique within the R session, so comparisons sharing one
# connection never collide. A counter avoids touching the user's RNG state.
backend_table_name <- local({
  n <- 0L
  function() {
    n <<- n + 1L
    sprintf("datacomr_%d_%d", Sys.getpid(), n)
  }
})
