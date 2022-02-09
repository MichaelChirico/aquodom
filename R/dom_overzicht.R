#' Overzicht van alle domeintabellen
#'
#' Deze functie geeft een overzicht van alle beschikbare domeintabellen,
#' inclusief historische tabellen, op www.aquo.nl.
#'
#' @param peildatum Date of een character die omgezet kan worden in een Date met
#'   `lubridate::as_date()`. De peildatum filtert de output om alleen geldige
#'   domeintabellen op de peildatum weer te geven. Gebruik `NULL` om alle
#'   domeintabellen ongeacht de geldigheid weer te geven.
#'
#' @section Caching: Deze functie maakt gebruik van caching voor het
#'   optimaliseren van snelheid en om de aquo-server niet onnodig te belasten.
#'   Hiervoor wordt de map `tempdir()` gebruikt als cache. Deze map wordt na
#'   elke R-sessie verwijderd.
#'
#' @return Een tibble met een overzicht van alle domeintabellen. Het overzicht
#'   bevat de volgende kolommen:
#'
#'   - `domeintabel` - Naam van de domeintabel.
#'   - `domeintabelsoort` - Het type domeintabel.
#'   - `wijzigingsdatum` - Datum van de laatste wijziging van de tabel.
#'   - `begin_geldigheid` - Datum van het begin van de geldigheid van de domeintabel.
#'   - `eind_geldigheid` - Datum van het eind van de geldigheid van de domeintabel.
#'   - `kolommen` - Een vector met de kolomnamen van de domeintabel.
#'   - `guid` - De guid van de domeintabel.
#'
#' @family domeintabellen
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' dom_overzicht()
#' dom_overzicht(peildatum = Sys.Date())
#' dom_overzicht(peildatum = "2021-04-05")
#'
#' }
dom_overzicht <- function(peildatum = Sys.Date()){

  dom_overzicht_m <- memoise::memoise(dom_overzicht_basis,
                                      cache = cachem::cache_disk(dir = tempdir()))

  overzicht <- suppressWarnings(dom_overzicht_m())

  if (!is.null(peildatum)) {
    if (class(peildatum) != "Date") {peildatum <- lubridate::as_date(peildatum)}
    overzicht <- overzicht %>% dplyr::filter(begin_geldigheid <= peildatum, eind_geldigheid >= peildatum)
  }
  return(overzicht)
}

dom_overzicht_basis <- function() {

  url <- "https://www.aquo.nl/index.php?title=Speciaal:Vragen&x=[[Elementtype::Domeintabel%20%7C%7C%20Domeintabeltechnisch%20%7C%7C%20Domeintabelverzamellijst]]%20/?Elementtype/?Voorkeurslabel/?Metadata/?Wijzigingsdatum/?Begin%20geldigheid/?Eind%20geldigheid/&format=csv&sep=;&offset=0&limit=500"

  req <- httr::GET(url)

  if (req$status_code != 200 || length(req$content) == 0) {
    message("Geen domeintabellen gevonden")
    return(NULL)
  }

  overzicht <- req %>%
    httr::content(as = "text") %>%
    readr::read_csv2(locale = readr::locale(decimal_mark = ",", grouping_mark = "."), show_col_types = FALSE) %>%
    dplyr::select(domeintabel = Voorkeurslabel,
                  domeintabelsoort = Elementtype,
                  wijzigingsdatum = Wijzigingsdatum,
                  begin_geldigheid = `Begin geldigheid`,
                  eind_geldigheid = `Eind geldigheid`,
                  kolommen = Metadata,
                  guid = ...1 ) %>%
    dplyr::mutate(dplyr::across(.cols = c(wijzigingsdatum, begin_geldigheid, eind_geldigheid),
                                .fns = ~lubridate::as_date(.x, format = "%d %B %Y %H:%M:%S"))) %>%
    dplyr::mutate(kolommen = stringr::str_split(kolommen, ","))

  return(overzicht)
}




