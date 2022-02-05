
# custom internal function to mimic stringr::str_squish() with no external deps
base_str_squish <- function(x){
  # remove leading and trailing whitespace with base functions for no new deps
  x <- gsub(x = x, pattern = "^\\s+|\\s+$", replacement = "")
  # replace any double spaces with a single space
  x <- gsub(x = x, pattern = "\\s+", replacement = " ")
}


created_utc <- public_description <- subscribers <- description <- NULL

# https://github.com/reddit-archive/reddit/wiki/API
# <platform>:<app ID>:<version string> (by /u/<reddit username>)
ua_string <- "web:socialastronomy:v0.0.1 (by /u/belangeranalytics)"


# Methods for calling the pushshift.io Reddit search APIs

# https://github.com/pushshift/api

# | Parameter | Description | Default | Accepted Values |
#   | ------ | ------ | ------- | ------ |
#   | q | Search term. | N/A | String / Quoted String for phrases |
#   | ids | Get specific comments via their ids | N/A | Comma-delimited base36 ids |
#   | size | Number of results to return | 25 | Integer <= 500 |
#   | fields | One return specific fields (comma delimited) | All Fields Returned | string or comma-delimited string |
#   | sort | Sort results in a specific order | "desc" | "asc", "desc" |
#   | sort_type | Sort by a specific attribute | "created_utc" | "score", "num_comments", "created_utc" |
#   | aggs | Return aggregation summary | N/A | ["author", "link_id", "created_utc", "subreddit"] |
#   | author | Restrict to a specific author | N/A | String |
#   | subreddit | Restrict to a specific subreddit | N/A | String |
#   | after | Return results after this date | N/A | Epoch value or Integer + "s,m,h,d" (i.e. 30d for 30 days) |
#   | before | Return results before this date | N/A | Epoch value or Integer + "s,m,h,d" (i.e. 30d for 30 days) |
#   | frequency | Used with the aggs parameter when set to created_utc | N/A | "second", "minute", "hour", "day" |
#   | metadata | display metadata about the query | false | "true", "false" |

#' Search Reddit comments using the PushShift API
#'
#' Query the PushShift API to search Reddit comments. Does some minimal input
#' validation and massaging for quality-of-life. Incorporates polite batching,
#' since the API will only return 100 results at a time.
#'
#' @param q Search term. String / Double-quoted String for phrases.
#' @param ids Get specific comments via their ids. Comma-delimited base36 ids.
#' @param size Number of results to return. Default is 25; values > 100 handled through batching.
#' @param fields Return specific fields, either comma-delimited string or character vector. Default is all fields returned. Date/time created is always returned.
#' @param sort Sort results in a specific order. "desc" (default) or "asc".
#' @param sort_type Sort by a specific attribute. "score", "num_comments", "created_utc"
#' @param aggs Return aggregation summary. *DISABLED BY PUSHSHIFT DUE TO SERVER LOAD*
#' @param author Restrict to a specific author.
#' @param subreddit Restrict to a specific subreddit.
#' @param after Return results after this date. Epoch value or Integer + "s,m,h,d" (i.e. 30d for 30 days)
#' @param before Return results before this date. Epoch value or Integer + "s,m,h,d" (i.e. 30d for 30 days)
#' @param frequency Used with the aggs parameter when set to created_utc. *DISABLED BY PUSHSHIFT DUE TO SERVER LOAD*
#' @param metadata display metadata about the query. Default false.
#' @param batch_pause Pause between batches in seconds. Default is 1s.
#' @param parse_utc Boolean flag: parse UTC timestamps into human-readable date-times? Default TRUE.
#' @param verbose Debug boolean flag to enable/disable message logging to the console.
#'
#' @return A tibble containing values returned by the API.
#' @export
#'
#' @examples
#' \dontrun{test <- get_reddit_comments(q = "coffee maker", size = 250)}
get_reddit_comments <- function(q = NA, ids = NA, size = 25, fields = NA, sort = c("desc", "asc"), sort_type = c("created_utc", "score", "num_comments"), aggs = NA, author = NA, subreddit = NA, after = NA, before = NA, frequency = NA, metadata = FALSE, batch_pause = 1, parse_utc = TRUE, verbose = TRUE){

  # basic input fixing
  sort <- match.arg(sort, sort)
  sort_type <- match.arg(sort_type)
  q <- base_str_squish(q)
  ids <- base_str_squish(ids)
  fields <- base_str_squish(fields)
  author <- base_str_squish(author)
  subreddit <- base_str_squish(subreddit)

  # if we got fields in a character vector, flatten it
  if (length(fields) > 1) {
    fields <- stringr::str_flatten(fields, collapse = ",")
    # add created_utc if it's not there
    if (!stringr::str_detect(fields, "created_utc")) fields <- paste0(fields,",created_utc")
  }

  # the search endpoint
  api_endpoint <- "https://api.pushshift.io/reddit/search/comment?"

  url <- httr::parse_url(api_endpoint)

  # TODO: fix bug in number of batches BATCHING.
  batches <- ((size-1) %/% 100) + 1
  all_results <- dplyr::tibble()

  # set up initial before time: if not provided, it's this moment in Unix epoch
  if (is.na(before)) before <- round(unclass(as.POSIXct(Sys.time())))

  for (batch in 1:batches){
    if (verbose) message(sprintf("Batch %d/%d", batch, batches))

    # fetch the right number in this batch: 100 until the last batch, then
    # get the extras
    if ((batch < batches) & size > 100)  size_to_fetch <- 100
    if ((batch == batches) & size > 100) size_to_fetch <- size - (batches-1) * 100 #size %% 100
    if (size <= 100) size_to_fetch <- size

    # set up a blank API query
    #url$query <- list()

    # add the query portions if they're there
    # if (!is.na(q)) url$query <- append(url$query, list (q = q))
    # if (!is.na(ids)) url$query <- append(url$query, list (ids = ids))
    # if (!is.na(size)) url$query <- append(url$query, list (size = size_to_fetch)) # note differs in each batch
    # if (!is.na(fields)) url$query <- append(url$query, list (fields = fields))
    # if (!is.na(sort)) url$query <- append(url$query, list (sort = sort))
    # if (!is.na(sort_type)) url$query <- append(url$query, list (sort_type = sort_type))
    # if (!is.na(author)) url$query <- append(url$query, list (author = author))
    # if (!is.na(subreddit)) url$query <- append(url$query, list (subreddit = subreddit))
    # if (!is.na(after)) url$query <- append(url$query, list (after = after))
    # if (!is.na(before)) url$query <- append(url$query, list (before = before))
    # if (!is.na(metadata)) url$query <- append(url$query, list (metadata = metadata))
    #
    # # create final url
    # final_url <- httr::build_url(url)

    # build_url() messes up commas in the query parameters so we'll do it manually
    final_url <- api_endpoint

    if (!is.na(q)) final_url <- paste0(final_url, sprintf("q=%s&", q))
    if (!is.na(ids)) final_url <- paste0(final_url, sprintf("ids=%s&", ids))
    if (!is.na(size)) final_url <- paste0(final_url, sprintf("size=%s&", size_to_fetch)) # note differs in each batch
    if (!is.na(fields)) final_url <- paste0(final_url, sprintf("fields=%s&", fields))
    if (!is.na(sort)) final_url <- paste0(final_url, sprintf("sort=%s&", sort))
    if (!is.na(sort_type))  final_url <- paste0(final_url, sprintf("sort_type=%s&", sort_type))
    if (!is.na(author)) final_url <- paste0(final_url, sprintf("author=%s&", author))
    if (!is.na(subreddit)) final_url <- paste0(final_url, sprintf("subreddit=%s&", subreddit))
    if (!is.na(after)) final_url <- paste0(final_url, sprintf("after=%s&", after))
    if (!is.na(before)) final_url <- paste0(final_url, sprintf("before=%s&", before))
    if (!is.na(metadata)) final_url <- paste0(final_url, sprintf("metadata=%s&", metadata))

    # get response
    if (verbose) message(sprintf("Calling API endpoint: %s", final_url))
    resp <- httr::GET(final_url)

    # on error, send warning, return API response for debugging
    if (!httr::status_code(resp) == 200){
      stop (sprintf("Pushshift API returned error code %s.\nFirst few lines of response:\n%s",
                    httr::status_code(resp),
                    httr::content(resp, type = "text/json", encoding = "UTF-8")))
    }

    # parse response
    if (verbose) message("API response good, parsing results..")
    response <- httr::content(resp, type = "text/json", encoding = "UTF-8") %>%
      jsonlite::fromJSON()

    response_data <- response$data %>%
      dplyr::as_tibble() %>%
      dplyr::mutate(dplyr::across(where(is.list), function(x) stringr::str_flatten(as.character(unlist(x)), collapse = ", " ) ))

    # if we got nothing, we're jumping out of the for-loop now
    if (nrow(response_data) == 0) {
      if (verbose) message ("No results found. Stopping now.")
      break
    }

    # add what we found
    all_results <- dplyr::bind_rows(all_results, response_data)

    # update our "before" parameter to only look for earlier results
    before <- min(response_data$created_utc)

    # do a pause if we're not at the last batch
    if (batch < batches) {
      if (verbose) message(sprintf("Pausing for %f seconds...", batch_pause))
      Sys.sleep(batch_pause)
    }

  } # end of batch loop

  # remove any duplicates
  all_results <- dplyr::distinct(all_results)

  # optionally, parse the Unix timestamps into human-readable date-times
  if (parse_utc) {
    all_results <- all_results %>%
      dplyr::mutate(created_datetime = as.POSIXct(created_utc, origin = "1970-01-01"))
  }

  return(all_results)

}



# https://www.reddit.com/r/redditdev/comments/ldje2i/too_many_requests_error_even_though_im_sending/

get_subreddit_info <- function(subreddit, verbose = TRUE){
  # TODO: input validation on subreddit
  # subreddit should be character vector without "r/"

  warning("Reddit's API limits to 60 requests/min for REGISTERED apps. And this one's not registered yet!")

  url <- paste0("https://www.reddit.com/r/",subreddit,"/about.json")

  resp <- httr::GET(url, httr::user_agent(ua_string))


  # on error, send warning, return API response for debugging
  if (!httr::status_code(resp) == 200){
    stop (sprintf("Error code %s.\nFirst few lines of response:\n%s",
                  httr::status_code(resp),
                  httr::content(resp, type = "text/json", encoding = "UTF-8")))
  }

  # parse response
  if (verbose) message("API response good, parsing results..")
  response <- httr::content(resp, type = "text/json", encoding = "UTF-8") %>%
    jsonlite::fromJSON()

  response_data <- response$data %>%
    purrr::map(unlist) %>%
    purrr::map(function(x) if (is.null(x)) {""} else {x}) %>%
    purrr::map(function(x) if(length(x) > 1) {stringr::str_flatten(x, collapse = ",")} else {x}) %>%
    dplyr::as_tibble() %>%
    dplyr::mutate(subreddit = subreddit) %>%
    dplyr::select(subreddit, url, public_description, subscribers, description)


  return(response_data)

}


# https://bookdown.org/Maxine/tidy-text-mining/tokenizing-by-n-gram.html
