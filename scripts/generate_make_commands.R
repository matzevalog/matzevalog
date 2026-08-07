library(tidyverse)

1:116 |> 
  as.character() |> 
  str_pad(width = 3, pad = "0", side = "left") |> 
  str_c("\tquarto render tombstones/QBA", ... = _, "* --no-clean --quiet") |> 
  cat(sep = "\n")