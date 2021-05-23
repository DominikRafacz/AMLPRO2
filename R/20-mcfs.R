Sys.setenv(JAVA_HOME="")
options(java.parameters = "-Xmx8g")

if (!require(rmcfs)) {
  install.packages("rmcfs")
  library(rmcfs)
}

run_mcfs <- function(data, ...) {
  mcfs_data <- cbind(labels = data$labels, data$train)
  mcfs(labels ~ ., data = mcfs_data, cutoffPermutations = 0, ...)
}

extract_features_mcfs <- function(mcfs_analysis, num_features) {
  # returns a vector of integers with column indices
  # we suppose that feature numbers are at max of 8-digit length
  mcfs_analysis$RI[seq_len(num_features), "attribute"] %>%
    substr(2, 10) %>%
    as.integer()
}

mcfs_analysis_artificial <- run_mcfs(artificial)
mcfs_features_artificial <- extract_features_mcfs(mcfs_model_artificial, 5)

mcfs_analysis_digits <- run_mcfs(digits)
mcfs_features_digits <- extract_features_mcfs(mcfs_analysis_digits, 6)
