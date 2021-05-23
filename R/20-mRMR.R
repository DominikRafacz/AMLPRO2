if (!require(mRMRe)) {
  remotes::install_github("bhklab/mRMRe@2d9de55")
  library(mRMRe)
}

run_mRMR <- function(data, num_features) {
  mRMR_data <- mRMR.data(cbind(labels = data$labels, data$train))
  mRMR_filter <- mRMR.classic(
    data = mRMR_data,
    target_indices = 1,
    feature_count = num_features
  )
  mRMR_filter
}

extract_features_mRMR <- function(mRMR_filter) {
  # returns a vector of integers with column indices
  # subtracted 1 because of added labels column at position 1
  as.integer(solutions(mRMR_filter)[[1]]) - 1
}

mRMR_filter_artificial <- run_mRMR(artificial, 5)
mRMR_features_artificial <- extract_features_mRMR(mRMR_filter_artificial)

mRMR_filter_digits <- run_mRMR(digits, 7)
mRMR_features_digits <- extract_features_mRMR(mRMR_filter_digits)
