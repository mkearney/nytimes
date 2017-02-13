#' Books API
#'
#' The Books API provides information about book reviews and
#'   The New York Times bestsellers lists.
#'
#' @param age_group author contributor isbn price publisher
#'   title string string string string string string string
#'   /lists/best-sellers/history.json
#' @param list weeks-on-list bestsellers-date date isbn
#'   published-date rank rank-last-week offset sort-order
#'   string integer string string string string integer
#'   integer integer string /lists.{format}
#' @param isbn list-name published-date bestsellers-date
#'   weeks-on-list rank rank-last-week offset sort-order
#'   integer string string string integer string integer
#'   integer string /lists/{date}/{list}.json
#' @param published_date api-key string string
#'   /lists/overview.{format}
#' @param apikey string /lists/names.{format}
#' @param title isbn title author api-key integer string string
#'   string /reviews.{format}
#' @return Response object
#' @export
nyt_books <- function(age_group,
                      list,
                      isbn,
                      published_date,
                      apikey,
                      title) {
     basepath <- "books/v3"
     path <- "lists/best-sellers/history.json"
     path <- paste0("lists.", format, ".json")
     path <- paste0("lists/", list, ".json")
     path <- paste0("lists/overview.", format, ".json")
     path <- paste0("lists/names.", format, ".json")
     path <- paste0("reviews.", format, ".json")
}
