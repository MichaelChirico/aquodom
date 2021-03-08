domeintabel_namen_basis <- function(peildatum) {

  verwerk_datum <- function(datum_raw){
    stringr::str_extract(datum_raw, "\\d{4}/\\d{1,}/\\d{1,}/\\d{1,}/\\d{1,}/\\d{1,}") %>%
    lubridate::ymd_hms(tz = "CET")
  }

  # Query samenstellen
  tekstUrl <- "https://www.aquo.nl/index.php"
  opmaakJson <- paste0("%2F&format=json", "&limit=500")
  categorie <- "?title=Speciaal:Vragen&x=-5B-5BElementtype%3A%3ADomeintabel%20%7C%7C%20Domeintabeltechnisch%20%7C%7C%20Domeintabelverzamellijst-5D-5D-20"
  kenmerken <- "%2F-3FElementtype%2F-3FVoorkeurslabel%2F-3FMetadata%2F-3FWijzigingsdatum"
  beperking <- paste0("-5B-5BBegin-20geldigheid::<=", peildatum, "-5D-5D-5B-5BEind-20geldigheid::>=", peildatum, "-5D-5D")

  json_file <- paste0(tekstUrl, categorie, beperking, kenmerken, opmaakJson)
  req <- httr::GET(json_file)

  if (req$status_code != 200 || length(req$content) == 0) {
    message("Geen domeintabellen gevonden")
    return(NULL)
  }

  domeintabellen_json <- jsonlite::fromJSON(httr::content(req, "text", encoding = "UTF-8"))$results

  domeintabellen <- tibble::tibble(domeintabel = purrr::map_chr(domeintabellen_json, list("printouts", "Voorkeurslabel")),
                                   domeintabelsoort = purrr::map_chr(domeintabellen_json, list("printouts", "Elementtype", "fulltext")),
                                   datum_wijziging = purrr::map_chr(domeintabellen_json, list("printouts", "Wijzigingsdatum", "raw")),
                                   kolommen    = purrr::map(domeintabellen_json, list("printouts", "Metadata")),
                                   guid        = purrr::map_chr(domeintabellen_json, "fulltext")) %>%
    dplyr::mutate(datum_wijziging = verwerk_datum(datum_wijziging))

  return(domeintabellen)
}

domeintabel_namen <- function(peildatum = NULL){

  my_cache <- getOption("aquodom.cache_dir")
  domeintabel_namen_m <- memoise::memoise(domeintabel_namen_basis,
                                          cache = cachem::cache_disk(dir = my_cache))

  if (is.null(peildatum)) peildatum <- toString(Sys.Date())

    domeintabel_namen_m(peildatum)
}

is_domeintabel <- function(namen, peildatum = NULL){
  overzicht <- domeintabel_namen(peildatum)
  namen %in% overzicht$domeintabel
}




domeintabel_guid <- function(namen, peildatum = NULL){
  overzicht <- domeintabel_namen(peildatum)
  tibble::tibble(namen = namen) %>%
    dplyr::left_join(overzicht, by = c("namen" = "domeintabel")) %>%
    dplyr::pull(guid) %>%
    unname()

}

domeintabel_elementtype <- function(namen, peildatum = NULL){
  overzicht <- domeintabel_namen(peildatum)
  tibble::tibble(namen = namen) %>%
    dplyr::left_join(overzicht, by = c("namen" = "domeintabel")) %>%
    dplyr::pull(domeintabelsoort) %>%
    unname()

}

domeintabel_kolomnamen <- function(naam, peildatum = NULL){
  if (length(naam) > 1) stop("'naam' dient een vector met lengte 1 te zijn")

  if (!is_domeintabel(naam, peildatum)) stop(paste(naam, "is geen geldige domeintabelnaam"))

  overzicht <- domeintabel_namen(peildatum)

  overzicht %>%
    dplyr::filter(domeintabel == naam) %>%
    dplyr::pull(kolommen) %>%
    .[[1]]

}
