.onAttach <- function(libname, pkgname) {
  cache_dir <- tempdir(TRUE)
  dir.exists(cache_dir)
  options(aquodom.cache_dir = cache_dir)

  message("options(aquodom.cache_dir)")
}
