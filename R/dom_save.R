#' Opslaan domeintabel
#'
#' Met deze functie is het mogelijk om een domeintabel op te slaan als .xlsx-bestand of als .csv-bestand.
#'
#' @param naam Naam van een domeintabel
#' @param bestandsnaam
#' @param map
#' @param bestandstype
#' @param peildatum
#'
#' @return
#' @export
#'
#' @examples
dom_save <- function(naam,
                     bestandsnaam = paste(Sys.Date(), naam),
                     map = NULL,
                     bestandstype = c("xlsx", "csv"),
                     peildatum = Sys.Date()) {

  bestandstype <- bestandstype[[1]]
  rlang::arg_match(bestandstype, c("xlsx", "csv"))

  dom_tabel <- dom(naam, peildatum)

  if (bestandstype == "xlsx") {
    bestandsnaam <- bestandsnaam %>% stringr::str_remove(".xlsx$") %>% stringr::str_c(".xlsx")
    if (!is.null(map)) bestandsnaam <- file.path(map, bestandsnaam)

    openxlsx::write.xlsx(dom_tabel, file = bestandsnaam)
  }

  if (bestandstype == "csv") {
    bestandsnaam <- bestandsnaam %>% stringr::str_remove(".csv$") %>% stringr::str_c(".csv")
    if (!is.null(map)) bestandsnaam <- file.path(map, bestandsnaam)

    readr::write_csv2(dom_tabel, path = bestandsnaam)
  }

  invisible(dom_tabel)

}

# dom_save("MonsterType", "DEV/test.xlsx", bestandstype = "xlsx")
# x <- dom_save("MonsterType", "DEV/test.xlsx")
# file.remove("DEV/test.xlsx")
#
# dom_save("MonsterType", "DEV/test.csv", "csv", "20000101")
# file.remove("DEV/test.csv")
# dom_save("MonsterType")
# file.remove(paste(Sys.Date(),"MonsterType.xlsx"))
# dom_save("MonsterType", bestandstype = "csv")
# file.remove(paste(Sys.Date(),"MonsterType.csv"))
# dom_save("MonsterType", map = "DEV")
# file.remove(file.path("DEV", paste(Sys.Date(),"MonsterType.xlsx")))
#
# naam <- "MonsterType"
