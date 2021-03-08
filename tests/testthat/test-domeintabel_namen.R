# Alleen lokaaltesten ivm tijd

test_that("domeintabel_namen_basis", {
  # skip("Duurt relatief lang")
  skip_on_cran()

  expect_equal(nrow(domeintabel_namen_basis("2020-01-01")), 127)
})

test_that("Caching domeintabel_namen", {
  # skip("Duurt relatief lang")
  skip_on_cran()
  domeintabel_namen()
  expect_true(system.time(domeintabel_namen())[3] < 0.5)
})

test_that("is_domeintabel",{
  skip_on_cran()
  expect_equal(is_domeintabel(c("Hoedanigheid", "Domeintabel")), c(TRUE, FALSE))
})

test_that("domeintabel_guid",{
  skip_on_cran()
  expect_equal(domeintabel_guid(c("Hoedanigheid", "Domeintabel")), c("Id-7169dd0a-813b-4cf1-86ab-9bbc52b113a4", NA))
})
