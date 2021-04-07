test_that("is_domeintabel",{
  skip_if(!interactive() )
  expect_equal(is_domeintabel(c("Hoedanigheid", "Domeintabel")), c(TRUE, FALSE))
})

test_that("dom_guid",{
  skip_if(!interactive() )
  expect_equal(dom_guid(c("Hoedanigheid", "Domeintabel")), c("Id-7169dd0a-813b-4cf1-86ab-9bbc52b113a4", NA))
})

test_that("dom_kolommen",{
  skip_if(!interactive() )
  expect_equal(dom_kolommen("MonsterType"), c("Begin geldigheid", "Eind geldigheid", "Gerelateerd", "Id", "Omschrijving"))
})
