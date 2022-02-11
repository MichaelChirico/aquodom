# Alleen lokaaltesten ivm tijd

test_that("dom_overzicht_basis", {

  skip_on_ci()
  skip_on_cran()

  expect_gt(nrow(suppressWarnings(dom_overzicht_basis())), 250)
})

test_that("Caching dom_overzicht", {

  skip_on_ci()
  skip_on_cran()

  dom_overzicht()
  expect_true(system.time(dom_overzicht())[3] < 0.5)
})


test_that("dom_overzicht", {

  skip_on_ci()
  skip_on_cran()

  overzicht <- dom_overzicht()

  expect_gt(nrow(dom_overzicht(NULL)), 250)
  expect_equal(nrow(dom_overzicht(peildatum = "2021-04-03")), 132)
  expect_equal(nrow(dom_overzicht(peildatum = as.Date("2021-04-03"))), 132)

  expect_s3_class(overzicht$wijzigingsdatum, "Date")
  expect_s3_class(overzicht$begin_geldigheid, "Date")
  expect_s3_class(overzicht$eind_geldigheid, "Date")
  expect_type(overzicht$kolommen, "list")
  expect_type(overzicht$kolommen[[1]], "character")

})
