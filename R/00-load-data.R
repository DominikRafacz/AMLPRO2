library(tidyverse)

load_data <- function(data) {
  data_train <- read_table2(paste0("data/", data, "_train.data"),
                            col_names = FALSE) %>%
    select(where(is_double))
  data_labels <- read_lines(paste0("data/", data, "_train.labels")) %>%
    as_factor()
  data_valid <- read_table2(paste0("data/", data, "_valid.data"),
                            col_names = FALSE) %>%
    select(where(is_double))
  list(
    train = data_train,
    labels = data_labels,
    valid = data_valid
  )
}

artificial <- load_data("artificial")
digits <- load_data("digits")
