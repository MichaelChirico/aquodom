

x <- "https://www.aquo.nl/index.php?title=Speciaal%3AVragen&q=%5B%5BCategorie%3ADomeinwaarden%5D%5D+%5B%5BBreder%3A%3AId-9f956093-baad-4adb-b74d-20c00cef6ab4%5D%5D%5B%5BBegin+geldigheid%3A%3A%3E1+januari+2000%5D%5D%5B%5BEind+geldigheid%3A%3A%3E16-03-2021%5D%5D%0D%0A&po=%3FId%0D%0A%3FOmschrijving%0D%0A%3FBegin+geldigheid%0D%0A%3FEind+geldigheid%0D%0A%3FGerelateerd%0D%0A&eq=yes&p%5Bformat%5D=csv&p%5Bsep%5D=%3B&p%5Bsource%5D=&p%5Blimit%5D=13000&p%5Boffset%5D=&p%5Blink%5D=all&p%5Bsort%5D=&p%5Bheaders%5D=show&p%5Bmainlabel%5D=&p%5Bintro%5D=&p%5Boutro%5D=&p%5Bsearchlabel%5D=%E2%80%A6+overige+resultaten&p%5Bdefault%5D=&format=csv"
res_raw <- readr::read_csv2(x)


domeintabel_guid("MonsterType")
datum_begin <- "2021-03-16"
datum_eind <-  "2021-03-16"
y <- glue::glue("https://www.aquo.nl/index.php?title=Speciaal%3AVragen&q=%5B%5BCategorie%3ADomeinwaarden%5D%5D+%5B%5BBreder%3A%3A{domeintabel_guid('MonsterType')}%5D%5D%5B%5BBegin+geldigheid%3A%3A%3C={datum_begin}%5D%5D%5B%5BEind+geldigheid%3A%3A%3E16-03-2021%5D%5D%0D%0A&po=%3FId%0D%0A%3FOmschrijving%0D%0A%3FBegin+geldigheid%0D%0A%3FEind+geldigheid%0D%0A%3FGerelateerd%0D%0A&eq=yes&p%5Bformat%5D=csv&p%5Bsep%5D=%3B&p%5Bsource%5D=&p%5Blimit%5D=13000&p%5Boffset%5D=&p%5Blink%5D=all&p%5Bsort%5D=&p%5Bheaders%5D=show&p%5Bmainlabel%5D=&p%5Bintro%5D=&p%5Boutro%5D=&p%5Bsearchlabel%5D=%E2%80%A6+overige+resultaten&p%5Bdefault%5D=&format=csv")
res <- readr::read_csv2(y)

all.equal(res_raw, res)


guid <- domeintabel_guid("MonsterType")
datum <-  "2021-03-16"
categorie <- domeintabel_categorie("MonsterType")
kolommen <- paste(domeintabel_kolomnamen("MonsterType"), collapse = "\r\n?")

z <- glue::glue("https://www.aquo.nl/index.php?title=Speciaal:Vragen&q=[[Categorie:{categorie}]]+[[Breder::{guid}]][[Begin+geldigheid::<={datum}]][[Eind+geldigheid::>{datum}]]\r\n&po=?{kolommen}\r\n&eq=yes&p[format]=csv&p[sep]=;&p[source]=&p[limit]=13000&p[offset]=&p[headers]=show&format=csv")

readr::read_csv2(URLencode(z))
