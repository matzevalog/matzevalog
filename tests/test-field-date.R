library(tidyverse)
library(testthat)


test_that("Проверка заполнения григорианской даты смерти", {
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    mutate(DDate_GR = str_remove_all(DDate_GR, "[\\d\\*\\s\\+\\./-]")) |> 
    select(DDate_GR, Number) |>
    na.omit() |> 
    filter(DDate_GR != "") |> 
    distinct(Number) |> 
    arrange(Number) |> 
    str_glue_data(str_c(str_pad("{Number}", 20, side = "right"),
                        "необычное заполнение григорианской даты смерти")) ->
    observed
  
  expected <- character(length = length(observed))
  
  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})


test_that("Проверка заполнения григорианской даты смерти", {
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    mutate(ru_plus_n = str_count(Name_RU, "\\+"),
           en_plus_n = str_count(Name_EN, "\\+"),
           he_plus_n = str_count(Name_HE, "\\+")) |> 
    filter(ru_plus_n == en_plus_n, 
           en_plus_n == he_plus_n) |> 
    mutate(across(.cols = c("Name_RU", "Name_EN", "Name_HE", "Sex", "BDate_GR",
                            "BDate_HE", "DDate_GR", "DDate_HE"),
                  function(i) str_split(i, "\\+"))) |>
    unnest_longer(c(Name_RU, Name_EN, Name_HE, Sex, BDate_GR, BDate_HE, DDate_GR, DDate_HE)) |>
    mutate(across(.cols = c("Name_RU", "Name_EN", "Name_HE", "Sex", "BDate_GR",
                            "BDate_HE", "DDate_GR", "DDate_HE"),
                  function(i) str_squish(i))) |> 
    filter(str_count(DDate_GR, "\\.") != 2) |> 
    select(DDate_GR, Number) |>
    na.omit() |> 
    filter(DDate_GR != "") |> 
    distinct(Number) |> 
    arrange(Number) |>  
    str_glue_data(str_c(str_pad("{Number}", 20, side = "right"),
                        "Неверное заполнение григорианской даты смерти в памятнике с номером")) ->
    observed
  
  expected <- character(length = length(observed))
  
  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})

test_that("Проверка заполнения григорианской даты рождения", {
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    mutate(BDate_GR = str_remove_all(DDate_GR, "[\\d\\s\\*\\+\\./-]")) |> 
    select(BDate_GR, Number) |>
    na.omit() |> 
    filter(BDate_GR != "") |> 
    distinct(Number) |> 
    arrange(Number) |> 
    str_glue_data(str_c(str_pad("{Number}", 20, side = "right"),
                        "необычное заполнение григорианской даты рождения")) ->
    observed
  
  expected <- character(length = length(observed))
  
  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})

test_that("Проверка заполнения григорианской даты рождения", {
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    mutate(ru_plus_n = str_count(Name_RU, "\\+"),
           en_plus_n = str_count(Name_EN, "\\+"),
           he_plus_n = str_count(Name_HE, "\\+")) |> 
    filter(ru_plus_n == en_plus_n, 
           en_plus_n == he_plus_n) |> 
    mutate(across(.cols = c("Name_RU", "Name_EN", "Name_HE", "Sex", "BDate_GR",
                            "BDate_HE", "DDate_GR", "DDate_HE"),
                  function(i) str_split(i, "\\+"))) |>
    unnest_longer(c(Name_RU, Name_EN, Name_HE, Sex, BDate_GR, BDate_HE, DDate_GR, DDate_HE)) |>
    mutate(across(.cols = c("Name_RU", "Name_EN", "Name_HE", "Sex", "BDate_GR",
                            "BDate_HE", "DDate_GR", "DDate_HE"),
                  function(i) str_squish(i))) |> 
    filter(str_count(BDate_GR, "\\.") != 2) |> 
    select(BDate_GR, Number) |> 
    na.omit() |> 
    filter(BDate_GR != "") |> 
    distinct(Number) |> 
    arrange(Number) |> 
    str_glue_data(str_c(str_pad("{Number}", 20, side = "right"),
                        "необычное заполнение григорианской даты рождения")) ->
    observed
  
  expected <- character(length = length(observed))
  
  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})

test_that("Проверка заполнения еврейской даты рождения", {
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    mutate(ru_plus_n = str_count(Name_RU, "\\+"),
           en_plus_n = str_count(Name_EN, "\\+"),
           he_plus_n = str_count(Name_HE, "\\+")) |> 
    filter(ru_plus_n == en_plus_n, 
           en_plus_n == he_plus_n) |> 
    mutate(across(.cols = c("Name_RU", "Name_EN", "Name_HE", "Sex", "BDate_GR",
                            "BDate_HE", "DDate_GR", "DDate_HE"),
                  function(i) str_split(i, "\\+"))) |>
    unnest_longer(c(Name_RU, Name_EN, Name_HE, Sex, BDate_GR, BDate_HE, DDate_GR, DDate_HE)) |>
    mutate(across(.cols = c("Name_RU", "Name_EN", "Name_HE", "Sex", "BDate_GR",
                            "BDate_HE", "DDate_GR", "DDate_HE"),
                  function(i) str_squish(i))) |> 
    filter(str_count(BDate_HE, "\\.") != 2) |> 
    select(BDate_HE, Number) |> 
    na.omit() |> 
    filter(BDate_HE != "") |> 
    distinct(Number) |> 
    arrange(Number) |> 
    str_glue_data(str_c(str_pad("{Number}", 20, side = "right"), 
                        "необычное заполнение еврейской даты рождения")) ->
    observed
  
  expected <- character(length = length(observed))
  
  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})

test_that("Проверка заполнения еврейской даты смерти", {
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    mutate(ru_plus_n = str_count(Name_RU, "\\+"),
           en_plus_n = str_count(Name_EN, "\\+"),
           he_plus_n = str_count(Name_HE, "\\+")) |> 
    filter(ru_plus_n == en_plus_n, 
           en_plus_n == he_plus_n) |> 
    mutate(across(.cols = c("Name_RU", "Name_EN", "Name_HE", "Sex", "BDate_GR",
                            "BDate_HE", "DDate_GR", "DDate_HE"),
                  function(i) str_split(i, "\\+"))) |>
    unnest_longer(c(Name_RU, Name_EN, Name_HE, Sex, BDate_GR, BDate_HE, DDate_GR, DDate_HE)) |>
    mutate(across(.cols = c("Name_RU", "Name_EN", "Name_HE", "Sex", "BDate_GR",
                            "BDate_HE", "DDate_GR", "DDate_HE"),
                  function(i) str_squish(i))) |> 
    filter(str_count(DDate_HE, "\\.") != 2) |> 
    select(DDate_HE, Number) |> 
    na.omit() |> 
    filter(DDate_HE != "") |>
    distinct(Number) |> 
    arrange(Number) |> 
    str_glue_data(str_c(str_pad("{Number}", 20, side = "right"), 
                        "необычное заполнение еврейской даты смерти")) ->
    observed
  
  expected <- character(length = length(observed))
  
  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})