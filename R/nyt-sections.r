#' Sections of the NYtimes
#'
#' @param news_sections Valid entries for section arguments include
#'   the following:
#' \itemize{
#'     \item Arts
#'     \item Automobiles
#'     \item Blogs
#'     \item Books
#'     \item Business Day
#'     \item Education
#'     \item Fashion & Style
#'     \item Food
#'     \item Health
#'     \item Job Market
#'     \item Magazine
#'     \item membercenter
#'     \item Movies
#'     \item Multimedia
#'     \item N.Y.\%20\%2F\%20Region
#'     \item NYT Now
#'     \item Obituaries
#'     \item Open
#'     \item Opinion
#'     \item Public Editor
#'     \item Real Estate
#'     \item Science
#'     \item Sports
#'     \item Style
#'     \item Sunday Review
#'     \item T Magazine
#'     \item Technology
#'     \item The Upshot
#'     \item Theater
#'     \item Times Insider
#'     \item Today's Paper
#'     \item Travel
#'     \item U.S.
#'     \item World
#'     \item Your Money
#' }
#' @name news_sections
NULL

x <- "Arts,Automobiles,Blogs,Books,Business Day,Education,Fashion & Style,Food,Health,Job Market,Magazine,membercenter,Movies,Multimedia,N.Y.%20%2F%20Region,NYT Now,Obituaries,Open,Opinion,Public Editor,Real Estate,Science,Sports,Style,Sunday Review,T Magazine,Technology,The Upshot,Theater,Times Insider,Today's Paper,Travel,U.S.,World,Your Money"

news_sections <- data.frame(sections = unlist(strsplit(x, ",")), stringsAsFactors = FALSE)
