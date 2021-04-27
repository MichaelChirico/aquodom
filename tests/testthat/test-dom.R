test_that("dom werkt", {
  skip_on_ci()
  skip_on_cran()


  expect_error(dom("test"), "geen geldige")
  monstertype <- dom("MonsterType")
  expect_s3_class(monstertype$begin_geldigheid, "Date")
  expect_s3_class(monstertype$eind_geldigheid, "Date")
  expect_equal(names(monstertype), c("id", "omschrijving", "begin_geldigheid", "eind_geldigheid", "guid","gerelateerd"))

  monstertype <- dom("MonsterType", peildatum = "2021-04-03")
  expect_equal(nrow(monstertype), 7)
  monstertype <- dom("MonsterType", peildatum = as.Date("2021-04-03"))
  expect_equal(nrow(monstertype), 7)

  monstertype <- dom("monstertype", peildatum = as.Date("2021-04-03"))
  expect_equal(nrow(monstertype), 7)

  expect_lt(system.time(dom("MonsterType"))[[3]], 0.5)

})
