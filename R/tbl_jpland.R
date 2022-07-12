tbl_jpland <- function(x, download_dir, driver) {
  new_data_frame(x,
                 download_dir = download_dir,
                 driver = driver,
                 class = c("tbl_jpland", "tbl"))
}

#' @export
select.tbl_jpland <- function(.data, ...) {
  out <- NextMethod()
  out$menu_button <- .data$menu_button
  out
}

#' @export
format.tbl_jpland <- function(x, ...) {
  download_dir <- attr(x, "download_dir")
  driver <- attr(x, "driver")

  x <- x[names(x) != "menu_button"]
  attr(x, "download_dir") <- download_dir
  attr(x, "driver") <- driver

  NextMethod()
}

#' @export
tbl_sum.tbl_jpland <- function(x) {
  out <- NextMethod()
  names(out) <- "A jpland"
  c(out,
    `Directory` = attr(x, "download_dir"),
    `Driver` = as.character(attr(x, "driver")))
}

#' #' @export
#' group_by.tbl_jpland <- function(.data, ..., .add = FALSE, .drop = group_by_drop_default(.data)) {
#'   out <- NextMethod()
#'   dplyr::new_grouped_df(out, dplyr::group_data(out),
#'                         driver = attr(.data, "driver"),
#'                         class = "grouped_jpland")
#' }
#'
#' #' @export
#' ungroup.grouped_jpland <- function(x, ...) {
#'   out <- NextMethod()
#'   tbl_jpland(out, attr(x, "driver"))
#' }
#'
#' #' @export
#' format.grouped_jpland <- function(x, ...) {
#'   x <- x[names(x) != "menu_button"]
#'   driver <- attr(x, "driver")
#'   c(pillar::style_subtle(stringr::str_glue("# A jpland: {as.character(driver)}")),
#'     NextMethod())
#' }
#'
#' #' @export
#' select.grouped_jpland <- function(.data, ...) {
#'   select.tbl_jpland(.data, ...)
#' }
