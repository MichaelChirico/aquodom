pDomeintabel <- "Hoedanigheid"
pDomeintabel <- "MonsterType"
pCheckDate <- toString(Sys.Date())
peildatum <- toString(Sys.Date())

GetDomainTable("MonsterType")


GetDomainTable <- function(pDomeintabel, peildatum = toString(Sys.Date())) {
  message(paste("pCheckDate", peildatum))

  # toevoegen check is_domeintabel

  # bewerkDatum <- function(pDatum) {
  #   lDatum <- substring(toString(pDatum), 3, nchar(pDatum))
  #   lDatum <- stringr::str_replace(lDatum, "/0/0/0/0", "")
  #   lDatum <- toString(lubridate::parse_date_time(lDatum, orders = "ymd"))
  #   return(lDatum)
  # }

  tekstUrl <- "https://www.aquo.nl/index.php"

  domeinwaardeCategorie <- c("Domeintabel" = "Domeinwaarden",
                             "Domeintabeltechnisch" = "DomeinwaardenTechnisch",
                             "Domeintabelverzamellijst" = "Domeinwaarden")

  domeinGuid <- domeintabel_guid(pDomeintabel, peildatum)
  domeinElementtype <- domeintabel_elementtype(pDomeintabel, peildatum)

  # Bepalen Metadata van de domeintabel
  lMetadata <- domeintabel_kolomnamen(pDomeintabel, peildatum)
  lMetadata <- unique(c(lMetadata, "Status", "Wijzigingsnummer"))

  lTypeTabel <- paste0("-5B-5BElementtype%3A%3A", domeinElementtype, "-5D-5D-20")
  beperking <- paste0("-5B-5BBreder%3A%3A", gsub("-", "-2D", domeinGuid), "-5D-5D",
                      "-5B-5BBegin-20geldigheid::<=", peildatum, "-5D-5D-5B-5BEind-20geldigheid::>=", peildatum, "-5D-5D")
  categorie <- paste0("?title=Speciaal:Vragen&x=-5B-5BCategorie%3A",
                      domeinwaardeCategorie[domeinElementtype], "-5D-5D-20")
  kenmerken <- paste0("%2F-3F", lMetadata, collapse = "")

  lOffset <- 0
  lLimit <- 500
  lDoorgaan <- TRUE
  json_res <- list()
  while (lDoorgaan) {
    opmaakJson <- paste0("/format%3Djson/link%3Dall/headers%3Dshow/searchlabel=JSON/class=sortable-20wikitable-20smwtable",
                        "/sort%3DId/order%3Dasc",
                        "/theme=bootstrap/offset=", lOffset, "/limit=", lLimit,
                        "/mainlabel=/prettyprint=true/unescape=true")
    json_file <- paste0(tekstUrl, categorie, beperking, kenmerken, opmaakJson)
    # message(paste("Domeinwaarden:",json_file))
    req <- httr::GET(json_file, curl = curl::new_handle())
    if (req$status_code == 200 && length(req$content) > 0) {

      domValuesJson <- jsonlite::fromJSON(httr::content(req, "text", encoding = "UTF-8"))$results
      json_res <- c(json_res, domValuesJson)
      # message(length(domValuesJson))
      message(paste(toString(Sys.time()), "Aantal waarden opgehaald:", length(domValuesJson) + lOffset, sep = " "))

      if (length(domValuesJson) == lLimit) {
        lOffset <- lOffset + lLimit
      }
      else {
        lDoorgaan <- FALSE
      }
    }
  }

  # return(json_res)
  extract_dom_table(json_res)
}

GetDomainTable("MonsterType")
GetDomainTable("Hoedanigheid")

conv_timestamp <- function(timestamp){
  timestamp %>%
    as.numeric() %>%
    as.POSIXct(origin = as.POSIXct("1970-01-01 00:00:00"), tz = "CET") %>%
    lubridate::as_date()
}

extract_dom_table <- function(x) {

    tibble::tibble(x) %>%
    tidyr::unnest_wider(x) %>%
    dplyr::rename(Guid = fulltext) %>%
    dplyr::select(printouts, Guid) %>%
    tidyr::unnest_wider(printouts) %>%
    dplyr::mutate(`Begin geldigheid` = purrr::map_chr(`Begin geldigheid`, "timestamp") %>% conv_timestamp(),
                  `Eind geldigheid` = purrr::map_chr(`Eind geldigheid`, "timestamp") %>% conv_timestamp()) %>%
    dplyr::relocate(matches("^Id$")) %>%
    dplyr::select(-dplyr::any_of("Gerelateerd"))



    # tidyr::unnest_wider(`Begin geldigheid`) %>%
    # dplyr::mutate(`Begin geldigheid` = conv_timestamp(timestamp)) %>%
    # dplyr::select(-timestamp, -raw) %>%
    # tidyr::unnest_wider(`Eind geldigheid`) %>%
    # dplyr::mutate(`Eind geldigheid` = conv_timestamp(timestamp)) %>%
    # dplyr::select(-timestamp, -raw) %>%
    # tidyr::hoist(Gerelateerd, "fulltext")

}

extract_dom_table(x)
tibble::tibble(y)


GetDomainTable("Bemonsteringsapparaat")
GetDomainTable("Bemonsteringsapparaat")
z_old <- GetDomainTable_old("Waarnemingssoort") %>% tibble::tibble()

GetDomainTable("Parameter")
z <- GetDomainTable("Waarnemingssoort")
b <- GetDomainTable("Biotaxon")
b_old <- GetDomainTable_old("Biotaxon")
