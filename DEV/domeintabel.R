url_orig <- "https://www.aquo.nl/index.php?title=Speciaal%3AVragen&q=%5B%5BCategorie%3ADomeinwaarden%5D%5D+%5B%5BBreder%3A%3AId-9f956093-baad-4adb-b74d-20c00cef6ab4%5D%5D%5B%5BBegin+geldigheid%3A%3A%3E1+januari+2000%5D%5D%5B%5BEind+geldigheid%3A%3A%3E29-03-2021%5D%5D%0D%0A&po=%3FId%0D%0A%3FOmschrijving%0D%0A%3FBegin+geldigheid%0D%0A%3FEind+geldigheid%0D%0A%3FGerelateerd%0D%0A&eq=yes&p%5Bformat%5D=csv&p%5Bsep%5D=%3B&sort_num=&order_num=ASC&p%5Bsource%5D=&p%5Blimit%5D=13000&p%5Boffset%5D=&p%5Blink%5D=all&p%5Bsort%5D=&p%5Bheaders%5D=show&p%5Bmainlabel%5D=&p%5Bintro%5D=&p%5Boutro%5D=&p%5Bsearchlabel%5D=%E2%80%A6+overige+resultaten&p%5Bdefault%5D=&p%5Bclass%5D=sortable+wikitable+smwtable&p%5Btheme%5D=bootstrap&eq=yes&format=csv"

utils::URLdecode(url_orig)

url_dec <- "https://www.aquo.nl/index.php?title=Speciaal:Vragen&q=[[Categorie:Domeinwaarden]]+[[Breder::Id-9f956093-baad-4adb-b74d-20c00cef6ab4]][[Begin+geldigheid::>1+januari+2000]][[Eind+geldigheid::>29-03-2021]]\r\n&po=?Id\r\n?Omschrijving\r\n?Begin+geldigheid\r\n?Eind+geldigheid\r\n?Gerelateerd\r\n&eq=yes&p[format]=csv&p[sep]=;&sort_num=&order_num=ASC&p[source]=&p[limit]=13000&p[offset]=&p[link]=all&p[sort]=&p[headers]=show&p[mainlabel]=&p[intro]=&p[outro]=&p[searchlabel]=â€¦+overige+resultaten&p[default]=&p[class]=sortable+wikitable+smwtable&p[theme]=bootstrap&eq=yes&format=csv"

readr::read_csv2(url_orig)

url_dec_orig <- paste0(
"https://www.aquo.nl/index.php?",
"title=Speciaal:Vragen",
"&q=[[Categorie:Domeinwaarden]]",
"+[[Breder::Id-9f956093-baad-4adb-b74d-20c00cef6ab4]]",
"[[Begin+geldigheid::>1+januari+2000]]",
"[[Eind+geldigheid::>29-03-2021]]",
"\r\n&po=?Id\r\n?Omschrijving\r\n?Begin+geldigheid\r\n?Eind+geldigheid\r\n?Gerelateerd\r\n",
"&eq=yes",
"&p[format]=csv",
"&p[sep]=;",
"&sort_num=",
"&order_num=ASC",
"&p[source]=",
"&p[limit]=13000",
"&p[offset]=",
"&p[link]=all",
"&p[sort]=",
"&p[headers]=show",
"&p[mainlabel]=",
"&p[intro]=",
"&p[outro]=",
"&p[searchlabel]=â€¦+overige+resultaten",
"&p[default]=",
"&p[class]=sortable+wikitable+smwtable",
"&p[theme]=bootstrap",
"&eq=yes",
"&format=csv"
)

url_dec <- paste0(
  "https://www.aquo.nl/index.php?",
  "title=Speciaal:Vragen",
  "&q=",
  # "[[Categorie:Domeinwaarden]]",
  # "+[[Breder::Id-9f956093-baad-4adb-b74d-20c00cef6ab4]]",
  # "[[Begin+geldigheid::>1+januari+2000]]",
  "[[Eind+geldigheid::>29-03-2021]]",
  "\r\n&po=?Id\r\n?Omschrijving\r\n?Begin+geldigheid\r\n?Eind+geldigheid\r\n?Gerelateerd\r\n",
  "&p[format]=csv",
  "&p[sep]=;",
  "&p[limit]=13000",
  "&p[offset]="
)

con_orig <- open(URLencode(url_dec_orig))

# readr::read_csv2(URLencode(url_dec))
suppressWarnings( suppressMessages(
  all.equal(readr::read_csv2(URLencode(url_dec)), readr::read_csv2(URLencode(url_dec_orig)))
))

readr::read_csv2(httr::content(httr::GET(URLencode(url_dec_orig)), as = "text") )
