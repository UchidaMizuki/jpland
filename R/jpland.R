#' @export
jpland <- function(url, download_dir,
                   headless = TRUE) {
  driver <- selenium_driver(download_dir = download_dir,
                            headless = headless)

  Sys.sleep(1)
  driver$get(url)

  Jmap <- driver$find_element(By$CSS_SELECTOR, "ul#Jmap")
  areas <- Jmap$find_elements(By$CSS_SELECTOR, "area")
  pb <- progress::progress_bar$new(total = vec_size(areas))
  for (area in areas) {
    pb$tick()
    if (area$get_attribute("class") == "") {
      area$click()
    }
  }

  table <- driver$find_element(By$CSS_SELECTOR, "table.mb30.responsive-table")
  table <- table$get_attribute("outerHTML") |>
    rvest::read_html() |>
    rvest::html_table() |>
    dplyr::first() |>
    tibble::add_column(menu_button = table$find_elements(By$CSS_SELECTOR, "a#menu-button")) |>
    dplyr::select(!dplyr::any_of("\u30c0\u30a6\u30f3\u30ed\u30fc\u30c9")) |> # "ダウンロード"
    dplyr::rename(dplyr::any_of(c(region = "\u5730\u57df", # "地域"
                                  datum = "\u6e2c\u5730\u7cfb", # "測地系"
                                  year = "\u5e74\u5ea6", # "年度"
                                  file_size = "\u30d5\u30a1\u30a4\u30eb\u5bb9\u91cf", # "ファイル容量"
                                  file_name = "\u30d5\u30a1\u30a4\u30eb\u540d"))) |> # "ファイル名"
    dplyr::mutate(dplyr::across(dplyr::any_of("year"), parse_year_ja),
                  dplyr::across(dplyr::any_of("file_size"), fs::as_fs_bytes))

  tbl_jpland(table,
             download_dir = download_dir,
             driver = driver)
}

#' @export
collect.tbl_jpland <- function(x, ...,
                               unzip = TRUE) {
  download_dir <- attr(x, "download_dir")

  driver <- attr(x, "driver")
  file <- stringr::str_glue("{download_dir}/{x$file_name}")
  menu_button <- x$menu_button

  # Skip user survey
  try({
    menu_button[[1]]$click()
    close_btn_X <- driver$find_element(By$CSS_SELECTOR, "div.close_btn_X")

    if (close_btn_X$is_displayed()) {
      close_btn_X$click()
      warn("Skipped user survey. Please fill out the user survey later.")
    }
  },
  silent = TRUE)

  pb <- progress::progress_bar$new(total = vec_size(file))
  purrr::walk2(file, menu_button,
               purrr::slowly(function(file, menu_button) {
                 pb$tick()

                 if (fs::file_exists(file)) {
                   fs::file_delete(file)
                 }

                 menu_button$click()
                 driver$switch_to$alert$accept()

                 check_file(file)

                 if (unzip) {
                   exdir <- file |>
                     stringr::str_extract("(?<=/)[^/]+(?=\\.zip$)")
                   exdir <- stringr::str_glue("{download_dir}/{exdir}")

                   unzip(file,
                         exdir = exdir)
                   fs::file_delete(file)
                 }
               }))

  driver$close()
  invisible()
}
