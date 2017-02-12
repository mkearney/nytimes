#' nyt_mostpopular
#'
#' Retrieves NYTimes data for one of three possible
#'   popularity metrics---mostshared, mostviewed, or
#'   mostemailed.
#'
#' @param metric Popularity metric. Must be one of
#'   \"mostemailed\" \"mostviewed\", or \"mostshared\". Defaults
#'   to \"mostshared\".
#' @param section NYtimes section of interest. By default, this is
#'   set to \"all-sections\".
#' @param days Window of time used to calculate metric. Must be
#'   1, 7, or 30 (days). Defaults to 7 (or one week).
#' @param apikey Nytimes article search API key. By default the
#'   function will look for the key as an environment variable.
#'   Alternatively, you can suppply the key (a character string)
#'   directly to this apikey argument.
#' @param \dots Arguments passed along to query in final GET request.
#' @return Nested list object of nytimes article data.
#' @export
nyt_mostpopular <- function(metric = "mostshared",
                            section = "all-sections",
                            days = 7,
                            apikey = NULL,
                            ...) {
    ## check params
    stopifnot(is.character(metric),
              is.character(section),
              is.numeric(days))
    ## double check metric
    if (!metric %in% c("mostemailed", "mostviewed", "mostshared")) {
        stop("metric must be \"mostemailed\" \"mostviewed\", or \"mostshared\"",
             call. = FALSE)
    }
    ## double check days
    if (!days %in% c(1, 7, 30)) {
        warning("days must be 1, 7, or 30.",
                call. = FALSE)
        if (days > 1 & days < 7) {
            days <- 7
        } else if (days > 7) {
            days <- 30
        }
        warning("days changed to ", days, ".",
                call. = FALSE)
    }
    ## construct path
    path <- paste0(
        "mostpopular/v2/",
        metric, "/",
        section, "/",
        days, ".json")
    ## make GET request
    r <- .get_nyt(path = path, apikey = apikey, ...)
    ## check if rate limited
    if (r[["status_code"]] == 429) {
        warning("API rate limit exceeded.",
                call. = FALSE)
    }
    ## return response object
    class(r) <- "mostpopular"
    r
}

.collapse_facet <- function(x) {
    x <- vapply(x, paste, collapse = "+", character(1))
    x[x == ""] <- NA_character_
    x
}

#' parse_mostpopular
#'
#' @param r Response object from \code{nyt_mostpopular}.
#' @return Data frame with \"media\" attributes.
#' @export
as.data.frame.mostpopular <- function(r,
                                      stringsAsFactors = FALSE,
                                      ...) {
    x <- jsonlite::fromJSON(rawToChar(r$content))
    if ("results" %in% names(x)) x <- x$results
    attr(x, "media") <- x[["media"]]
    x <- x[, names(x) != "media"]
    x[grep("facet", names(x))] <- lapply(
        x[grep("facet", names(x))], .collapse_facet)
    x[grep("facet", names(x))] <- lapply(
        x[grep("facet", names(x))], unlist
    )
    x[["asset_id"]] <- as.character(x[["asset_id"]])
    x[["published_date"]] <- as.Date(x[["published_date"]])
    data.frame(x, stringsAsFactors = FALSE, ...)
}

#' parse_mostpopular
#'
#' @param r Response object from \code{nyt_mostpopular}.
#' @return Data frame with \"media\" attributes.
#' @export
data.frame.mostpopular <- function(x, ...) {
    as.data.frame.mostpopular(x, ...)
}

#' @export
get_media <- function(x) attr(x, "media")
