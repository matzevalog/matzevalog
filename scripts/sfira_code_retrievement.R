library(tidyverse)
library(rvest)

walk(1:212, function(i){
  str_glue("https://sfira.org/tombstone/find?page={i}") |> 
    read_html() ->
    s
  
  s |> 
    html_nodes("td.table__td.table__td--starter") |> 
    html_text() |> 
    str_squish() ->
    name
  
  s |> 
    html_nodes("td.table__td.table__td--more > a") |> 
    html_attr("href") ->
    links
  
  tibble(name, links) |> 
    write_csv("data/sfira_code_retrievement.csv", append = TRUE)
})

read_csv("data/sfira_code_retrievement.csv", col_names = FALSE) |> 
  rename(tombstone_code = X1,
         tombstone_link = X2) |> 
  mutate(tombstone_link = str_replace(tombstone_link, "/tombstone/quick-view", "https://sfira.org/tombstone/view")) |> 
  write_csv("data/sfira_code_retrievement.csv")

