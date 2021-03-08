pDomeintabel <- "Hoedanigheid"
pCheckDate <- toString(Sys.Date())
peildatum <- toString(Sys.Date())

GetDomainTable("MonsterType")

GetDomainTable <- function(pDomeintabel, peildatum = toString(Sys.Date())) {
  message(paste("pCheckDate", peildatum))

  # toevoegen check is_domeintabel

  bewerkDatum <- function(pDatum) {
    lDatum <- substring(toString(pDatum), 3, nchar(pDatum))
    lDatum <- stringr::str_replace(lDatum, "/0/0/0/0", "")
    lDatum <- toString(lubridate::parse_date_time(lDatum, orders = "ymd"))
    return(lDatum)
  }

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

  columnNames <- list(lMetadata)
  for (i in 1:length(lMetadata)) columnNames[[i]] <- lMetadata[i]
  columnNames[[length(columnNames) + 1]] <- "Guid"
  domValuesDFloc <- data.frame(matrix(ncol = length(lMetadata) + 1, nrow = 0))
  colnames(domValuesDFloc) <- columnNames

  lOffset <- 0
  lLimit <- 500
  lDoorgaan <- TRUE
  while (lDoorgaan) {
    opmaakJson <- paste("/format%3Djson/link%3Dall/headers%3Dshow/searchlabel=JSON/class=sortable-20wikitable-20smwtable",
                        "/sort%3DId/order%3Dasc",
                        "/theme=bootstrap/offset=", lOffset, "/limit=", lLimit,
                        "/mainlabel=/prettyprint=true/unescape=true",
                        sep = ""
    )
    json_file <- paste0(tekstUrl, categorie, beperking, kenmerken, opmaakJson)
    # message(paste("Domeinwaarden:",json_file))
    req <- httr::GET(json_file, curl = curl::new_handle())
    if (req$status_code == 200 && length(req$content) > 0) {
      gevonden <- TRUE
      tryCatch(
        {
          domValuesJson <- jsonlite::fromJSON(httr::content(req, "text", encoding = "UTF-8"))$results
          # message(length(domValuesJson))
          message(paste(toString(Sys.time()), "Aantal waarden opgehaald:", length(domValuesJson) + lOffset, sep = " "))
        },
        warning = function(w) {
          gevonden <<- FALSE
        },
        error = function(e) {
          gevonden <<- FALSE
        },
        finally = {
        }
      )
      if (gevonden) {
        for (i in 1:length(domValuesJson)) {
          j <- i + lOffset
          domValuesDFloc[j, "Guid"] <- domValuesJson[[i]]$fulltext
          lColumns <- colnames(domValuesDFloc)
          lColumns <- lColumns[!lColumns %in% c("Guid")]
          for (x in lColumns) {
            if (length(unlist(domValuesJson[[i]]$printouts[x]) > 0 && is.na(unlist(domValuesJson[[i]]$printouts[x])))) {
              if (x == "Begin geldigheid" || x == "Eind geldigheid") {
                domValuesDFloc[j, x] <- unlist(domValuesJson[[i]]$printouts[x][[1]]$raw) # bewerkDatum(unlist(domValuesJson[[i]]$printouts[x][[1]]$raw))
                domValuesDFloc[j, x] <- bewerkDatum(unlist(domValuesJson[[i]]$printouts[x][[1]]$raw))
              }
              else {
                if (x == "Gerelateerd") {
                  if (length(unlist(domValuesJson[[i]]$printouts["Gerelateerd"][[1]]$fulltext)) > 0) {
                    gerelateerd <- NULL
                    for (k in 1:length(unlist(domValuesJson[[i]]$printouts["Gerelateerd"][[1]]$fulltext))) {
                      # message("er is lengte")
                      if (k == 1) {
                        gerelateerd <- unlist(domValuesJson[[i]]$printouts["Gerelateerd"][[1]]$fulltext[1])
                      }
                      else {
                        # message("lengte > 1")
                        gerelateerd <- paste(gerelateerd, unlist(domValuesJson[[i]]$printouts["Gerelateerd"][[1]]$fulltext[k]), sep = ",")
                      }
                    }
                    # message(gerelateerd)
                    domValuesDFloc[j, x] <- gerelateerd
                  }
                }
                else {
                  domValuesDFloc[j, x] <- toString(unlist(domValuesJson[[i]]$printouts[x]))
                }
              }
            }
          }
        }
        if (length(domValuesJson) == lLimit) {
          lOffset <- lOffset + lLimit
        }
        else {
          lDoorgaan <- FALSE
        }
      }
    }
    else {
      lDoorgaan <- FALSE
      message("Domeinwaarden bestaat niet")
    }
  }
  domValuesDFloc$Id <- as.numeric(domValuesDFloc$Id)
  domValuesDFloc <- domValuesDFloc[order(domValuesDFloc$Id), ]
  # domValuesDFloc <- domValuesDFloc2

  return(domValuesDFloc)
}

GetDomainTable("MonsterType")
