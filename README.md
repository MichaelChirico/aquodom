
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
aquo-domeintabellen) is het makkelijk om va de API domeintabellen van de
Aquo-standaard in R te downloaden en te gebruiken.

De belangrijkste functie van *aquodom* is `dom()`. Met deze functie kan
iedere domeintabel van aquo.nl worden gedownload. De functie
`dom_overzicht()` geeft een complete lijst van alle beschikbare
domeintabellen. Beide functies hebben een optioneel argument
`peildatum`. Dit argument kan worden gebruikt om alleen domeinwaarden of
domeintabellen te tonen die geldig zijn op de peildatum of alle waarden
met `peildatum = NULL`.

``` r
library(aquodom)

dom("MonsterType")
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
#> # A tibble: 261 x 7
#>    domeintabel domeintabelsoort wijzigingsdatum begin_geldigheid eind_geldigheid
#>    <chr>       <chr>            <date>          <date>           <date>         
#>  1 Aanduiding~ Domeintabel      2020-06-30      2011-08-12       2018-12-10     
#>  2 Aanslag_ty~ Domeintabel      2020-06-30      2011-10-20       2018-12-10     
#>  3 Aanvoereen~ Domeintabel      2020-06-30      2011-08-19       2018-12-10     
#>  4 Aanvoergeb~ Domeintabel      2020-06-30      2011-08-19       2018-12-10     
#>  5 Aanwezig_a~ Domeintabel      2020-06-30      2011-09-08       2018-12-10     
#>  6 Academisch~ Domeintabel      2020-06-30      2011-08-19       2018-12-10     
#>  7 Adellijke_~ Domeintabel      2020-06-30      2011-08-19       2018-12-10     
#>  8 Aflevering~ Domeintabel      2020-06-30      2011-10-22       2018-12-13     
#>  9 Afrasterin~ Domeintabel      2020-06-30      2011-09-10       2011-10-15     
#> 10 Afsluitbar~ Domeintabel      2020-06-30      2011-09-08       2011-10-12     
#> # ... with 251 more rows, and 2 more variables: kolommen <list>, guid <chr>

nrow(dom_overzicht())
#> [1] 261
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
#>    0.19    0.09    2.93

# De tweede keer gaat veel sneller
system.time(dom("Hoedanigheid"))
#>    user  system elapsed 
#>    0.02    0.00    0.01
```
