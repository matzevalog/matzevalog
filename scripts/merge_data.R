suppressPackageStartupMessages(library(tidyverse))
library(readxl)
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

# hebrew2greg("some string")
# hebrew2greg(NA)
# hebrew2greg("29.Ad.5710")
# hebrew2greg("30.Ad.5710")

codes <- c("QBA", "SDB")

map(codes, function(code){
  
  str_glue("data/{code}_тексты.xlsx") |> 
    read_xlsx() |> 
    select(Number, Name_RU, Name_EN, Name_HE, Sex, BDate_GR, BDate_HE, DDate_GR, DDate_HE, Epitaph, Trans_RU, Trans_EN, Tags, Notes_RU, Notes_EN, Lang, Year, Archive, Contacts, Link, Source_Code) |> 
    filter(!is.na(Number)) ->
    texts
  
  str_glue("data/{code}_замеры.xlsx") |> 
    read_xlsx() |> 
    select(Number, Decor_code, Decor_RU, Decor_EN, Tomb_type, Material_code, Material_RU, Material_EN, Dimensions) |> 
    filter(!is.na(Number)) ->
    zamery
  
  str_glue("data/{code}_координаты.xlsx") |> 
    read_xlsx() |> 
    select(Number, Latitude, Longitude) |> 
    filter(!is.na(Number)) ->
    coordinates
  
  texts |> 
    full_join(zamery, by = "Number") |> 
    full_join(coordinates, by = "Number") |> 
    mutate(Year = as.character(Year))
}) |> 
  list_rbind() |> 
  distinct() |> 
  mutate(Code = str_extract(Number, "[A-z]{1,}"),
         Final = str_extract(Number, "[A-z]{1,}$"),
         Final = if_else(is.na(Final), "", Final),
         Number2 = str_remove_all(Number, "[A-z]"),
         Number2 = str_pad(Number2, side = "left", pad = "0", width = 4),
         Number = str_c(Code, Number2, Final)) |> 
  select(-Number2, -Code, -Final) |> 
  filter(!is.na(Number)) |> 
  group_by(Number) |> 
  mutate(Epitaph = str_remove_all(Epitaph, '"'),
         Trans_RU = str_remove_all(Trans_RU, '"'),
         Epitaph = str_replace_all(Epitaph, '\\\\', "/"),
         Trans_RU = str_replace_all(Trans_RU, '\\\\', "/"),
         Name_RU = str_replace_all(Name_RU, '\\\\', "/"),
         Name_HE = str_replace_all(Name_HE, '\\\\', "/"),
         Epitaph = str_remove(Epitaph, "\n{1,}$"),
         Trans_RU = str_remove(Trans_RU, "\n{1,}$"),
         Epitaph = str_remove(Epitaph, "^\n{1,}"),
         Trans_RU = str_remove(Trans_RU, "^\n{1,}"),
         Epitaph_original = Epitaph,
         Epitaph = str_replace_all(Epitaph, "_R_", "справа"),
         Epitaph = str_replace_all(Epitaph, "_L_", "слева"),
         Epitaph = str_replace_all(Epitaph, "_C_", "по центру"),
         Epitaph = str_replace_all(Epitaph, "_FR_", "лицевая сторона"),
         Epitaph = str_replace_all(Epitaph, "_RV_", "обратная сторона"),
         Epitaph = str_replace_all(Epitaph, "_RV_", "обратная сторона"),
         Epitaph = str_replace_all(Epitaph, "_LS_", "левая сторона"),
         Epitaph = str_replace_all(Epitaph, "_RS_", "правая сторона"),
         Epitaph = str_replace_all(Epitaph, "_T_", "сверху"),
         Epitaph = str_replace_all(Epitaph, "_B_", "снизу"),
         Epitaph = str_replace_all(Epitaph, "_UD_", "перевернуто"),
         Epitaph = str_replace_all(Epitaph, "_I_", "внутри"),
         Epitaph = str_replace_all(Epitaph, "_A_", "вокруг"),
         Epitaph = str_replace_all(Epitaph, "_TB_", "табличка"),
         Sex = str_replace_all(Sex, "\\+", " \\+ "),
         Sex = str_squish(Sex),
         Sex = str_replace_all(Sex, "ж", "женский"),
         Sex = str_replace_all(Sex, "м", "мужской"),
         Sex = str_replace_all(Sex, "неизв.", "неизвестный"),
         Sex = str_replace_all(Sex, "f", "женский"),
         Sex = str_replace_all(Sex, "m", "мужской"),
         Sex = str_replace_all(Sex, "n", "неизвестный"),
         Lang = str_replace_all(Lang, ",", ", "),
         Lang = str_squish(Lang),
         Lang = str_replace_all(Lang, "HE", "иврит"),
         Lang = str_replace_all(Lang, "AR", "арамейский"),
         Lang = str_replace_all(Lang, "YD", "идиш"),
         Lang = str_replace_all(Lang, "JU", "джуури"),
         Lang = str_replace_all(Lang, "RU", "русский"),
         Lang = str_replace_all(Lang, "UA", "украинский"),
         Lang = str_replace_all(Lang, "BY", "белорусский"),
         Lang = str_replace_all(Lang, "LV", "латышский"),
         Lang = str_replace_all(Lang, "LT", "литовский"),
         Lang = str_replace_all(Lang, "PL", "польский"),
         Lang = str_replace_all(Lang, "EN", "английский"),
         Lang = str_replace_all(Lang, "DE", "немецкий"),
         Lang = str_replace_all(Lang, "RO", "румынский"),
         Lang = str_replace_all(Lang, "LZ", "лезгинский"),
         Lang = str_replace_all(Lang, "AZ", "азербайджанский"),
         Tomb_type = case_when(Tomb_type == "М" ~ "стела",
                               Tomb_type == "M" ~ "стела",
                               Tomb_type == "L" ~ "L-образный",
                               Tomb_type == "P" ~ "плита/саркофаг",
                               Tomb_type == "Р" ~ "плита/саркофаг",
                               Tomb_type == "O" ~ "шатёр (охель)",
                               Tomb_type == "О" ~ "шатёр (охель)",
                               Tomb_type == "S" ~ "индивидуальный",
                               Tomb_type == "T" ~ "табличка",
                               Tomb_type == "Т" ~ "табличка",
                               Tomb_type == "N" ~ "неизвестен"),
         Material_code = str_replace_all(Material_code, "SS", "песчаник"),
         Material_code = str_replace_all(Material_code, "SR", "ракушечник"),
         Material_code = str_replace_all(Material_code, "SC", "известняк"),
         Material_code = str_replace_all(Material_code, "SG", "гранит"),
         Material_code = str_replace_all(Material_code, "SB", "габбро-диорит"),
         Material_code = str_replace_all(Material_code, "SL", "лабрадорит"),
         Material_code = str_replace_all(Material_code, "SM", "мрамор"),
         Material_code = str_replace_all(Material_code, "SQ", "кварцит"),
         Material_code = str_replace_all(Material_code, "AS", "искусственный камень"),
         Material_code = str_replace_all(Material_code, "CR", "бетон"),
         Material_code = str_replace_all(Material_code, "CM", "мозаичный бетон"),
         Material_code = str_replace_all(Material_code, "BR", "кирпич"),
         Material_code = str_replace_all(Material_code, "CL", "керамика"),
         Material_code = str_replace_all(Material_code, "M", "металл"),
         Material_code = str_replace_all(Material_code, "М", "металл"),
         Material_code = str_replace_all(Material_code, "W", "дерево"),
         Material_code = str_replace_all(Material_code, "О", "другое"),
         Material_code = str_replace_all(Material_code, "O", "другое"),
         Material_code = str_replace_all(Material_code, "S", "природный камень"),
         Material_code = str_replace_all(Material_code, ",", ", "),
         Material_code = str_squish(Material_code),
         Decor_code = str_replace(Decor_code, "O", "архитектурно-орнаментальный"),
         Decor_code = str_replace(Decor_code, "E", "эпиграфический"),
         Decor_code = str_replace(Decor_code, "F", "растительный"),
         Decor_code = str_replace(Decor_code, "Z", "зооморфный"),
         Decor_code = str_replace(Decor_code, "A", "антропоморфный"),
         Decor_code = str_replace(Decor_code, "P", "портретный"),
         Decor_code = str_replace(Decor_code, "I", "предметно-бытовой"),
         Decor_code = str_replace(Decor_code, "S", "традиционная символика"),
         Decor_code = str_replace(Decor_code, "N", "другое"),
         Decor_code = str_replace(Decor_code, "[—–-]", "-"),
         Decor_code = str_replace_all(Decor_code, ",", ", "),
         Decor_code = str_squish(Decor_code),
         Coordinates = str_c(Latitude, ", ", Longitude),
         Dimensions = str_replace_all(Dimensions, "\\+", "×"),
         Dimensions = str_replace_all(Dimensions, "\\[", " --- "),
         Dimensions = str_remove_all(Dimensions, "\\]"),
         DDate_GR = str_replace_all(DDate_GR, "-", "."),
         DDate_GR = str_replace_all(DDate_GR, "\\?", "-"),
         BDate_GR = str_replace_all(BDate_GR, "-", "."),
         BDate_GR = str_replace_all(BDate_GR, "\\?", "-"),
         DDate_HE = str_replace_all(DDate_HE, "-", "."),
         DDate_HE = str_replace_all(DDate_HE, "\\?", "-"),
         BDate_HE = str_replace_all(BDate_HE, "-", "."),
         BDate_HE = str_replace_all(BDate_HE, "\\?", "-"),
         DDate_HE = str_replace_all(DDate_HE, "ni", "Ni"),
         DDate_HE = str_replace_all(DDate_HE, "ни", "Ni"),
         DDate_HE = str_replace_all(DDate_HE, "Ни", "Ni"),
         DDate_HE = str_replace_all(DDate_HE, "iy", "Iy"),
         DDate_HE = str_replace_all(DDate_HE, "ия", "Iy"),
         DDate_HE = str_replace_all(DDate_HE, "Ия", "Iy"),
         DDate_HE = str_replace_all(DDate_HE, "si", "Si"),
         DDate_HE = str_replace_all(DDate_HE, "си", "Si"),
         DDate_HE = str_replace_all(DDate_HE, "си", "Si"),
         DDate_HE = str_replace_all(DDate_HE, "ta", "Ta"),
         DDate_HE = str_replace_all(DDate_HE, "та", "Ta"),
         DDate_HE = str_replace_all(DDate_HE, "Та", "Ta"),
         DDate_HE = str_replace_all(DDate_HE, "av", "Av"),
         DDate_HE = str_replace_all(DDate_HE, "ав", "Av"),
         DDate_HE = str_replace_all(DDate_HE, "Ав", "Av"),
         DDate_HE = str_replace_all(DDate_HE, "el", "El"),
         DDate_HE = str_replace_all(DDate_HE, "эл", "El"),
         DDate_HE = str_replace_all(DDate_HE, "Эл", "El"),
         DDate_HE = str_replace_all(DDate_HE, "ti", "Ti"),
         DDate_HE = str_replace_all(DDate_HE, "ти", "Ti"),
         DDate_HE = str_replace_all(DDate_HE, "Ти", "Ti"),
         DDate_HE = str_replace_all(DDate_HE, "ch", "Ch"),
         DDate_HE = str_replace_all(DDate_HE, "хе", "Ch"),
         DDate_HE = str_replace_all(DDate_HE, "Хе", "Ch"),
         DDate_HE = str_replace_all(DDate_HE, "ki", "Ki"),
         DDate_HE = str_replace_all(DDate_HE, "ки", "Ki"),
         DDate_HE = str_replace_all(DDate_HE, "Ки", "Ki"),
         DDate_HE = str_replace_all(DDate_HE, "te", "Te"),
         DDate_HE = str_replace_all(DDate_HE, "те", "Te"),
         DDate_HE = str_replace_all(DDate_HE, "Те", "Te"),
         DDate_HE = str_replace_all(DDate_HE, "sh", "Sh"),
         DDate_HE = str_replace_all(DDate_HE, "шв", "Sh"),
         DDate_HE = str_replace_all(DDate_HE, "Шв", "Sh"),
         DDate_HE = str_replace_all(DDate_HE, "ad", "Ad"),
         DDate_HE = str_replace_all(DDate_HE, "ад", "Ad"),
         DDate_HE = str_replace_all(DDate_HE, "Ад", "Ad"),
         DDate_HE = str_replace_all(DDate_HE, "ad1", "Ad"),
         DDate_HE = str_replace_all(DDate_HE, "ад1", "Ad"),
         DDate_HE = str_replace_all(DDate_HE, "Ад1", "Ad"),
         DDate_HE = str_replace_all(DDate_HE, "ad2", "Ad2"),
         DDate_HE = str_replace_all(DDate_HE, "ад2", "Ad2"),
         DDate_HE = str_replace_all(DDate_HE, "Ад2", "Ad2"),
         BDate_HE = str_replace_all(BDate_HE, "ni", "Ni"),
         BDate_HE = str_replace_all(BDate_HE, "ни", "Ni"),
         BDate_HE = str_replace_all(BDate_HE, "Ни", "Ni"),
         BDate_HE = str_replace_all(BDate_HE, "iy", "Iy"),
         BDate_HE = str_replace_all(BDate_HE, "ия", "Iy"),
         BDate_HE = str_replace_all(BDate_HE, "Ия", "Iy"),
         BDate_HE = str_replace_all(BDate_HE, "si", "Si"),
         BDate_HE = str_replace_all(BDate_HE, "си", "Si"),
         BDate_HE = str_replace_all(BDate_HE, "си", "Si"),
         BDate_HE = str_replace_all(BDate_HE, "ta", "Ta"),
         BDate_HE = str_replace_all(BDate_HE, "та", "Ta"),
         BDate_HE = str_replace_all(BDate_HE, "Та", "Ta"),
         BDate_HE = str_replace_all(BDate_HE, "av", "Av"),
         BDate_HE = str_replace_all(BDate_HE, "ав", "Av"),
         BDate_HE = str_replace_all(BDate_HE, "Ав", "Av"),
         BDate_HE = str_replace_all(BDate_HE, "el", "El"),
         BDate_HE = str_replace_all(BDate_HE, "эл", "El"),
         BDate_HE = str_replace_all(BDate_HE, "Эл", "El"),
         BDate_HE = str_replace_all(BDate_HE, "ti", "Ti"),
         BDate_HE = str_replace_all(BDate_HE, "ти", "Ti"),
         BDate_HE = str_replace_all(BDate_HE, "Ти", "Ti"),
         BDate_HE = str_replace_all(BDate_HE, "ch", "Ch"),
         BDate_HE = str_replace_all(BDate_HE, "хе", "Ch"),
         BDate_HE = str_replace_all(BDate_HE, "Хе", "Ch"),
         BDate_HE = str_replace_all(BDate_HE, "ki", "Ki"),
         BDate_HE = str_replace_all(BDate_HE, "ки", "Ki"),
         BDate_HE = str_replace_all(BDate_HE, "Ки", "Ki"),
         BDate_HE = str_replace_all(BDate_HE, "te", "Te"),
         BDate_HE = str_replace_all(BDate_HE, "те", "Te"),
         BDate_HE = str_replace_all(BDate_HE, "Те", "Te"),
         BDate_HE = str_replace_all(BDate_HE, "sh", "Sh"),
         BDate_HE = str_replace_all(BDate_HE, "шв", "Sh"),
         BDate_HE = str_replace_all(BDate_HE, "Шв", "Sh"),
         BDate_HE = str_replace_all(BDate_HE, "ad", "Ad"),
         BDate_HE = str_replace_all(BDate_HE, "ад", "Ad"),
         BDate_HE = str_replace_all(BDate_HE, "Ад", "Ad"),
         BDate_HE = str_replace_all(BDate_HE, "ad1", "Ad"),
         BDate_HE = str_replace_all(BDate_HE, "ад1", "Ad"),
         BDate_HE = str_replace_all(BDate_HE, "Ад1", "Ad"),
         BDate_HE = str_replace_all(BDate_HE, "ad2", "Ad2"),
         BDate_HE = str_replace_all(BDate_HE, "ад2", "Ad2"),
         BDate_HE = str_replace_all(BDate_HE, "Ад2", "Ad2"),
         BDate_HE = if_else(BDate_HE == "-.-.-", NA, BDate_HE),
         BDate_GR = if_else(BDate_GR == "-.-.-", NA, BDate_GR),
         DDate_HE = if_else(DDate_HE == "-.-.-", NA, DDate_HE),
         DDate_GR = if_else(DDate_GR == "-.-.-", NA, DDate_GR),
         Tags = str_replace_all(Tags, "аврех", "молодой человек"),
         Tags = str_replace_all(Tags, "пожилой", "пожилой(-ая)"),
         Tags = str_replace_all(Tags, "вдовец", "овдовевший(-ая)"),
         Tags = str_replace_all(Tags, "внук", "внук (внучка)"),
         Tags = str_replace_all(Tags, "правнук", "правнук, потомок"),
         Tags = str_replace_all(Tags, "шамаш", "служитель (шамаш)"), 
         Tags = str_replace_all(Tags, "штадлан", "представитель общины (штадлан)"), 
         Tags = str_replace_all(Tags, "парнас", "глава общины (парнас)"), 
         Tags = str_replace_all(Tags, "староста", "управляющий, староста (габбай)"), 
         Tags = str_replace_all(Tags, "хевра кадиша", "член погребального братства"), 
         Tags = str_replace_all(Tags, "благородный", "благородное происхождение"), 
         Tags = str_replace_all(Tags, "ученик", "ученик, студент"), 
         Tags = str_replace_all(Tags, "торани", "знаток Писания"),
         Tags = str_replace_all(Tags, "ученый", "учёный, знаток Талмуда"),
         Tags = str_replace_all(Tags, "автор", "автор сочинения"),
         Tags = str_replace_all(Tags, "маскил", "просвещенный"),
         Tags = str_replace_all(Tags, "алуф", "выдающийся учёный"),
         Tags = str_replace_all(Tags, "внезапно", "преждевременная смерть"),
         Tags = str_replace_all(Tags, "бедствие", "стихийное бедствие"),
         Tags = str_replace_all(Tags, "убит", "насильственная смерть"),
         Tags = str_replace_all(Tags, "кадош", "мученическая смерть"),
         Tags = str_replace_all(Tags, "война", "военные действия"),
         images = list.files(path = "images/", pattern = str_c(Number, "[_\\.]")) |> str_c(collapse = "; "),
         license = "[CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/deed.ru)",
         place = case_when(str_detect(Number, "QBA") ~ "Куба (центральное)\n\n    Азербайджан",
                           str_detect(Number, "SDB") ~ "Стародуб\n\n    Россия",
                           TRUE ~ NA)) |> 
  ungroup() ->
  res

res |> 
  filter(is.na(DDate_GR) & !is.na(DDate_HE)) |> 
  select(Number, DDate_HE) |> 
  mutate(DDate_HE = str_replace_all(DDate_HE, "Ad1", "Ad")) |> 
  rowwise() |>
  mutate(DDate_GR_suggestion = hebrew2greg(DDate_HE)) |>
  ungroup() |> 
  na.omit() |> 
  mutate(DDate_HE_comment = if_else(nchar(DDate_GR_suggestion) > 10, DDate_GR_suggestion, NA),
         DDate_GR_suggestion = if_else(nchar(DDate_GR_suggestion) > 10, NA, DDate_GR_suggestion)) ->
  DDate_GR_suggestions

res |> 
  filter(is.na(BDate_GR) & !is.na(BDate_HE)) |> 
  select(Number, BDate_HE) |> 
  mutate(BDate_HE = str_replace_all(BDate_HE, "Ad1", "Ad")) |> 
  rowwise() |>
  mutate(BDate_GR_suggestion = hebrew2greg(BDate_HE)) |>
  ungroup() |> 
  na.omit() |> 
  mutate(BDate_HE_comment = if_else(nchar(BDate_GR_suggestion) > 10, BDate_GR_suggestion, NA),
         BDate_GR_suggestion = if_else(nchar(BDate_GR_suggestion) > 10, NA, BDate_GR_suggestion)) ->
  BDate_GR_suggestions

res |> 
  left_join(DDate_GR_suggestions, by = c("Number", "DDate_HE")) |> 
  left_join(BDate_GR_suggestions, by = c("Number", "BDate_HE")) |> 
  mutate(DDate_GR = if_else(is.na(DDate_GR_suggestion), DDate_GR, str_c(DDate_GR_suggestion, "*")),
         BDate_GR = if_else(is.na(BDate_GR_suggestion), BDate_GR, str_c(BDate_GR_suggestion, "*"))) |> 
  write_csv("data/data.csv", na = "")

read_csv("data/data.csv", show_col_types = FALSE, progress = FALSE) |> 
  writexl::write_xlsx("data/data.xlsx")
