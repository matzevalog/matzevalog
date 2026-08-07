library(tidyverse)
library(testthat)

test_that("Проверка дубликатов памятников", {
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    select(Number) |> 
    count(Number) |> 
    arrange(Number) |> 
    filter(n > 1) |> 
    str_glue_data(str_c(str_pad("В данных несколько памятников ({n}) с одним и тем же кодом", 102, side = "right"), "{Number}")) ->
    observed
  
  expected <- character(length = length(observed))

  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})
