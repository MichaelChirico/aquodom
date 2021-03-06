# Alleen lokaaltesten ivm tijd

test_that("domeintabel_namen_basis", {
  skip("Duurt relatief lang")
  expect_equal(nrow(domeintabel_namen_basis("2020-01-01")), 127)
})

test_that("Caching domeintabel_namen", {
  skip("Duurt relatief lang")

  domeintabel_namen()
  expect_true(system.time(domeintabel_namen())[3] < 0.5)
})

test_that("is_domeintabel",{
  expect_equal(is_domeintabel(c("Hoedanigheid", "Domeintabel")), c(TRUE, FALSE))
})
