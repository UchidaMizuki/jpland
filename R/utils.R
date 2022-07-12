parse_year_ja <- function(x) {
  x <- x |>
    stringr::str_remove_all("\\s") |>
    stringi::stri_trans_nfkc()

  # year_ja
  pattern_era <- "(\u660e\u6cbb|\u5927\u6b63|\u662d\u548c|\u5e73\u6210|\u4ee4\u548c)" # "(明治|大正|昭和|平成|令和)"
  era <- x |>
    stringr::str_extract(stringr::str_glue("^{pattern_era}"))
  year_ja <- x |>
    stringr::str_extract(stringr::str_glue("(?<={pattern_era})(\\d+|\u5143)(?=\u5e74?$)")) |> # "(?<={pattern_era})(\\d+|元)(?=年?$)"
    stringr::str_replace("\u5143", "1") |> # "元"
    as.integer()

  # year
  year <- x |>
    stringr::str_extract("^\\d+(?=\u5e74?$)") |> # "^\\d+(?=年?$)"
    as.integer()

  dplyr::case_when(is.na(era) ~ year,
                   era == "\u660e\u6cbb" ~ year_ja + 1868L - 1L, # "明治"
                   era == "\u5927\u6b63" ~ year_ja + 1912L - 1L, # "大正"
                   era == "\u662d\u548c" ~ year_ja + 1926L - 1L, # "昭和"
                   era == "\u5e73\u6210" ~ year_ja + 1989L - 1L, # "平成"
                   era == "\u4ee4\u548c" ~ year_ja + 2019L - 1L) # "令和"
}

check_file <- purrr::insistently(
  function(file) {
    if (!fs::file_exists(file)) {
      abort()
    }
  },
  rate = purrr::rate_backoff(max_times = Inf)
)
