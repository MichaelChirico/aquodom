GetDomainTableNames <- function(pCheckDate = toString(Sys.Date())) {
  message(paste("pCheckDate", pCheckDate))

  tekstUrl <- "https://www.aquo.nl/index.php"
  opmaakJson <- paste0("%2F&format=json&link=none&headers=show&searchlabel=JSON&class=sortable+wikitable+smwtable",
    "&theme=bootstrap&offset=0&limit=500",
    "&mainlabel=&prettyprint=true&unescape=true"
  )

  categorie <- "?title=Speciaal:Vragen&x=-5B-5BElementtype%3A%3ADomeintabel%20%7C%7C%20Domeintabeltechnisch%20%7C%7C%20Domeintabelverzamellijst-5D-5D-20"
  kenmerken <- "%2F-3FElementtype%2F-3FVoorkeurslabel%2F-3FMetadata"
  beperking <- paste0("-5B-5BBegin-20geldigheid::<=", pCheckDate, "-5D-5D-5B-5BEind-20geldigheid::>=", pCheckDate, "-5D-5D")
  json_file <- paste0(tekstUrl, categorie, beperking, kenmerken, opmaakJson)
  req <- httr::GET(json_file)

  if (req$status_code != 200 || length(req$content) == 0) {
    message("Geen domeintabellen gevonden")
    return(NULL)

  }

  domeintabellen_json <- jsonlite::fromJSON(httr::content(req, "text", encoding = "UTF-8"))$results

  domeintabellen <- tibble::tibble(domeintabel = purrr::map_chr(domeintabellen_json, list("printouts", "Voorkeurslabel")),
                                   guid        = purrr::map_chr(domeintabellen_json, "fulltext"),
                                   kolommen    = purrr::map(domeintabellen_json, list("printouts", "Metadata")))

  return(domeintabellen)
}

GetDomainTableNames()$kolommen[[1]]

nrow(GetDomainTableNames()) == 132
nrow(GetDomainTableNames("2020-01-01")) == 127
