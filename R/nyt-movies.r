#' Movie Reviews API
#'
#' With the Movie Reviews API, you can search New York Times
#'   movie reviews by keyword and get lists of NYT Critics' Picks.
#'
#' @param query Search string
#' @param reviewer Name or type of critic/review. Defaults to all.
#' @param critics_pick Logicl indicating whether to limit results
#'    to top critics.
#' @param \dots Passed to query in get request.
#' @return Response object
#' @export
nyt_movies <- function(query = NULL,
                       reviewer = "all",
                       critics_pick = NULL,
                       ...) {
    basepath <- "movies/v2/"
    if (!is.null(query)) {
        path <- paste0(basepath, "reviews/search.json")
    } else {
        path <- paste0(basepath,
                       paste0("reviews/", reviewer, ".json"))
        if (!is.null(critics_pick)) critics_pick <- "Y"
    }
    .get_nyt(path = path, reviewer = reviewer,
             query = query, ...)
}
