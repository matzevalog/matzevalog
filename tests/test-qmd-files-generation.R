library(tidyverse)
library(testthat)

test_that("Проверка генерации qmd-файлов.", {
  
  list.files("../tombstones/") |> 
    str_remove("-.*$") ->
    generated
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    filter(!(Number %in% generated)) |> 
    distinct(Number) |> 
    arrange(Number) |> 
    str_glue_data(str_c(str_pad("Не сгенерирован qmd-файл для следующего памятника", 100, side = "right"), "{Number}")) ->
    observed
  
  expected <- character(length = length(observed))
  
  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})

