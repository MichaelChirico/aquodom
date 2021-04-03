# Alleen lokaaltesten ivm tijd

test_that("dom_overzicht_basis", {
  # skip("Duurt relatief lang")
  skip_on_cran()

  expect_gt(nrow(suppressWarnings(dom_overzicht_basis())), 250)
})

test_that("Caching dom_overzicht", {
  # skip("Duurt relatief lang")
  skip_on_cran()
  dom_overzicht()
  expect_true(system.time(dom_overzicht())[3] < 0.5)
})


