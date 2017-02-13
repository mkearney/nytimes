#' Archive API
#'
#' The Archive API provides lists of NYT articles by month
#'   going back to 1851.
#'
#' @param year month integer integer /{year}/{month}.json
#' @return Response object
#' @export
nyt_archive <- function(year, month) {
    basepath <- paste0("archive/v1")
    path <- paste0(year, "/", month, ".json")
}
