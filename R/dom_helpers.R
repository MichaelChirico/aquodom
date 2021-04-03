# conv_timestamp <- function(timestamp){
#   timestamp %>%
#     as.numeric() %>%
#     as.POSIXct(origin = as.POSIXct("1970-01-01 00:00:00"), tz = "CET") %>%
#     lubridate::as_date()
# }

is_domeintabel <- function(namen){
  overzicht <- dom_overzicht()
  namen %in% overzicht$domeintabel
}


dom_guid <- function(namen){
  overzicht <- dom_overzicht()
  tibble::tibble(namen = namen) %>%
    dplyr::left_join(overzicht, by = c("namen" = "domeintabel")) %>%
    dplyr::pull(guid) %>%
    unname()
}

# dom_elementtype <- function(namen){
#   overzicht <- dom_overzicht()
#   tibble::tibble(namen = namen) %>%
#     dplyr::left_join(overzicht, by = c("namen" = "domeintabel")) %>%
#     dplyr::pull(domeintabelsoort) %>%
#     unname()
# }

dom_kolommen <- function(naam){
  if (length(naam) != 1) stop("`naam` dient een vector met lengte 1 te zijn")

  if (!is_domeintabel(naam)) stop(paste(naam, "is geen geldige domeintabelnaam"))

  overzicht <- dom_overzicht()

  overzicht %>%
    dplyr::filter(domeintabel == naam) %>%
    dplyr::pull(kolommen) %>%
    .[[1]]

}

