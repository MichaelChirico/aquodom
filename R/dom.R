dom_basis <- function(naam){

  limit <- 500
  offset <- 0
  res <- tibble::tibble()
  while(TRUE){ # break out with break

    dom_deel_url <- create_dom_url(naam, limit, offset)

    deel_res <-
      dom_deel_url %>%
      httr::GET() %>%
      httr::content(as = "text") %>%
      readr::read_csv2(locale = readr::locale(decimal_mark = ",", grouping_mark = "."))

    res <- dplyr::bind_rows(res, deel_res)

    if (nrow(deel_res) < limit) break()

    offset <- offset + limit
    cat(".")
  }
  cat("\n")

  res <-
    res %>%
    dplyr::rename_with(.fn = ~"Guid", .cols = dplyr::any_of("X1")) %>%
    dplyr::rename_with(.fn = function(x) stringr::str_replace(x, pattern = " ", "_")) %>%
    dplyr::rename_with(.fn = stringr::str_to_lower) %>%
    dplyr::mutate(dplyr::across(.cols = dplyr::contains("geldigheid"),
                                .fns = ~lubridate::as_date(.x, format = "%d %B %Y %H:%M:%S"))) %>%
    dplyr::relocate(dplyr::any_of(c("id", "codes", "cijfercode", "omschrijving", "begin_geldigheid", "eind_geldigheid")))

  return(res)
}

dom <- function(naam, peildatum = NULL) {
  if (length(naam) != 1) stop("`naam` dient een vector met lengte 1 te zijn")
  if (!is_domeintabel(naam)) stop(paste(naam, "is geen geldige domeintabelnaam"))

  my_cache <- getOption("aquodom.cache_dir")
  dom_m <- memoise::memoise(dom_basis, cache = cachem::cache_disk(dir = my_cache))

  domeintabel <- suppressWarnings(dom_m(naam))

  if (!is.null(peildatum)) {
    if (!"begin_geldigheid" %in% names(domeintabel) | !"eind_geldigheid" %in% names(domeintabel)) {
      stop("Voor deze tabel is geen begin_geldigheid of eind_geldigheid beschikbaar")
    }
    if (class(peildatum) != "Date") {peildatum <- lubridate::as_date(peildatum)}
    domeintabel <- domeintabel %>% dplyr::filter(begin_geldigheid <= peildatum, eind_geldigheid >= peildatum)

  }

  return(domeintabel)
}
