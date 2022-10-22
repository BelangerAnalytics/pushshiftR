
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pushshiftR

<!-- badges: start -->

[![R-CMD-check](https://github.com/belangeranalytics/pushshiftR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/belangeranalytics/pushshiftR/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of pushshiftR is to make it easy to query the Push Shift Reddit
comment search API.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("BelangerAnalytics/pushshiftR")
```

## Example

This is a basic example which shows you how to do a basic query:

``` r
library(pushshiftR)

# query the PushShift API
results <- pushshiftR::get_reddit_comments(q = '"quantum field theory"', size = 10, verbose = FALSE)

# print the results (with some trimming/formatting to make a nice table)
results %>%
  dplyr::select(author, subreddit, body, created_datetime ) %>%
  dplyr::mutate(body = stringr::str_trunc(body, width = 200)) %>%
  dplyr::mutate(body = stringr::str_replace_all(body, "\\n", " ")) %>%
  knitr::kable()
```

| author       | subreddit          | body                                                                                                                                                                                                    | created_datetime    |
|:-------------|:-------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------------------|
| Lala5th      | AskPhysics         | I am not really sure what you are looking for. If it is something about the philosophical aspects of the concept then it is probably not the right subreddit. If asking about the physical aspect, t…   | 2022-10-22 14:09:22 |
| gliesedragon | AskPhysics         | I’ve seen a lot of quantum field theory stuff brought up as an application of abstract algebra, but I’m coming at it more from the pure math side of things and the specifics of physics part are not…  | 2022-10-22 10:38:38 |
| HattedFerret | Physics            | Many of the crackpots start out as people genuinely and deeply interested in some deep problem. That is respectable. They only start to go down the path towards becoming a crackpot when they sit do…  | 2022-10-22 10:01:43 |
| Morbius2271  | Funnymemes         | Have you read all these experiments? Tried them yourself? Or do you have faith? I’m not trying to prove God to you, that’s just not how it works. I’m not trying to disprove science either. I’m try…   | 2022-10-21 14:40:35 |
| 11zaq        | TheoreticalPhysics | Perhaps what you’re looking for are the Schwinger-Dyson equations. Basically, let L’\_i be the variation of the Lagrangian, i.e. the equations of motion for a classical field O_i. Then the Schwinger… | 2022-10-21 13:37:11 |
| MaoGo        | QuantumComputing   | The consensus is that you can derive equations of larger things from smaller things. So yeah in principle we should be able to start from quantum field theory (and GR) and recover all macroscopic l…  | 2022-10-21 08:47:40 |
| PlayerBrat   | dankmemes          | It can, if u studied mathematics. 0 = 1 + (-1). Something CAN come out of nothing. The quantum field theory has a very good explanation regarding this. A very common (but not quite accurate) wa…      | 2022-10-21 07:09:28 |
| vaitum       | AskWomen           | Other people that are only about a few years older than you. They think they have all the brains in the world. I’m not listening to bullshit they say unless they can give me a 100% accurate and de…   | 2022-10-21 03:50:47 |
| DrXaos       | aliens             | No such thing there is. This zero point energy business is a misunderstanding of quantum field theory. There is indeed some vacuum state which has physical effects which have been measured. But u…    | 2022-10-20 11:16:20 |
| EigenJim     | physicsmemes       | Quantum (field) theory in curved spacetime &#x200B; Elon becomes Missigno in Cinnabar Islands                                                                                                           | 2022-10-20 10:52:21 |
