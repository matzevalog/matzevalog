library(tidyverse)
library(testthat)

test_that("Проверка количества плюсов на полиперсонных памятниках.", {
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    mutate(ru_plus_n = str_count(Name_RU, "\\+"),
           en_plus_n = str_count(Name_EN, "\\+"),
           he_plus_n = str_count(Name_HE, "\\+"),
           he_date_plus_n = str_count(DDate_HE, "\\+"),
           gr_date_plus_n = str_count(DDate_GR, "\\+")) |> 
    filter(ru_plus_n != en_plus_n | en_plus_n != he_plus_n | he_plus_n != he_date_plus_n | he_date_plus_n != gr_date_plus_n) |> 
    select(Number) |> 
    arrange(Number) |> 
    str_glue_data(str_c(str_pad("Неправильное количество плюсов в полиперсонном памятнике с кодом", 100, side = "right"), "{Number}")) ->
    observed
  
  expected <- character(length = length(observed))
  
  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})
