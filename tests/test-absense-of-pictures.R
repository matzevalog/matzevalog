library(tidyverse)
library(testthat)

test_that("Проверка наличия фотографий.", {
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    filter(is.na(images)) |> 
    distinct(Number) |> 
    arrange(Number) |> 
    str_glue_data(str_c(str_pad("{Number}", 20, side = "right"), "отсутствуют фотографии в папке")) ->
    observed
  
  expected <- character(length = length(observed))

  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})
