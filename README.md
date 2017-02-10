## nytimes
- R functions for accessing New York Times' article search API
- Created during CRMDA's Big Dynamic Data working group

## Authorizing API access
- Use code below to create environment variable to store your api key

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
## get http response objects
r <- get_nyt("sanctions", n = 2000)

## collapse into more manageable structure
nytdf <- parse_nyt

## preview object structure
str(nytdf, 1)

## there are usually some problem variables though
str(nytdf, 2)
```
