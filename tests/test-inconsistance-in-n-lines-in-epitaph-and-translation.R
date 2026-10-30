library(tidyverse)
library(testthat)

test_that("Проверка разного количества строчек в эпитафии и его русском переводе.", {
  
  read_csv("../data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
    filter(str_count(Epitaph_original, "\n") != str_count(Trans_RU, "\n")) |> 
    filter(str_detect(Trans_RU, "См. оригинал", negate = TRUE)) |> 
    count(Number) |> 
    arrange(Number) |> 
    str_glue_data(str_c(str_pad("{Number}", 20, side = "right"), 
                        "разное количество строчек в эпитафии и русском переводе")) ->
    observed
  
  expected <- character(length = length(observed))

  write_lines(observed, "../test_logs.txt", append = TRUE)
  expect_equal(observed, expected)
})
