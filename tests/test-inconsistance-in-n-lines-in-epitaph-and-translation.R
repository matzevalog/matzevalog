library(tidyverse)
library(testthat)

test_that("Проверка разного количества строчек в эпитафии и его русском переводе.", {
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    mutate(Epitaph_original = str_replace_all(Epitaph_original, "_((R)|(L)|(C)|(FR)|(RV)|(LS)|(RS)|(T)|(B)|(UD)|(I)|(A)|(TB))_", ""),
           Epitaph_original = str_remove(Epitaph_original, "^\n")) |> 
    filter(str_count(Epitaph_original, "\n") != str_count(Trans_RU, "\n")) |> 
    filter(Trans_RU != "См. оригинал") |> 
    count(Number) |> 
    arrange(Number) |> 
    str_glue_data(str_c(str_pad("Разное количество строчек в эпитафии и русском переводе в памятнике с кодом", 100, side = "right"), "{Number}")) ->
    observed
  
  expected <- character(length = length(observed))

  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})
