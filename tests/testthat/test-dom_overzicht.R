# Alleen lokaaltesten ivm tijd

test_that("dom_overzicht_basis", {

  skip_if(!interactive())

  expect_gt(nrow(suppressWarnings(dom_overzicht_basis())), 250)
})

test_that("Caching dom_overzicht", {

  skip_if(!interactive())

  dom_overzicht()
  expect_true(system.time(dom_overzicht())[3] < 0.5)
})


test_that("dom_overzicht", {

  skip_if(!interactive())

  overzicht <- dom_overzicht()

  expect_gt(nrow(overzicht), 250)
  expect_equal(nrow(dom_overzicht(peildatum = "2021-04-03")), 126)
  expect_equal(nrow(dom_overzicht(peildatum = as.Date("2021-04-03"))), 126)

  expect_s3_class(overzicht$wijzigingsdatum, "Date")
  expect_s3_class(overzicht$begin_geldigheid, "Date")
  expect_s3_class(overzicht$eind_geldigheid, "Date")
  expect_type(overzicht$kolommen, "list")
  expect_type(overzicht$kolommen[[1]], "character")

})
