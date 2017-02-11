## nytimes: R package for accessing New York Times' article search API
- R functions for accessing New York Times' "article search" API
- Created during CRMDA's Big Dynamic Data working group

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

## Demonstration

```{r}
## load package
library(nytimes)

## get http response objects for search about sanctions
r <- get_nyt("sanctions", n = 2000)

## by default parse_nyt forces output into tidy data frame
nytdf <- parse_nyt(r)

## preview data
head(nytdf, 10)

## set force to FALSE to preserve *all* of the data
nytdat <- parse_nyt(r, force = FALSE)

## object is now a nested list
str(nytdat, 1)
```

