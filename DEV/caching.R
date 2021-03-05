# library(tidyverse)

source("DEV/GetDomainTableNames.R")

# options(aquodom.cache = cachem::cache_mem(max_size = 1024 * 1024^2))
#
#
#
# my_cache = cachem::cache_mem(max_size = 1024 * 1024^2)



domeintabel_namen <- function(peildatum = NULL){
  my_cache <- getOption("aquodom.cache_dir")
  domeintabel_namen_m <- memoise::memoise(GetDomainTableNames, cache = cachem::cache_disk(dir = my_cache))
  if (is.null(peildatum)) peildatum <- toString(Sys.Date())
  domeintabel_namen_m(peildatum)
}



system.time(
  y <- domeintabel_namen("2020-01-01")
)

# domeintabel_namen <- function(peildatum = NULL){
#   domeintabel_namen_m <- memoise::memoise(GetDomainTableNames, cache = my_cache)
#   if (is.null(peildatum)) peildatum <- toString(Sys.Date())
#   domeintabel_namen_m(peildatum)
# }

# domeintabel_namen_m <-  memoise::memoise(GetDomainTableNames)


system.time(
  GetDomainTableNames()
            )


microbenchmark::microbenchmark(
  GetDomainTableNames("2020-01-01"),
  domeintabel_namen("2020-01-01"), times = 10
)

env_fun <- function(){
  test <<- new.env()
}
env_fun()
search()
x <- new.env()
x
test
env_fun()
test
