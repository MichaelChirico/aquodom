
<!-- README.md is generated from README.Rmd. Please edit that file -->

# aquodom

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/RedTent/aquodom/workflows/R-CMD-check/badge.svg)](https://github.com/RedTent/aquodom/actions)
<!-- badges: end -->

Met *aquodom* is het op eenvoudige wijze mogelijk om de
aquo-domeintabellen te downloaden en te gebruiken in R.

## Installatie

*aquodom* is te installeren vanaf CRAN met (nog niet):

``` r
# Nog niet op CRAN
install.packages("aquodom") 
```

De ontwikkelversie is te installeren van
[GitHub](https://github.com/RedTent/aquodom) met:

``` r
# install.packages("devtools")
devtools::install_github("RedTent/aquodom")
```

## Aquo-domeintabellen

De Aquo-standaard vormt de Nederlandse standaard voor de uitwisseling
van gegevens in het waterbeheer. Met *aquodom* (kort voor
aquo-domeintabellen) is het makkelijk om via de API domeintabellen van
de Aquo-standaard in R te downloaden en te gebruiken.

De belangrijkste functie van *aquodom* is `dom()`. Met deze functie kan
iedere domeintabel van www.aquo.nl worden gedownload. De functie
`dom_overzicht()` geeft een complete lijst van alle beschikbare
domeintabellen. Beide functies hebben een optioneel argument
`peildatum`. Dit argument kan worden gebruikt om alleen domeinwaarden of
domeintabellen te tonen die geldig zijn op de peildatum. Met
`peildatum = NULL` worden alle resultaten inclusief verouderde waarden
getoond.

``` r
library(aquodom)

dom("MonsterType")
#> # A tibble: 7 x 6
#>      id omschrijving   begin_geldigheid eind_geldigheid guid      gerelateerd   
#>   <dbl> <chr>          <date>           <date>          <chr>     <chr>         
#> 1    10 analysemonster 2017-12-13       2100-01-01      Id-6a3e6~ Id-99092d94-d~
#> 2     8 materiaalmons~ 2015-11-18       2100-01-01      Id-f811d~ Id-2d146a3e-3~
#> 3    11 samengevoegd ~ 2017-12-13       2100-01-01      Id-81ce3~ Id-8df42796-7~
#> 4     4 toetsmonster   2015-11-18       2100-01-01      Id-0034d~ Id-ad4f1180-6~
#> 5     9 uitloogmonster 2015-11-18       2100-01-01      Id-6053f~ Id-48826f74-c~
#> 6     1 veldmonster    2015-11-18       2100-01-01      Id-74dd8~ Id-3e9918e3-4~
#> 7     7 zeefmonster    2015-11-18       2100-01-01      Id-8d483~ Id-63ac95ff-1~

# Alle domeinwaarden inclusief verouderde waarden
dom("MonsterType", peildatum = NULL)
#> # A tibble: 8 x 6
#>      id omschrijving   begin_geldigheid eind_geldigheid guid      gerelateerd   
#>   <dbl> <chr>          <date>           <date>          <chr>     <chr>         
#> 1    10 analysemonster 2017-12-13       2100-01-01      Id-6a3e6~ Id-99092d94-d~
#> 2     8 materiaalmons~ 2015-11-18       2100-01-01      Id-f811d~ Id-2d146a3e-3~
#> 3    10 mengmonster    2015-11-18       2017-12-12      Id-a0a78~ <NA>          
#> 4    11 samengevoegd ~ 2017-12-13       2100-01-01      Id-81ce3~ Id-8df42796-7~
#> 5     4 toetsmonster   2015-11-18       2100-01-01      Id-0034d~ Id-ad4f1180-6~
#> 6     9 uitloogmonster 2015-11-18       2100-01-01      Id-6053f~ Id-48826f74-c~
#> 7     1 veldmonster    2015-11-18       2100-01-01      Id-74dd8~ Id-3e9918e3-4~
#> 8     7 zeefmonster    2015-11-18       2100-01-01      Id-8d483~ Id-63ac95ff-1~

dom_overzicht()
#> # A tibble: 126 x 7
#>    domeintabel domeintabelsoort wijzigingsdatum begin_geldigheid eind_geldigheid
#>    <chr>       <chr>            <date>          <date>           <date>         
#>  1 Afsluitmid~ Domeintabel      2020-11-11      2016-03-12       2100-01-01     
#>  2 Bekleding_~ Domeintabel      2020-06-30      2016-03-12       2100-01-01     
#>  3 BekledingT~ Domeintabel      2020-06-30      2016-03-12       2100-01-01     
#>  4 Bekledingl~ Domeintabel      2020-06-30      2016-03-12       2100-01-01     
#>  5 Bemonsteri~ Domeintabel      2020-11-09      2011-06-10       2100-01-01     
#>  6 Bemonsteri~ Domeintabel      2020-06-30      2011-06-11       2100-01-01     
#>  7 Bemonsteri~ Domeintabel      2020-06-30      2011-10-06       2100-01-01     
#>  8 BeschermdG~ Domeintabel      2020-11-09      2011-11-11       2100-01-01     
#>  9 Besturings~ Domeintabel      2020-11-11      2011-10-15       2100-01-01     
#> 10 Bevaarbaar~ Domeintabel      2020-06-30      2011-08-12       2100-01-01     
#> # ... with 116 more rows, and 2 more variables: kolommen <list>, guid <chr>

nrow(dom_overzicht())
#> [1] 126
# inclusief ongeldige domeintabellen
nrow(dom_overzicht(peildatum = NULL))
#> [1] 261
```

## Caching

Het downloaden van grotere domeintabellen kan behoorlijk wat tijd in
beslag nemen. Daarom maakt *aquodom* gebruik van caching. Als een
domeintabel eenmaal is gedownload wordt in dezelfde R-sessie gebruik
gemaakt van de cache. In de documentatie is ook beschreven hoe het
mogelijk is om een persistente cache te maken (voor gevorderden).

``` r
# De eerste keer duurt vrij lang
system.time(dom("Hoedanigheid"))
#> ..
#>    user  system elapsed 
#>    0.22    0.11    6.28

# De tweede keer gaat veel sneller
system.time(dom("Hoedanigheid"))
#>    user  system elapsed 
#>    0.00    0.02    0.02
```
