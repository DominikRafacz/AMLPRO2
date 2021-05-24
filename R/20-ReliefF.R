if (!require(CORElearn)) {
  install.packages("CORElearn")
  library(CORElearn)
}

run_ReliefF <- function(data, ...) {
  single_values_cols <- which(lapply(data$train, unique) %>% sapply(length) == 1)
  ReliefF_data <- bind_cols(labels = data$labels, data$train[, -single_values_cols])
  attrEval("labels", data = ReliefF_data, estimator = "ReliefFexpRank", ...)
}

extract_features_ReliefF <- function(ReliefF_analysis, num_features) {
  # returns a vector of integers with column indices
  sort(ReliefF_analysis, decreasing = TRUE)[seq_len(num_features)] %>%
    names() %>%
    substr(2, 10) %>%
    as.integer()
}

ReliefF_analysis_artificial <- run_ReliefF(artificial)
ReliefF_features_artificial <- extract_features_ReliefF(
  ReliefF_analysis_artificial, 5)

ReliefF_analysis_digits <- run_ReliefF(digits)
ReliefF_features_digits <- extract_features_ReliefF(
  ReliefF_analysis_digits, 6)
