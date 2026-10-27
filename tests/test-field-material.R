library(tidyverse)
library(testthat)

test_that("Заполненено ли поле Material_code, если есть заполненность в поле размеров.", {
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    filter(is.na(Material_code),
           !is.na(Dimensions)) |> 
    distinct(Number) |> 
    arrange(Number) |> 
    str_glue_data(str_c(str_pad("{Number}", 20, side = "right"), 
                        "незаполнено поле 'материал', хотя заполнены размеры")) ->
    observed
  
  expected <- character(length = length(observed))
  
  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})

test_that("Содержит ли поле Material_code что-то неподходящее", {
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    mutate(Material_code = str_remove_all(Material_code, "(природный камень)|(ракушечник)|(песчаник)|(известняк)|(гранит)|(габбро-диорит)|(лабрадорит)|(мрамор)|(кварцит)|(искусственный камень)|(бетон)|(мозаичный бетон)|(кирпич)|(керамика)|(металл)|(дерево)|(другое)|[\\s,]")) |> 
    select(Material_code, Number) |>
    na.omit() |> 
    filter(Material_code != "") |> 
    distinct(Number) |> 
    arrange(Number) |> 
    str_glue_data(str_c(str_pad("{Number}", 20, side = "right"), 
                        "необычное заполнение поля Material_code")) ->
    observed
  
  expected <- character(length = length(observed))
  
  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})