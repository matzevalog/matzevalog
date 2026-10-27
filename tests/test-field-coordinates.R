library(tidyverse)
library(testthat)

test_that("Заполненено ли поле координаты, если есть заполненность в поле имени.", {
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    filter(is.na(Coordinates),
           !is.na(Name_RU)) |> 
    distinct(Number) |> 
    arrange(Number) |> 
    str_glue_data(str_c(str_pad("{Number}", 20, side = "right"), 
                        "незаполнены координаты, хотя заполнено имя")) ->
    observed
  
  expected <- character(length = length(observed))
  
  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})
