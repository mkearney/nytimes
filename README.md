## Interacting with New YoRk Times' APIs

- R functions for accessing New York Times' APIs
- Functionality currently extends to "article search", "most
  popular", and "Times newswire" APIs.

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

## Load package

```{r}
## load nytimes package
library(nytimes)
```

## Article Search API

```{r}
## get http response objects for search about sanctions
nytsearch <- nyt_search("sanctions", n = 2000)

## convert response object to data frame
nytsearchdf <- as.data.frame(nytsearch)

## preview data
head(nytsearchdf, 10)

## set force to FALSE to preserve *all* of the data
nytsearchdf <- as.data.frame(nytsearch, force = FALSE)

## nytsearchdf now includes recursive vectors
str(nytsearchdf, 1)
```

## Most Popular API

```{r}
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

## Times Newswire API

```{r}
## get data from the Times newswire
nytwrite <- nyt_timeswire(src = "all",
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

