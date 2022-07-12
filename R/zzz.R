.onLoad <- function(libname, pkgname) {
  # selenium
  webdriver <<- reticulate::import("selenium", delay_load = TRUE)$webdriver
  Service <<- reticulate::import("selenium.webdriver.chrome.service", delay_load = TRUE)$Service
  By <<- reticulate::import("selenium.webdriver.common.by", delay_load = TRUE)$By
  # ActionChains <<- reticulate::import("selenium.webdriver.common.action_chains", delay_load = TRUE)$ActionChains
  # Select <<- reticulate::import("selenium.webdriver.support.select", delay_load = TRUE)$Select

  # webdriver_manager
  ChromeDriverManager <<- reticulate::import("webdriver_manager.chrome", delay_load = TRUE)$ChromeDriverManager
}
