#' Geographic API
#'
#' The Geographic API extends the Semantic API, using a
#'   linked data approach to enhance location concepts used
#'   in The New York Times' controlled vocabulary and data
#'   resources which combine them with the GeoNames database,
#'   an authoritative and free to use database of global
#'   geographical places, names and features.
#'
#' @param q Place name (vector length 1), latitude longitude,
#'   (vector length 2), or bounding box (vector length 4). For
#'   coordinates enter latitutde followed by longitude. For a
#'   bounding box search, enter two pairs of lat/long coords
#'   starting with southwestern most coordinates and ending
#'   with northeastern most coordinates.
#' @param \dots Passed along to query in GET request.
#' @return Response object
#' @export
nyt_geo <- function(q, ...) {
    name <- NULL
    latitude <- NULL
    longitude <- NULL
    sw <- NULL
    ne <- NULL
    path <- "semantic/v2/geocodes/query.json"
    if (length(q) == 1) {
        name <- strsplit(q, "=")[[1]][1]
        namevalue <- strsplit(q, "=")[[1]][2]
    } else if (length(q) == 2) {
        latitude <- q[[1]]
        longitude <- q[[2]]
    } else if (length(q) == 4) {
        sw <- q[1:2]
        ne <- q[3:4]
    }
    .get_nyt(path = path,
             name = name,
             latitude = latitude,
             longitude = longitude,
             sw = sw,
             ne = ne,
             ...)
}
