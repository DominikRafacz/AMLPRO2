library(mlr3)
library(mlr3learners)
library(mlr3benchmark)
library(e1071)
library(ranger)
library(MASS)
library(progressr)
library(forcats)

task_digits <- TaskClassif$new(
  id = "digits",
  backend = cbind(digits$train, y = {
    y <- digits$labels
    class(y) <- "factor"
    y}),
  target = "y",
  positive = "1"
)

learners <- lrns(
  c("classif.log_reg",
    "classif.naive_bayes",
    "classif.ranger",
    "classif.xgboost"),
  predict_type = "prob"
)

selected_features_sum_wo_mRMR <- paste0("X", c(339, 558, 905, 2302, 3003, 3464, 3657, 3976, 4387, 4508))
selected_features_mRMR <- paste0("X",c(2433, 482, 2093, 4607, 3229, 1833, 2381))
selected_features_reduced <- setdiff(selected_features_sum_wo_mRMR, "X4387") # removed correlations above 0.9
selected_features_reduced_even_more <- setdiff(selected_features_reduced, "X905")

task_digits_sum_wo_mRMR <- task_digits$clone()$select(cols = selected_features_sum_wo_mRMR)
task_digits_sum_wo_mRMR$id <- "digits_sum_wo_mRMR"
task_digits_sum_w_mRMR <- task_digits$clone()$select(cols = c(selected_features_sum_wo_mRMR, selected_features_mRMR))
task_digits_sum_w_mRMR$id <- "digits_sum_w_mRMR"
task_digits_only_mRMR <- task_digits$clone()$select(cols = selected_features_mRMR)
task_digits_only_mRMR$id <- "digits_only_mRMR"
task_digits_reduced <- task_digits$clone()$select(cols = selected_features_reduced)
task_digits_reduced$id <- "digits_reduced"
task_digits_reduced_even_more <- task_digits$clone()$select(cols = selected_features_reduced_even_more)
task_digits_reduced_even_more$id <- "digits_reduced_even_more"

resampling <- rsmp("cv", folds = 5)
design <- benchmark_grid(list(task_digits_sum_wo_mRMR,
                              task_digits_sum_w_mRMR,
                              task_digits_only_mRMR,
                              task_digits_reduced,
                              task_digits_reduced_even_more),
                         learners, resampling)

set.seed(420)
results <- benchmark(design)
results$aggregate(msrs(c("classif.acc", "classif.auc", "classif.bacc")))

results$score(msrs(c("classif.acc", "classif.auc", "classif.bacc"))) %>%
  ggplot(aes(x = fct_relevel(factor(task_id), c("digits_sum_w_mRMR", "digits_only_mRMR", "digits_sum_wo_mRMR", "digits_reduced", "digits_reduced_even_more"
                                                )), y = classif.bacc)) +
  geom_boxplot() +
  facet_wrap(~learner_id) +
  theme_bw() +
  scale_x_discrete(
    name = "selected features",
    labels = c("sum of all", "only mRMR", "without mRMR", "without mRMR, without highly correlated", "without mRMR, without slightly less correlated ")) +
  scale_y_continuous("balanced accuracy") +
  theme(axis.text.x = element_text(angle = 20, hjust = 1)) +
  ggtitle("Comparison of BA on digits for different models for different selection of features", subtitle = "results for 5 iterations of crossvalidation")

ggsave("plots/BA-digits.png", width = 10, height = 7)
