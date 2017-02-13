#' Community API
#'
#' Get access to comments from registered users on New
#'   York Times articles.
#'
#' @param q Type of user content query. Possible methods include
#'   most recent comments \code{q = "recent"}, by date
#'   \code{q = "2017-01-01"}, by user \code{q = "123498723"},
#'   or by url
#'   \code{q = "http://www.nytimes.com/2017/02/12/us/politics/national-security-council-turmoil.html"}.
#' @param \dots Passed to query in GET request.
#' @return Response object
#' @export
nyt_community <- function(q = Sys.Date(), ...) {
    basepath <- "community/v3/user-content/"
    date <- NULL
    userID <- NULL
    url <- NULL
    if (grepl("http|nytimes.com", q)) {
        path <- paste0(basepath, "url.json")
        url <- q
    } else if (.is_date(q)) {
        path <- paste0(basepath, "by-date.json")
        date <- .form_date(q)
    } else if (identical(q, "recent")) {
        path <- paste0(basepath, "recent.json")
    } else {
        path <- paste0(basepath, "user.json")
        userID <- q
    }
    r <- .get_nyt(path = path,
             date = date,
             userID = userID,
             url = url, ...)
    class(r) <- "nytcommunity"
    r
}

.form_date <- function(x) {
    if (inherits(x, c("POSIXt", "POSIXct"))) {
        x <- format(x, format = "%Y-%m-%d", usetz = FALSE)
    } else if (is.character(x)) {
        if (grepl("/", x)) x <- gsub("/", "-", x)
        divs <- strsplit(x, "-")[[1]]
        if (nchar(divs[1]) == 2) {
            x <- paste(divs[c(3, 1, 2)], collapse = "-")
        }
        x <- as.Date(x)
    } else if (is.numeric(x)) {
        x <- as.Date(as.numeric(x), origin = "1970-01-01")
    }
    x
}
.is_date <- function(x) {
    x <- tryCatch(.form_date(x),
                  error = function(e) return(NULL))
    if (is.null(x)) return(FALSE)
    TRUE
}


as.data.frame.nytcommunity <- function(x,
                                       row.names = NULL,
                                       optional = FALSE,
                                       ...,
                                       stringsAsFactors = FALSE) {
    df <- .convertfromjson(x)
    df <- df$results$comments
    replies <- df$replies[
        vapply(df$replies, length, double(1)) > 0]
    replies <- do.call("rbind", replies)
    df <- df[, !names(df) %in% "replies"]
    attr(df, "replies") <- replies
    data.frame(df, row.names = row.names,
               optional = optional,
               stringsAsFactors = stringsAsFactors,
               ...)
}

data.frame.nytcommunity <- function(...) {
    as.data.frame(...)
}
