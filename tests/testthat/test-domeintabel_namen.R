# Alleen lokaaltesten ivm tijd

test_that("dom_overzicht_basis", {
  # skip("Duurt relatief lang")
  skip_on_cran()

  expect_gt(nrow(dom_overzicht_basis()), 250)
})

test_that("Caching dom_overzicht", {
  # skip("Duurt relatief lang")
  skip_on_cran()
  dom_overzicht()
  expect_true(system.time(dom_overzicht())[3] < 0.5)
})

test_that("is_domeintabel",{
  skip_on_cran()
  expect_equal(is_domeintabel(c("Hoedanigheid", "Domeintabel")), c(TRUE, FALSE))
})

test_that("domeintabel_guid",{
  skip_on_cran()
  expect_equal(dom_guid(c("Hoedanigheid", "Domeintabel")), c("Id-7169dd0a-813b-4cf1-86ab-9bbc52b113a4", NA))
})
