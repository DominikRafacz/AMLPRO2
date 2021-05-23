if (!require(randomForest)) {
  install.packages("randomForest")
  library(randomForest)
}

run_rf <- function(data, ...) {
  rf_data <- bind_cols(labels = data$labels, data$train)
  randomForest(labels ~ ., data = rf_data, ...)
}

extract_features_rf <- function(rf_model, num_features) {
  # returns a vector of integers with column indices
  order(importance(rf_model), decreasing = TRUE)[seq_len(num_features)]
}

rf_model_artificial <- run_rf(artificial)
# use varImpPlot to find optimal num_features
randomForest::varImpPlot(rf_model_artificial)
rf_features_artificial <- extract_features_rf(rf_model_artificial, 3)

rf_model_digits <- run_rf(digits)
# use varImpPlot to find optimal num_features
randomForest::varImpPlot(rf_model_digits)
rf_features_digits <- extract_features_rf(rf_model_digits, 7)
