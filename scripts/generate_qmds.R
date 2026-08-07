suppressPackageStartupMessages(library(tidyverse))
library(reticulate)
py_require("pyluach")
pyluach <- import("pyluach")

hebrew2greg <- function(hebrew_date) {
  
  is_hebrew_date <- str_detect(hebrew_date, "^\\d{1,2}\\.((Ni)|(Iy)|(Si)|(Ta)|(Av)|(El)|(Ti)|(Ch)|(Ki)|(Te)|(Sh)|(Ad)|(Ad2))\\.\\d{4}$")
  is_hebrew_date <- ifelse(is.na(is_hebrew_date), FALSE, is_hebrew_date)
  is_hebrew_date <- ifelse(length(is_hebrew_date) > 0, is_hebrew_date, FALSE)
  
  if(is_hebrew_date){
    
    hebrew_date |> 
      str_split("\\.") |> 
      unlist() ->
      split_hebrew_date
    
    case_when(split_hebrew_date[2] == "Ni" ~ 1,
              split_hebrew_date[2] == "Iy" ~ 2,
              split_hebrew_date[2] == "Si" ~ 3,
              split_hebrew_date[2] == "Ta" ~ 4,
              split_hebrew_date[2] == "Av" ~ 5,
              split_hebrew_date[2] == "El" ~ 6,
              split_hebrew_date[2] == "Ti" ~ 7,
              split_hebrew_date[2] == "Ch" ~ 8,
              split_hebrew_date[2] == "Ki" ~ 9,
              split_hebrew_date[2] == "Te" ~ 10,
              split_hebrew_date[2] == "Sh" ~ 11,
              split_hebrew_date[2] == "Ad" ~ 12,
              split_hebrew_date[2] == "Ad2" ~ 13) ->
      split_hebrew_date[2]
    
    split_hebrew_date <- as.double(split_hebrew_date)  
    
    tryCatch(
      pyluach$dates$HebrewDate(split_hebrew_date[3], 
                               split_hebrew_date[2], 
                               split_hebrew_date[1])$to_greg(),
      error = function(e){e}) |> 
      as.character() ->
      result
    
    result <- ifelse(str_length(result) > 10,
                     result,
                     result |>
                       as.character() |>
                       as.Date() |>
                       format("%d.%m.%Y"))
    
    result
    
  } else {
    
    NA
    
  }
}

read_csv("data/data.csv", show_col_types = FALSE) |> 
  filter(str_count(Epitaph, "\n") == str_count(Trans_RU, "\n")) |>
  mutate(images = if_else(is.na(images), "No_photo.png", images),
         image = str_replace_all(images, "; ", '")\nknitr::include_graphics("../images/'),
         image = str_c('knitr::include_graphics("../images/', image, '")'),
         across(c(Name_RU, Name_EN, Name_HE), function(x) ifelse(is.na(x), "", x))) |> 
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
  mutate(DDate_HE_for_luach = DDate_HE) |> 
  group_by(Number) |> 
  mutate(person_id = 1:n() |> as.roman()) |> 
  ungroup() |> 
  mutate(ru_last_name = str_extract(Name_RU, "^.*(?=//)") |> str_to_upper(),
         he_last_name = str_extract(Name_HE, "^.*(?=//)"),
         ru_last_name = str_squish(ru_last_name),
         he_last_name = str_squish(he_last_name),
         Name_RU = str_replace(Name_RU, "Неизвестный\\(-ая\\)", "НЕИЗВЕСТНЫЙ"),
         Name_RU = str_remove(Name_RU, "^.*//"),
         Name_HE = str_remove(Name_HE, "^.*//"),
         patronim_ru = str_extract(Name_RU, "(?<=/).*$"),
         patronim_he = str_extract(Name_HE, "(?<=/).*$"),
         Name_RU = str_remove(Name_RU, "/.*$"),
         Name_HE = str_remove(Name_HE, "/.*$"),
         alt_name = str_extract(Name_RU, "\\(.*?\\)"),
         alt_name = str_remove_all(alt_name, "[\\(\\)]"),
         Name_RU = str_remove(Name_RU, "\\(.*?\\)"),
         Name_RU = str_squish(Name_RU),
         patronim_ru_alt = str_extract(patronim_ru, "\\[.*?\\]"),
         patronim_ru_alt = str_remove_all(patronim_ru_alt, "[\\[\\]]"),
         patronim_ru = str_remove(patronim_ru, "\\[.*?\\]"),
         patronim_ru = str_remove(patronim_ru, "\\(.*?\\)"),
         patronim_ru = str_squish(patronim_ru),
         patronim_he = str_squish(patronim_he),
         patronim_he_first_part = str_extract(patronim_he, "^[\\u0590-\\u05FF-]*"),
         patronim_he = str_remove(patronim_he, "^[\\u0590-\\u05FF-]*")) |> 
  separate(patronim_ru, sep = " ", into = c("patronim_ru_1", "patronim_ru_2", "patronim_ru_3", "patronim_ru_4")) |> 
  mutate(patronim_ru_1 = case_when(patronim_ru_1 == "Лев" ~ "Льва",
                                   patronim_ru_1 == "Неизвестный" ~ "Неизвестного",
                                   str_detect(patronim_ru_1, "[бвгджзклмнпрстфхцчшщ]$") ~ str_c(patronim_ru_1, "а"),
                                   str_detect(patronim_ru_1, "[ьй]$") ~ str_replace(patronim_ru_1, "[ьй]$", "я"),
                                   str_detect(patronim_ru_1, "[жшгкх]а$") ~ str_replace(patronim_ru_1, "(?<=[жшгкх])а$", "и"),
                                   str_detect(patronim_ru_1, "[^жшгёуеэоаыяию]а$") ~ str_replace(patronim_ru_1, "(?<=[^жшгёуеэоаыяию])а$", "ы"),
                                   str_detect(patronim_ru_1, "я$") ~ str_replace(patronim_ru_1, "я$", "и"),
                                   TRUE ~ patronim_ru_1),
         patronim_ru_2 = case_when(patronim_ru_2 == "Лев" ~ "Льва",
                                   patronim_ru_2 == "Неизвестный" ~ "Неизвестного",
                                   str_detect(patronim_ru_2, "[бвгджзклмнпрстфхцчшщ]$") ~ str_c(patronim_ru_2, "а"),
                                   str_detect(patronim_ru_2, "[ьй]$") ~ str_replace(patronim_ru_2, "[ьй]$", "я"),
                                   str_detect(patronim_ru_2, "[жшгкх]а$") ~ str_replace(patronim_ru_2, "(?<=[жшгкх])а$", "и"),
                                   str_detect(patronim_ru_2, "[^жшгёуеэоаыяию]а$") ~ str_replace(patronim_ru_2, "(?<=[^жшгёуеэоаыяию])а$", "ы"),
                                   str_detect(patronim_ru_2, "я$") ~ str_replace(patronim_ru_2, "я$", "и"),
                                   TRUE ~ patronim_ru_2),
         patronim_ru_3 = case_when(patronim_ru_3 == "Лев" ~ "Льва",
                                   patronim_ru_3 == "Неизвестный" ~ "Неизвестного",
                                   str_detect(patronim_ru_3, "[бвгджзклмнпрстфхцчшщ]$") ~ str_c(patronim_ru_3, "а"),
                                   str_detect(patronim_ru_3, "[ьй]$") ~ str_replace(patronim_ru_3, "[ьй]$", "я"),
                                   str_detect(patronim_ru_3, "[жшгкх]а$") ~ str_replace(patronim_ru_3, "(?<=[жшгкх])а$", "и"),
                                   str_detect(patronim_ru_3, "[^жшгёуеэоаыяию]а$") ~ str_replace(patronim_ru_3, "(?<=[^жшгёуеэоаыяию])а$", "ы"),
                                   str_detect(patronim_ru_3, "я$") ~ str_replace(patronim_ru_3, "я$", "и"),
                                   TRUE ~ patronim_ru_3),
         patronim_ru_4 = case_when(patronim_ru_4 == "Лев" ~ "Льва",
                                   patronim_ru_4 == "Неизвестный" ~ "Неизвестного",
                                   str_detect(patronim_ru_4, "[бвгджзклмнпрстфхцчшщ]$") ~ str_c(patronim_ru_4, "а"),
                                   str_detect(patronim_ru_4, "[ьй]$") ~ str_replace(patronim_ru_4, "[ьй]$", "я"),
                                   str_detect(patronim_ru_4, "[жшгкх]а$") ~ str_replace(patronim_ru_4, "(?<=[жшгкх])а$", "и"),
                                   str_detect(patronim_ru_4, "[^жшгёуеэоаыяию]а$") ~ str_replace(patronim_ru_4, "(?<=[^жшгёуеэоаыяию])а$", "ы"),
                                   str_detect(patronim_ru_4, "я$") ~ str_replace(patronim_ru_4, "я$", "и"),
                                   TRUE ~ patronim_ru_4),
         patronim_ru_1 = str_squish(patronim_ru_1),
         patronim_ru_2 = str_squish(patronim_ru_2),
         patronim_ru_3 = str_squish(patronim_ru_3),
         patronim_ru_4 = str_squish(patronim_ru_4),
         patronim_he_first_part = str_squish(patronim_he_first_part),
         patronim_he = str_squish(patronim_he),
         ru_last_name = str_squish(ru_last_name),
         child_type_ru = case_when(Sex == "женский" & patronim_ru_1 != "" ~ ", дочь",
                                   Sex == "мужской" & patronim_ru_1 != "" ~ ", сын",
                                   Sex == "неизвестный" & patronim_ru_1 != "" ~ ", сын/дочь"),
         child_type_he = case_when(Sex == "женский" & patronim_he_first_part != "" ~ "בת",
                                   Sex == "мужской" & patronim_he_first_part != "" ~ "בן",
                                   Sex == "неизвестный" & patronim_he_first_part != "" ~ "בן/בת"),
         across(c(ru_last_name, Name_RU, child_type_ru, patronim_ru_1, patronim_ru_2, patronim_ru_3, patronim_ru_4, alt_name, patronim_ru_alt,
                  he_last_name, Name_HE, child_type_he, patronim_he_first_part, patronim_he), function(x) ifelse(is.na(x), "", x)),
         alt_name_full = str_c(alt_name, " ", patronim_ru_alt),
         alt_name_full = str_squish(alt_name_full),
         alt_name_full = if_else(alt_name_full != "", str_c("(", alt_name_full, ")"), ""),
         alt_name_full = if_else(patronim_ru_1 == "", str_remove_all(alt_name_full, "[\\)\\(]"), alt_name_full),
         Name_RU = str_c(ru_last_name, " ", Name_RU, child_type_ru, " ", patronim_ru_1, " ", patronim_ru_2, " ", patronim_ru_3, " ", patronim_ru_4, alt_name_full),
         Name_HE = str_c(he_last_name, " ", Name_HE, " ", child_type_he, " ", patronim_he_first_part, " ", patronim_he),
         Name_RU = str_squish(Name_RU),
         Name_RU = str_remove(Name_RU, ",$"),
         Name_HE = str_squish(Name_HE),
         Name_HE = str_remove(Name_HE, ",$"),
         Name_RU = str_replace(Name_RU, "НЕИЗВЕСТНЫЙ", "Неизвестный\\(-ая\\)"),
         BDate_HE = if_else(BDate_HE == "-.-.-", NA, BDate_HE),
         BDate_GR = if_else(BDate_GR == "-.-.-", NA, BDate_GR),
         DDate_HE = if_else(DDate_HE == "-.-.-", NA, DDate_HE),
         DDate_GR = if_else(DDate_GR == "-.-.-", NA, DDate_GR)) ->
  for_qmd_generation

for_qmd_generation |>
  filter(is.na(DDate_GR) & !is.na(DDate_HE)) |>
  select(Number, DDate_HE) |>
  mutate(DDate_HE = str_replace_all(DDate_HE, "Ad1", "Ad")) |> 
  rowwise() |>
  mutate(DDate_GR_suggestion = hebrew2greg(DDate_HE)) |>
  ungroup() |>
  na.omit() |>
  mutate(DDate_HE_comment = if_else(nchar(DDate_GR_suggestion) > 10, DDate_GR_suggestion, NA),
         DDate_GR_suggestion = if_else(nchar(DDate_GR_suggestion) > 10, NA, DDate_GR_suggestion),
         across(everything(), as.character)) ->
  DDate_GR_suggestions

for_qmd_generation |>
  filter(is.na(BDate_GR) & !is.na(BDate_HE)) |>
  select(Number, BDate_HE) |> 
  mutate(BDate_HE = str_replace_all(BDate_HE, "Ad1", "Ad")) |> 
  rowwise() |>
  mutate(BDate_GR_suggestion = hebrew2greg(BDate_HE)) |>
  ungroup() |>
  na.omit() |>
  mutate(BDate_HE_comment = if_else(nchar(BDate_GR_suggestion) > 10, BDate_GR_suggestion, NA),
         BDate_GR_suggestion = if_else(nchar(BDate_GR_suggestion) > 10, NA, BDate_GR_suggestion),
         across(everything(), as.character)) ->
  BDate_GR_suggestions

for_qmd_generation |>
  left_join(DDate_GR_suggestions, by = c("Number", "DDate_HE", "DDate_GR_suggestion", "DDate_HE_comment")) |>
  left_join(BDate_GR_suggestions, by = c("Number", "BDate_HE", "BDate_GR_suggestion", "BDate_HE_comment")) |>
  mutate(DDate_GR = if_else(is.na(DDate_GR), str_c(DDate_GR_suggestion, "*"), DDate_GR),
         BDate_GR = if_else(is.na(BDate_GR), str_c(BDate_GR_suggestion, "*"), BDate_GR),
         geography = str_extract(Tags, "\\%.*?\\%"),
         geography = str_remove_all(geography, "\\%"),
         Source_Code = as.character(Source_Code)) |>
  mutate(across(where(is.character), function(x) ifelse(is.na(x), " ", x))) |>
  rowwise() |>
  mutate(year = str_extract(DDate_GR, "(?<=[\\./])[\\d-]{1,4}(\\*)?$"),
         year = str_remove(year, "\\*"),
         year = str_replace_all(year, " ", "0"),
         year = case_when(year == "20" ~ "2000",
                          year == "200" ~ "2000",
                          year == "190" ~ "1900",
                          year == "180" ~ "1800",
                          year == "170" ~ "1700",
                          is.na(year) ~ "0",
                          TRUE~year),
         year_he = str_extract(DDate_HE, "(?<=[\\./])[\\d-]{1,4}$"),
         year_he = str_replace(year_he, "-", "0"),
         year = str_replace(year, "-", "0") |> as.double(),
         year_he = if_else(is.na(year_he), "0", year_he),
         Material_code_new = str_split(Material_code, ", ") |> unlist() |> str_c("  - m:", ... = _, collapse = "\n") |> str_remove_all("- m: "),
         Lang_new = str_split(Lang, ", ") |> unlist() |> str_c("  - la:", ... = _, collapse = "\n") |> str_remove_all("- la: "),
         Decor_code_new = str_split(Decor_code, ", ") |> unlist() |> str_c("  - d:", ... = _, collapse = "\n") |> str_remove_all("- d: ")) |>
  ungroup() |>
  mutate(place_tag = case_when(str_detect(Number, "QBA") ~ "QBA",
                               str_detect(Number, "SDB") ~ "SDB",
                               TRUE ~ NA)) ->
  for_qmd_generation_second_step

for_qmd_generation_second_step |>
  filter(str_detect(Number, "QBA")) |> 
  mutate(name_dates = str_glue(
'
::: {{.name-style}}
{Name_RU}
:::

::: {{style="font-size: 1.2em;"}}
{Name_HE}
:::

:::: {{.columns}}
::: {{.column width="5%"}}
![](../additional_images/Cradle.svg){{width=1.3em}}
:::

::: {{.column style="width: 40%; padding-left: 0.2em;"}}
{BDate_GR} / {BDate_HE}
:::

::: {{.column width="5%"}}
![](../additional_images/Tombstone.svg){{width=1.3em}}
:::

::: {{.column style="width: 50%; padding-left: 0.2em;"}}
{DDate_GR} / {DDate_HE}
:::

::::

')) |>
  group_by(Number) |>
  mutate(name_dates = str_c(name_dates, collapse = "\n---\n\n"),
         Place2 = str_remove(place, "\n\n.*$") |> str_squish(),
         Material_code_new = str_split(Material_code, ", ") |> unlist() |> str_c("  - m:", ... = _, collapse = "\n") |> str_remove_all("- m: "),
         Tag_code_new = str_split(Tags, ", ") |> unlist() |> str_c("  - t:", ... = _, collapse = "\n") |> str_remove_all("- t: "),
         place_tag_new = place_tag |> str_c("  - c:", ... = _, collapse = "\n") |> str_remove_all("  - c: "),
         gender_new = Sex |> str_c("  - g:", ... = _, collapse = "\n") |> str_remove_all("  - g: "),
         Tomb_type_new = Tomb_type |> str_c("  - tt:", ... = _, collapse = "\n") |> str_remove_all("  - tt: "),
         geography_new = geography |> str_c("  - ge:", ... = _, collapse = "\n") |> str_remove_all("  - ge: "),
         Lang_new = str_split(Lang, ", ") |> unlist() |> str_c("  - l:", ... = _, collapse = "\n") |> str_remove_all("- l: "),
         Decor_code_new = str_split(Decor_code, ", ") |> unlist() |> str_c("  - d:", ... = _, collapse = "\n") |> str_remove_all("- d: ")) |>
  str_glue_data(
'
---
title: "{Number}"
sidebar: tomb-list
sex: {Sex}
place: |
    {place}
name-ru: |
    {Name_RU}
    
    {Name_HE}
name-he: |
    {Name_HE}
    
    {Name_RU}
year-gr: {year}
year-he: {year_he}
categories:
{place_tag_new}
{gender_new}
{Tomb_type_new}
{geography_new}
{Lang_new}
{Decor_code_new}
{Material_code_new}
{Tag_code_new}
lightbox: true
format:
  html:
    df-print: kable
include-in-header:
  - text: |
      <style>
         .quarto-title {{ display: none; }}
         .tab-content {{
            padding-top: 0.2em;
            padding-bottom: 0.2em;
         }}
         .panel-tabset {{ margin-top: 1em; }}
         table tbody tr:nth-of-type(odd) {{
            background-color: rgba(0, 0, 0, 0.04) !important;
         }}
         table, table tr, table th, table td {{
            border: none !important;
            border-bottom: none !important;
            border-top: none !important;
         }}
          .name-style p {{ font-weight: bold; margin-bottom: 0.1em; }}
          .sidebar.sidebar-navigation>* {{ padding-top: 1.1em; }}
          #title-block-header {{ margin-block-end: 0em; }}
      </style>
---

::: {{style="font-size: 1em; margin-bottom: 1.2em"}}
[{Place2}](../cemeteries/{place_tag}.html) > {Number}
:::

```{{r}}
suppressPackageStartupMessages(library(tidyverse))
```


:::: {{.columns}}

::: {{.column width="20%"}}

```{{r}}
#| lightbox:
#|   group: photos

{image}

```
:::

::: {{.column width="5%"}}
:::

::: {{.column width="74%"}}

{name_dates}

::: {{.panel-tabset}}

#### Эпитафия

```{{r}}
tibble(`Оригинал` = "{Epitaph}",
       `Перевод` = "{Trans_RU}") |>
  mutate(`Оригинал` = str_split(`Оригинал`, "\n"),
         `Перевод` = str_split(`Перевод`, "\n")) |>
  unnest_longer(c(`Оригинал`, `Перевод`)) |> 
  mutate(id = 1:n()) |> 
  relocate(id, .before = Перевод) |> 
  rename(` ` = id) |> 
  knitr::kable(align = c("r", "c", "l"))
```

|||
|-|---|
|**Примечания**|{Notes_RU}|
|**Язык**      |{Lang}    |
|**Метки**     |{Tags}    |
: {{tbl-colwidths="[25,75]"}}

#### Памятник

|||
|-|---|
|**Тип памятника**   |{Tomb_type}                                                                         |
|**Материал**        |{Material_code} ({Material_RU})                                                     |
|**Размеры**         |{Dimensions}                                                                        |
|**Тип декора**      |{Decor_code}                                                                        |
|**Элементы декора** |{Decor_RU}                                                                          |
|**Координаты**      |[{Coordinates}](https://www.google.com/maps/place/{Coordinates})                    |
: {{tbl-colwidths="[25,75]"}}

#### Источник

|||
|-|---|
|**Место хранения**        |{Archive}     |
|**Контакты**              |{Contacts}    |
|**Ссылка**                |{Link}        |
|**Исходный ID**           |{Source_Code} |
|**Условия использования** |{license}     |
: {{tbl-colwidths="[25,75]"}}

:::

:::

::::

') ->
  result

options(readr.show_progress = FALSE)

walk(seq_along(result),
     function(i){

  result[i] |>
    write_lines(str_c("tombstones/", for_qmd_generation$Number[i], "-", for_qmd_generation$person_id[i], ".qmd"))

})

