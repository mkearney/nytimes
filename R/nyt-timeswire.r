#' timeswire
#'
#' With the Times Newswire API, you can get links and metadata
#'   for Times articles and blog posts as soon as they are
#'   published on NYTimes.com. The Times Newswire API provides
#'   an up-to-the-minute stream of published items.
#'
#' @param src Limits the set of items by originating source
#'   \"all\" = items from both New York Times and International
#'   New York Times, \"nyt\" = New York Times items only, \"iht\" =
#'   International New York Times items only, path. Must be one
#'   of the following: string. Defaults to all.
#' @param section Limits the set of items by one or more sections
#'   all. One or more section names, separated by semicolons.
#'   To get all sections, specify all. To get a particular section
#'   or sections, use section names. String. Defaults to all.
#' @param limit Limits the number of results, between 1 and 20,
#'   query. Must be one of the following: integer.
#' @param offset Sets the starting point of the result set, query.
#'   Must be one of the following: integer.
#' @param \dots Passed to http query.
#'
#' @return Response object from the Times Newswire API.
#' @examples
#' \dontrun{
#' nyt <- timeswire()
#' }
#' @export
nyt_timeswire <- function(src = "all",
                          section = "all",
                          limit = NULL,
                          offset = NULL,
                          ...) {
    path <- paste0("news/v3/content/",
                   src, "/",
                   section, ".json")
    r <- .get_nyt(path = path,
                  limit = limit,
                  offset = offset,
                  ...)
    class(r) <- "timeswire"
    r
}

#' Parse nyt_timeswire object into data frame
#'
#' @param x Response object returned by nyt_timeswire.
#' @param row.names see 'asdata.frame()'
#' @param optional see 'as.data.frame()' methods
#' @param \dots Passed along to data.frame function.
#' @return Data frame.
#' @export
as.data.frame.timeswire <- function(x,
                                    row.names = NULL,
                                    optional = FALSE,
                                    ...) {
    x <- .convertfromjson(x)
    x <- x$results
    x[grep("_facet|_urls", names(x), value = TRUE)] <- lapply(
        x[grep("_facet|urls", names(x), value = TRUE)],
        .collapse_facet
    )
    x[["multimedia"]] <- vapply(
        x[["multimedia"]], function(i)
            paste(i[[1]], collapse = "+"),
        character(1))
    x[["multimedia"]][x[["multimedia"]] == ""] <- NA_character_
    x <- lapply(x, function(y) {
        y[y == ""] <- NA_character_
        return(y)}
    )
    x$created_date <- .format_pub_date(x$created_date)
    x$published_date <- .format_pub_date(x$published_date)
    x$updated_date <- .format_pub_date(x$updated_date)
    as.data.frame(x, ...)
}

#' Parse nyt_timeswire object into data frame
#'
#' @param \dots Passed along to data.frame function.
#' @return Data frame.
#' @export
data.frame.timeswire <- function(...) {
    as.data.frame(...)
}
