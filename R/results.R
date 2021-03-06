revdep_results <- function(pkg = ".", revdeps = NULL) {
  res <- db_results(pkg, revdeps)
  class(res) <- "revdepcheck_results"
  res
}

#' @importFrom rcmdcheck compare_checks

revdep_details <- function(pkg = ".", revdep) {
  assert_that(is_string(revdep))
  record <- db_details(pkg, revdep)
  old <- checkFromJSON(record$old$result[[1]])
  new <- checkFromJSON(record$new$result[[1]])
  res <- compare_checks(old, new)
  class(res) <- "revdepcheck_details"
  res
}

#' List packages remaining in the todo list
#'
#' @inheritParams revdep_check
#' @export

revdep_todo <- function(pkg = ".") {
  db_list(pkg)
}

is_broken <- function(x) {
  # TODO: use better code from rcmdcheck
  n_broken_type <- function(x, type) {
    recs <- x$cmp[x$cmp$type == type, , drop = FALSE]
    old <- unique(recs$hash[recs$which == "old"])
    new <- unique(recs$hash[recs$which == "new"])

    length(setdiff(new, old))
  }

  n_broken <- n_broken_type(x, "error") +
    n_broken_type(x, "warning") +
    n_broken_type(x, "note")

  n_broken > 0
}

