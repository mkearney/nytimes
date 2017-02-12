
#' nyt_search
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
nyt_search <- function(q,
                    n = 100,
                    end_date = NULL,
                    apikey = NULL,
                    ...) {
    ## check params
    stopifnot(is.character(q),
              is.numeric(n),
              is.atomic(apikey))
    ## url encode query
    q <- URLencode(q)
    ## if null get apikey environment variable
    if (is.null(apikey)) {
        apikey <- .get_nytimes_key()
    }
    ## results come in batches of 10, so...
    n <- ceiling(n / 10)
    ## initialize vector to store results
    x <- vector("list", n)
    ## start page counter
    p <- 1L
    ## loop through pages
    for (i in seq_len(n)) {
        x[[i]] <- .get_nyt(
            path = "search/v2/articlesearch.json",
            apikey = apikey,
            q = q,
            page = p,
            end_date = end_date,
            ...)
        ## check status of response object
        if (x[[i]][["status_code"]] != 200) break
        ## get date from which to resume next iteration
        if (all(i %% 100 == 0, n > 100)) {
            ## update end_date
            end_date <- .get_end_date(x[[i]])
            ## reset page counter
            p <- 1L
        } else {
            ## add to page counter
            p <- p + 1L
        }
        Sys.sleep(.5)
    }
    if (x[[i]][["status_code"]] == 429) {
        warning("API rate limit exceeded",
                call. = FALSE)
    }
    ## return non-null elements of x
    x <- x[!vapply(x, is.null, logical(1))]
    ## set class
    class(x) <- "search"
    ## return object
    x
}



#' parse_search
#'
#' Parses response data into nested list.
#'
#' @param nyt Response object from get_nyt
#' @param force Logical indicating whether to force data into
#'   a data frame. Depending on the request, a few columns may
#'   come out ugly with recursive variables forced into non-
#'   recursive format by separating each entry with +'s. Defaults
#'   to TRUE.
#' @examples
#' \dontrun{
#' nyt <- get_nyt("political+polarization", n = 100)
#' nytdat <- parse_nyt(nyt)
#' head(nytdat)
#' }
#' @return Returns NYT data organized by variable.
#' @export
as.data.frame.search <- function(x, force = TRUE,
                                 ...) {
    x <- .get_docs(x)
    x <- .delist(x)
    x <- lapply(x, function(x) do.call("c", x))
    if (!force) return(x)
    x <- .flattener(x)
    x[["pub_date"]] <- strptime(
        gsub("\\+.*", "", x[["pub_date"]]),
        format = "%Y-%m-%dT%H:%M:%S")
    data.frame(x, stringsAsFactors = FALSE, ...)
}

#' @export
data.frame.search <- function(x, force = TRUE, ...) {
    as.data.frame.search(x, force = force, ...)
}

.flattener <- function(x) {
    names(x)[1] <- "id"
    if (isTRUE("multimedia" %in% names(x))) {
        x[["multimedia"]] <- .pluckfold(
            x[["multimedia"]], "url"
        )
    }
    if (isTRUE("keywords" %in% names(x))) {
        x[["keywords"]] <- .pluckfold(
            x[["keywords"]], "value"
        )
    }
    if (isTRUE("headline" %in% names(x))) {
        x[["headline"]] <- x[["headline"]][["main"]]
        x[["headline"]][x[["headline"]] == ""] <- NA_character_
    }
    if (isTRUE("byline" %in% names(x))) {
        x[["byline"]] <- x[["byline"]][["original"]]
        x[["byline"]][x[["byline"]] == ""] <- NA_character_
    }
    recv <- vapply(x, is.recursive, logical(1))
    data.frame(x[!recv], stringsAsFactors = FALSE)
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
.pluckfold <- function(x, var) {
    x <- vapply(x, function(i)
        paste(unlist(getElement(i, var)),
              collapse = "+"),
        character(1))
    x[x == ""] <- NA_character_
    x
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

