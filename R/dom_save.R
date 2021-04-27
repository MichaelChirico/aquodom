dom_save <- function(naam, bestandsnaam, bestandstype = c("xlsx", "csv"), peildatum = Sys.Date()) {

  bestandstype <- bestandstype[[1]]
  rlang::arg_match(bestandstype, c("xlsx", "csv"))

  dom_tabel <- dom(naam, peildatum)

  if (bestandstype == "xlsx") {
    bestandsnaam <- bestandsnaam %>% stringr::str_remove(".xlsx$") %>% stringr::str_c(".xlsx")
    openxlsx::write.xlsx(dom_tabel, file = bestandsnaam)
  }

  if (bestandstype == "csv") {
    bestandsnaam <- bestandsnaam %>% stringr::str_remove(".csv$") %>% stringr::str_c(".csv")
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

