library(tidyverse)
library(testthat)

test_that("Содержит ли поле Tomb_type верную помету или NA", {
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    mutate(Tomb_type = str_remove_all(Tomb_type, "(стела)|(L-образный)|(плита/саркофаг)|(шатёр \\(охель\\))|(индивидуальный)|(табличка)|(неизвестен)")) |> 
    select(Tomb_type, Number) |>
    na.omit() |> 
    filter(Tomb_type != "") |> 
    distinct(Number) |> 
    arrange(Number) |> 
    str_glue_data(str_c(str_pad("Необычное заполнение поля 'Tomb_type' в памятнике с номером", 100, side = "right"), "{Number}")) ->
    observed
  
  expected <- character(length = length(observed))
  
  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})
