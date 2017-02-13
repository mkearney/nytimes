#' Geographic API
#'
#' The Geographic API extends the Semantic API, using a
#'   linked data approach to enhance location concepts used
#'   in The New York Times' controlled vocabulary and data
#'   resources which combine them with the GeoNames database,
#'   an authoritative and free to use database of global
#'   geographical places, names and features.
#'
#' @param name latitude longitude elevation sw query filter
#'   date_range facets sort limit offset string string string
#'   integer string string string string integer string
#'   integer integer /query.json
#' @return Response object
#' @export
nyt_geo <- function(name,
                    latitude,
                    longitude,
                    elevation,
                    sw,
                    query,
                    filter,
                    date_range,
                    facets,
                    sort,
                    limit,
                    offset) {
    basepath <- "semantic/v2/geocodes"
    path <- "query.json"
}
