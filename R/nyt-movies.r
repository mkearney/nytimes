#' Movie Reviews API
#'
#' With the Movie Reviews API, you can search New York Times
#'   movie reviews by keyword and get lists of NYT Critics' Picks.
#'
#' @param query Search string
#' @param reviews Name or type of reviews. Defaults to all.
#' @param critics Type or name of critics. Defaults to NULL.
#' @param critics_pick Logicl indicating whether to limit results
#'    to top critics.
#' @param \dots Passed to query in get request.
#' @return Response object
#' @export
nyt_movies <- function(query = NULL,
                       reviews = "all",
                       critics = NULL,
                       critics_pick = FALSE,
                       ...) {
    basepath <- "movies/v2/"
    if (!is.null(query)) {
        path <- paste0(basepath, "reviews/search.json")
    } else if (!is.null(critics)) {
        path <- paste0(basepath,
                       paste0("critics/", reviews, ".json"))
    } else {
        if (critics_pick) {
            path <- paste0(basepath, "reviews/picks.json")
        } else {
            path <- paste0(basepath, "reviews/all.json")
        }
    }
    if (!is.null(critics_pick)) {
            critics_pick <- "Y"
    } else if (!is.null(query)) {
        critics_pick <- "N"
    }

    r <- .get_nyt(
        path = path,
        reviews = reviews,
        query = query,
        ...)
    class(r) <- "nytmovies"
    r
}


as.data.frame.nytmovies <- function(x, ...) {
    x <- .convertfromjson(x)
    x <- x$results
    x <- cbind(x[!names(x) %in% "multimedia"], x$multimedia)
    data.frame(x, stringsAsFactors = FALSE, ...)
}
