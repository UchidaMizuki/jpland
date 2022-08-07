webdriver <- NULL
Service <- NULL
By <- NULL
# ActionChains <- NULL
# Select <- NULL
ChromeDriverManager <- NULL

selenium_driver <- function(download_dir,
                            headless = TRUE) {
  options <- webdriver$ChromeOptions()

  if (headless) {
    options$headless <- TRUE
  }

  prefs <- list(`download.default_directory` = here::here() |>
                  stringr::str_c(download_dir,
                                 sep = "/") |>
                  stringr::str_replace_all("/", r"(\\)"))
  options$add_experimental_option("prefs", prefs)

  webdriver$Chrome(service = Service(ChromeDriverManager()$install()),
                   options = options)
}
