dom_overzicht_basis <- function() {

  url <- "https://www.aquo.nl/index.php?title=Speciaal:Vragen&x=[[Elementtype::Domeintabel%20%7C%7C%20Domeintabeltechnisch%20%7C%7C%20Domeintabelverzamellijst]]%20/?Elementtype/?Voorkeurslabel/?Metadata/?Wijzigingsdatum/?Begin%20geldigheid/?Eind%20geldigheid/&format=csv&sep=;&offset=0&limit=500"

  req <- httr::GET(url)

  if (req$status_code != 200 || length(req$content) == 0) {
    message("Geen domeintabellen gevonden")
    return(NULL)
  }

  overzicht <- req %>%
    httr::content(as = "text") %>%
    readr::read_csv2(locale = readr::locale(decimal_mark = ",", grouping_mark = ".")) %>%
    dplyr::select(domeintabel = Voorkeurslabel, domeintabelsoort = Elementtype,
                  wijzigingsdatum = Wijzigingsdatum, begin_geldigheid = `Begin geldigheid`,
                  eind_geldigheid = `Eind geldigheid`, kolommen = Metadata, guid = X1 ) %>%
    # dplyr::rename_with(.fn = ~"Guid", .cols = dplyr::any_of("X1")) %>%
    # dplyr::rename_with(.fn = function(x) stringr::str_replace(x, pattern = " ", "_")) %>%
    # dplyr::rename_with(.fn = stringr::str_to_lower) %>%
    dplyr::mutate(dplyr::across(.cols = c(wijzigingsdatum, begin_geldigheid, eind_geldigheid),
                                .fns = ~lubridate::as_date(.x, format = "%d %B %Y %H:%M:%S"))) %>%
    dplyr::mutate(kolommen = stringr::str_split(kolommen, ","))


  return(overzicht)
}



dom_overzicht <- function(){

  my_cache <- getOption("aquodom.cache_dir")
  dom_overzicht_m <- memoise::memoise(dom_overzicht_basis,
                                          cache = cachem::cache_disk(dir = my_cache))

  dom_overzicht_m()
}

dom_overzicht()
