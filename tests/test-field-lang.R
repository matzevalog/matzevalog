library(tidyverse)
library(testthat)

test_that("Заполненено ли поле Lang, если есть заполненность в поле имени.", {
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    filter(is.na(Lang),
           !is.na(Name_RU),
           Name_RU != "Неизвестный(-ая)") |> 
    distinct(Number) |> 
    arrange(Number) |> 
    str_glue_data(str_c(str_pad("Незаполнено поле 'Lang', хотя заполнено имя на памятнике с номером", 100, side = "right"), "{Number}")) ->
    observed
  
  expected <- character(length = length(observed))
  
  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})

test_that("Содержит ли поле Lang что-то кроме 'иврит', 'арамейский' 'идиш', 'джуури', 'русский', 'украинский', 'белорусский', 'латышский', 'литовский', 'польский', 'английский', 'немецкий', 'румынский', 'лезгинский', 'азербайджанский', или NA", {
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    mutate(Lang = str_remove_all(Lang, "(иврит)|(арамейский)|(идиш)|(джуури)|(русский)|(украинский)|(белорусский)|(латышский)|(литовский)|(польский)|(английский)|(немецкий)|(румынский)|(лезгинский)|(азербайджанский)|[\\s,]")) |> 
    select(Lang, Number) |>
    na.omit() |> 
    filter(Lang != "") |> 
    distinct(Number) |> 
    arrange(Number) |> 
    str_glue_data(str_c(str_pad("Необычное заполнение поля 'Lang' в памятнике с номером", 100, side = "right"), "{Number}")) ->
    observed
  
  expected <- character(length = length(observed))
  
  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})
