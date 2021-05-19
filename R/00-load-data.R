library(tidyverse)

load_data <- function(data) {
  data_train <- read.table(paste0("data/", data, "_train.data"))
  data_labels <- read_lines(paste0("data/", data, "_train.labels")) %>%
    as.numeric()
  data_valid <- read.table(paste0("data/", data, "_valid.data"))
  list(
    train = data_train,
    labels = data_labels,
    valid = data_valid
  )
}

artificial <- load_data("artificial")
digits <- load_data("digits")
