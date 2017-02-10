
#' get_nyt
#'
#' Main function used to retrieve data from NYTimes'
#'   article search API
#' @param q Search query.
#' @param n Number of desired articles to return.
#' @param end_date Date from which results should start (the results
#'   will go back in time from this date). Must be in YYYYMMDD format,
#'   e.g., \code{end_date = "20170101"}.
#' @param apikey Nytimes article search API key. By default the
#'   function will look for the key as an environment variable.
#'   Alternatively, you can suppply the key (a character string)
#'   directly to this apikey argument.
#' @param \dots Arguments passed along to query in final GET request.
#' @return Nested list object of nytimes article data.
#' @export
get_nyt <- function(q,
                    n = 100,
                    end_date = NULL,
                    apikey = NULL,
                    ...) {
    ## check params
    stopifnot(is.character(q),
              is.numeric(n),
              is.atomic(apikey))
    ## if null get apikey environment variable
    if (is.null(apikey)) {
        apikey <- .get_nytimes_key()
    }
    ## results come in batches of 10, so...
    n <- ceiling(n / 10)
    ## initialize vector to store results
    x <- vector("list", n)
    ## loop through pages
    for (i in seq_len(n)) {
        x[[i]] <- .get_nyt(q = q,
                           page = i,
                           apikey = apikey,
                           end_date = end_date,
                           ...)
        ## check status of response object
        if (x[[i]][["status_code"]] != 200) break
        ## get date from which to resume next iteration
        if (all(i %% 100 == 0, n > 100)) {
            end_date <- .get_end_date(x[[i]])
        }
        Sys.sleep(.25)
    }
    ## return non-null elements of x
    x[!vapply(x, is.null, logical(1))]
}



#' parse_nyt
#'
#' Parses response data into nested list.
#'
#' @param x Response object from get_nyt
#' @return Nested list object.
#' @export
parse_nyt <- function(x) {
    x <- .get_docs(x)
    x <- .delist(x)
    lapply(x, function(x) do.call("c", x))
}



## create a function to fetch your api key
.get_nytimes_key <- function() {
    x <- Sys.getenv("NYTIMES_KEY")
    if (any(is.null(x), identical(x, ""))) {
        stop("couldn't find NYTIMES_KEY environment variable",
             call. = FALSE)
    }
    x
}

.get_nyt <- function(q,
                     page = 1,
                     sort = "newest",
                     apikey = NULL,
                     scheme = "http",
                     hostname = "api.nytimes.com",
                     version = "v2",
                     path = "articlesearch.json",
                     ...) {

    ## if null get api key environment variable
    if (is.null(apikey)) {
        apikey <- .get_nytimes_key()
    }
    ## construct path
    path <- paste0("svc/search/",
                   version,
                   "/", path)
    ## build query
    query <- list(
        q = q,
        page = page,
        sort = sort,
        `api-key` = apikey,
        ...
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


## get end date (for searches where n > 1000)
.get_end_date <- function(x) {
    x <- jsonlite::fromJSON(rawToChar(x[['content']]))
    x <- x[["response"]][["docs"]][["pub_date"]]
    if (is.null(x)) return(NULL)
    x <- x[!is.na(x)]
    x <- x[NROW(x)]
    if (any(length(x) != 1,
            identical(x, ""))) return(NULL)
    gsub("-", "", substr(x, 1, 10))
}

.convertfromjson <- function(x) {
    tryCatch(jsonlite::fromJSON(rawToChar(x[["content"]])),
             error = function(e) return(NULL))
}

.get_docs <- function(x) {
    x <- lapply(x, .convertfromjson)
    x <- lapply(x, getElement, "response")
    lapply(x, getElement, "docs")
}

.commonnames <- function(x) {
    allnames <- unlist(
        lapply(x, function(x) names(x)),
        use.names = FALSE)
    tab <- table(allnames)
    tab <- tab[tab == max(tab, na.rm = TRUE)]
    names(tab)
}
.collapsevar <- function(var, data) {
    lapply(data, getElement, var)
}
.delist <- function(x) {
    vars <- .commonnames(x)
    y <- lapply(vars, .collapsevar, data = x)
    names(y) <- vars
    y[vapply(y, is.null, logical(1))] <- NA
    y
}
