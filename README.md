## Interacting with New YoRk Times' APIs

- R functions for accessing New York Times' APIs
- Functionality currently extends to "article search" and "most
  popular" APIs.

## Install package

```{r}
install.packages("devtools")
devtools::install_github("mkearney/nytimes")
```

## Authorizing API access
- Use code below to create environment variable to store your api key,
  which you can acquire here:
  [https://developer.nytimes.com/signup](https://developer.nytimes.com/signup)

```{r}
## replace x's with nytimes article search API key which
##    you can acquire by visiting the following URL:
##    https://developer.nytimes.com/signup
apikey <- paste0("NYTIMES_KEY=", "xxxxxxxxxxxxxxxxxxxxxxxxxxxx")

## make path to .Renviron
file <- file.path(path.expand("~"), ".Renviron")

## save environment variable
cat(apikey, file = file, append = TRUE, fill = TRUE)
```

## Load nytimes

```{r}
## load package
library(nytimes)
```

## Article Search API

```{r}
## get http response objects for search about sanctions
r <- nyt_search("sanctions", n = 2000)

## by default parse_nyt forces output into tidy data frame
nytdf <- parse_search(r)

## preview data
head(nytdf, 10)

## set force to FALSE to preserve *all* of the data
nytdat <- parse_search(r, force = FALSE)

## object is now a nested list
str(nytdat, 1)
```

## Most Popular API

```{r}
## get data for most popular stories
nytpop <- nyt_mostpopular(metric = "mostshared",
                          section = "U.S.")

## parse into tidy data frame
nytpopdf <- parse_mostpopular(nytpop)

## preview data
head(nytpopdf)

## get media for each observation
get_media(nytpopdf)
```

## About
- These functions were created during the Big Dynamic Data working
  group sponsored by the Center for Research Methods & Data Analysis
  at the University of Kansas.

