library(tidyverse)
library(testthat)

test_that("Правильно ли заполнено поле Decor code", {
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    mutate(Decor_code = str_remove_all(Decor_code, "(архитектурно-орнаментальный)|(эпиграфический)|(растительный)|(зооморфный)|(антропоморфный)|(портретный)|(предметно-бытовой)|(традиционная символика)|(другое)|([-])|([,\\s])")) |> 
    select(Decor_code, Number) |> 
    na.omit() |> 
    filter(Decor_code != "") |> 
    distinct(Number) |> 
    arrange(Number) |> 
    str_glue_data(str_c(str_pad("Необычное заполнение поля 'Decor_code' в памятнике с номером", 100, side = "right"), "{Number}")) ->
    observed
  
  expected <- character(length = length(observed))
  
  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})
