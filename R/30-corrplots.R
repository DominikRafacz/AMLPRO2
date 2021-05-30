library(corrplot)

artificial_features <- c(
  c(476, 339, 242),
  c(242, 129, 476, 106, 339),
  c(476, 49, 425),
  c(242, 476, 339, 106, 129)
) %>% unique() %>% sort()

cor(artificial$train[, artificial_features]) %>%
  corrplot::corrplot()

cor(artificial$train[, mRMR_features_artificial %>% sort()]) %>%
  corrplot::corrplot()

digits_features <- c(
  c(3976, 558, 3657, 905, 3003, 339, 2302),
  c(3657, 3976, 558),
  c(3657, 558, 4508, 4387, 2302, 3464)
) %>% unique() %>% sort()

cor(digits$train[, digits_features]) %>%
  corrplot::corrplot()

cor(digits$train[, mRMR_features_digits %>% sort()]) %>%
  corrplot::corrplot()
