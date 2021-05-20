source("R/20-mRMR.R")

N_features <- 30

# artificial ----
mRMR_filter_artificial <- run_mRMR(artificial, N_features)
plot_data <- tibble(
  index = seq(N_features, 1),
  score = mRMR_filter_artificial@scores[[1]][, 1],
  feature = extract_features_mRMR(mRMR_filter_artificial)
)

ggplot(plot_data, aes(x = index, y = score)) +
  geom_point() +
  ggtitle("mRMR scores for 30 most significant features (artificial dataset)")

# digits ----
mRMR_filter_digits <- run_mRMR(digits, N_features)
plot_data <- tibble(
  index = seq_len(N_features),
  score = mRMR_filter_digits@scores[[1]][, 1],
  feature = extract_features_mRMR(mRMR_filter_digits)
)

ggplot(plot_data[-30, ], aes(x = index, y = score)) +
  geom_point() +
  ggtitle("mRMR scores for 29 most significant features (digits dataset)")
