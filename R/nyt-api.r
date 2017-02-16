.get_nytimes_key <- function() {
    x <- Sys.getenv("NYTIMES_KEY")
    if (any(is.null(x), identical(x, ""))) {
        stop("couldn't find NYTIMES_KEY environment variable",
             call. = FALSE)
    }
    x
}

.get_nyt <- function(scheme = "http",
                     hostname = "api.nytimes.com",
                     path,
                     apikey = NULL,
                     ...) {

    ## if null get api key environment variable
    if (is.null(apikey)) {
        apikey <- .get_nytimes_key()
    }
    ## construct path
    path <- paste0("svc/", path)
    ## build query
    query <- list(...,
        `api-key` = apikey
    )
    ## create url object
    url <- structure(
        list(scheme = scheme,
             hostname = hostname,
             path = path,
             query = query),
        class = "url")
    ## send get request
    httr::GET(httr::build_url(url))
}

.format_pub_date <- function(x) {
    strptime(
        gsub("\\+.*", "", x),
        format = "%Y-%m-%dT%H:%M:%S",
        tz = "UTC")
}
