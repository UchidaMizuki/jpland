test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

# library(tidyverse)
#
# df <- jpland("https://nlftp.mlit.go.jp/ksj/gml/datalist/KsjTmplt-L03-b.html", "sample")
#
# df <- df |>
#   slice_head(n = 2)
#
# df |>
#   collect(unzip = FALSE)
