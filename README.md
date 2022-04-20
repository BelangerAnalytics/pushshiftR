
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pushshiftR

<!-- badges: start -->

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

| author         | subreddit            | body                                                                                                                                                                                                    | created\_datetime   |
| :------------- | :------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :------------------ |
| Barycenter0    | astrophysics         | As u/mfb- noted, putting too much thought on the virtual particles being the mechanism is a bit of physics hand-waving. What really is happening under the hood with relativistic quantum field theo…   | 2022-04-20 14:08:54 |
| NearlyFreeFall | AskReddit            | \> Feynman diagrams \> A Feynman diagram is a representation of quantum field theory processes in terms of particle interactions.                                                                       | 2022-04-20 13:43:49 |
| ancientright   | globeskepticism      | \> WiFi, where does to come from? If there is a flat earth, then there is no space and therefore no satellites. Fiber-Optic Cables. \> We also know space exists because a dome as suggested by many …  | 2022-04-20 13:10:45 |
| Bulbasaur2000  | Physics              | The problems you raised are true for all of quantum field theory, not just gravity                                                                                                                      | 2022-04-20 12:39:40 |
| CimmerianHydra | physicsmemes         | Well it really depends on how those courses are spun. If you do nuclear physics, and the course is geared towards how to use them in applications, it’s a more engineering type course than a physics…  | 2022-04-20 10:40:43 |
| FalloutHUN     | AskReddit            | Quantum field theory: If you go down the rabbit hole of links until you understand the whole page, your hair turns white.                                                                               | 2022-04-20 08:47:14 |
| NicolBolas96   | Physics              | \>One major part is that it doesn’t play well with gravity. In particular, it can’t be reconciled with general relativity, as far as we can tell. Dirac was able to make it work with special relativi… | 2022-04-20 08:35:03 |
| sharkysharkie  | AteistTurk           | Paragrafin ikinci kismi oldukça ilginç devam ediyor. Su ana dek uygulanan taktik belli: verebilecek bir cevap yoksa, kafa karisikligi yaratan bir bütün olarak anlam içermeyen bir karsilik ver ve ka…  | 2022-04-19 20:53:55 |
| feltsandwich   | Meditation           | A better way to say this is “nothing can be separated from anything else within the universe, and nothing can be outside the universe.” It’s an illusion because to us, the universe appears dualist…   | 2022-04-19 18:28:33 |
| Away-Event5    | confidentlyincorrect | \>Quantum field theory is a different, more accurate model. Which is entirely mathematical, once again. \>Mathematics is not objective reality Perhaps. But can you name a strictly non-mathematical…   | 2022-04-19 16:28:46 |
