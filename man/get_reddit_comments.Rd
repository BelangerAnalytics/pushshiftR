% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/methods.R
\name{get_reddit_comments}
\alias{get_reddit_comments}
\title{Search Reddit comments using the PushShift API}
\usage{
get_reddit_comments(
  q = NA,
  ids = NA,
  size = 25,
  fields = NA,
  sort = c("created_utc", "score", "num_comments"),
  aggs = NA,
  author = NA,
  subreddit = NA,
  after = NA,
  before = NA,
  frequency = NA,
  metadata = FALSE,
  batch_pause = 1,
  parse_utc = TRUE,
  verbose = TRUE
)
}
\arguments{
\item{q}{Search term. String / Double-quoted String for phrases.}

\item{ids}{Get specific comments via their ids. Comma-delimited base36 ids.}

\item{size}{Number of results to return. Default is 25; values > 100 handled through batching.}

\item{fields}{Return specific fields, either comma-delimited string or character vector. Default is all fields returned. Date/time created is always returned.}

\item{sort}{Sort by a specific attribute. "score", "num_comments", "created_utc"}

\item{aggs}{Return aggregation summary. \emph{DISABLED BY PUSHSHIFT DUE TO SERVER LOAD}}

\item{author}{Restrict to a specific author.}

\item{subreddit}{Restrict to a specific subreddit.}

\item{after}{Return results after this date. Epoch value or Integer + "s,m,h,d" (i.e. 30d for 30 days)}

\item{before}{Return results before this date. Epoch value or Integer + "s,m,h,d" (i.e. 30d for 30 days)}

\item{frequency}{Used with the aggs parameter when set to created_utc. \emph{DISABLED BY PUSHSHIFT DUE TO SERVER LOAD}}

\item{metadata}{display metadata about the query. Default false.}

\item{batch_pause}{Pause between batches in seconds. Default is 1s.}

\item{parse_utc}{Boolean flag: parse UTC timestamps into human-readable date-times? Default TRUE.}

\item{verbose}{Debug boolean flag to enable/disable message logging to the console.}
}
\value{
A data frame with class \code{tbl_df} with on row for each comment returned by the API.
}
\description{
Query the PushShift API to search Reddit comments. Does some minimal input
validation and massaging for quality-of-life. Incorporates polite batching,
since the API will only return 100 results at a time.
}
\examples{
\dontrun{test <- get_reddit_comments(q = "coffee maker", size = 250)}
}
