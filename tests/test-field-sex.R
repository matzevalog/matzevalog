library(tidyverse)
library(testthat)

test_that("Заполненено ли поле Sex, если есть заполненность в поле имени.", {
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    filter(is.na(Sex),
           !is.na(Name_RU)) |> 
    distinct(Number) |> 
    arrange(Number) |> 
    str_glue_data(str_c(str_pad("{Number}", 20, side = "right"), 
                        "незаполнено поле 'пол', хотя заполнено имя")) ->
    observed
  
  expected <- character(length = length(observed))
  
  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})

test_that("Содержит ли поле Sex что-то кроме 'женский', 'мужской', 'неизвестный' или NA", {
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    mutate(Sex = str_remove_all(Sex, "(женский)|(мужской)|(неизвестный)|[\\s\\+]")) |> 
    select(Sex, Number) |>
    na.omit() |> 
    filter(Sex != "") |> 
    distinct(Number) |> 
    arrange(Number) |> 
    str_glue_data(str_c(str_pad("{Number}", 20, side = "right"), 
                        "необычное заполнение поля 'пол'")) ->
    observed
  
  expected <- character(length = length(observed))
  
  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})