test_that("is_domeintabel",{
  skip_on_ci()
  skip_on_cran()

  expect_equal(is_domeintabel(c("Hoedanigheid", "Domeintabel")), c(TRUE, FALSE))
  expect_true(is_domeintabel("Academische_titel"))
  expect_true(is_domeintabel("monstertype"))
})

test_that("dom_guid",{
  skip_on_ci()
  skip_on_cran()

  expect_equal(dom_guid(c("Hoedanigheid", "Domeintabel")), c("Id-7169dd0a-813b-4cf1-86ab-9bbc52b113a4", NA))
  expect_equal(dom_guid("hoedanigheid"), c("Id-7169dd0a-813b-4cf1-86ab-9bbc52b113a4"))
})

test_that("dom_kolommen",{
  skip_on_ci()
  skip_on_cran()

  expect_equal(dom_kolommen("MonsterType"), c("Begin geldigheid", "Eind geldigheid", "Gerelateerd", "Id", "Omschrijving"))
  expect_equal(dom_kolommen("monstertype"), c("Begin geldigheid", "Eind geldigheid", "Gerelateerd", "Id", "Omschrijving"))
})
