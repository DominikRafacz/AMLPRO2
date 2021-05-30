library(mlr3)
library(mlr3learners)
library(mlr3benchmark)
library(e1071)
library(ranger)
library(MASS)
library(progressr)

task_artificial <- TaskClassif$new(
  id = "artificial",
  backend = cbind(artificial$train, y = {
    y <- artificial$labels
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

selected_features_sum_wo_mRMR <- c(49, 106, 129, 242, 339, 425, 476)
selected_features_mRMR <- c(91, 229, 277, 405, 424)

task_artificial_sum_wo_mRMR <- task_artificial$clone()$select(cols = paste0("X", selected_features_sum_wo_mRMR))
task_artificial_sum_wo_mRMR$id <- "artificial_sum_wo_mRMR"
task_artificial_sum_w_mRMR <- task_artificial$clone()$select(cols = paste0("X", c(selected_features_sum_wo_mRMR, selected_features_mRMR)))
task_artificial_sum_w_mRMR$id <- "artificial_sum_w_mRMR"
task_artificial_only_mRMR <- task_artificial$clone()$select(cols = paste0("X", selected_features_mRMR))
task_artificial_only_mRMR$id <- "artificial_only_mRMR"

resampling <- rsmp("cv", folds = 5)
design <- benchmark_grid(list(task_artificial_sum_wo_mRMR,
                              task_artificial_sum_w_mRMR,
                              task_artificial_only_mRMR),
                         learners, resampling)

set.seed(420)
results <- benchmark(design)
results$aggregate(msrs(c("classif.acc", "classif.auc")))

results$score(msrs(c("classif.acc", "classif.auc"))) %>%
  ggplot(aes(x = task_id, y = classif.acc)) +
  geom_boxplot() +
  facet_wrap(~learner_id) +
  theme_bw()
