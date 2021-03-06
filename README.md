
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nytimes <img src="man/figures/logo.png" width="160px" align="right" />

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

  - R functions for accessing New York Times’ APIs
  - Functionality currently extends to “article search”, “most popular”,
    and “Times newswire” APIs.

## Authorizing API access

  - Use code below to create environment variable to store your api key,
    which you can acquire here: <https://developer.nytimes.com/signup>

<!-- end list -->

``` r
## replace x's with nytimes article search API key which
##    you can acquire by visiting the following URL:
##    https://developer.nytimes.com/signup
apikey <- paste0("NYTIMES_KEY=", "xxxxxxxxxxxxxxxxxxxxxxxxxxxx")

## make path to .Renviron
file <- file.path(path.expand("~"), ".Renviron")

## save environment variable
cat(apikey, file = file, append = TRUE, fill = TRUE)
```

## Using nytimes package

### Install package

``` r
install.packages("devtools")
devtools::install_github("mkearney/nytimes")
```

### Load package

``` r
## load nytimes package
library(nytimes)
```

## Examples

### Article Search API

``` r
## get http response objects for search about sanctions
nytsearch <- nyt_search("sanctions", n = 2000)

## convert response object to data frame
nytsearchdf <- as.data.frame(nytsearch)

## preview data
head(nytsearchdf, 10)
```

### Most Popular API

``` r
## get data for most popular stories
nytpop <- nyt_mostpopular(metric = "mostshared",
                          section = "U.S.")

## convert response object to data frame
nytpopdf <- as.data.frame(nytpop)

## preview data
head(nytpopdf)

## get media for each observation
get_media(nytpopdf)
```

### Times Newswire API

``` r
## get data from the Times newswire
nytwire <- nyt_timeswire(src = "all",
                         section = "all")

## convert response object to data frame
nytwiredf <- as.data.frame(nytwire)

## preview data
head(nytwiredf)
```

## About

  - These functions were created during the Big Dynamic Data working
    group sponsored by the Center for Research Methods & Data Analysis
    at the University of Kansas.
