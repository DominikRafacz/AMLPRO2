library(mlr3)
library(mlr3learners)
library(mlr3benchmark)
library(e1071)
library(ranger)
library(MASS)
library(progressr)
library(forcats)

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

selected_features_sum_wo_mRMR <- paste0("X", c(49, 106, 129, 242, 339, 425, 476))
selected_features_mRMR <- paste0("X",c(91, 229, 277, 405, 424))
selected_features_reduced <- setdiff(selected_features_sum_wo_mRMR, paste0("X", c(129, 476)))

task_artificial_sum_wo_mRMR <- task_artificial$clone()$select(cols = selected_features_sum_wo_mRMR)
task_artificial_sum_wo_mRMR$id <- "artificial_sum_wo_mRMR"
task_artificial_sum_w_mRMR <- task_artificial$clone()$select(cols = c(selected_features_sum_wo_mRMR, selected_features_mRMR))
task_artificial_sum_w_mRMR$id <- "artificial_sum_w_mRMR"
task_artificial_only_mRMR <- task_artificial$clone()$select(cols = selected_features_mRMR)
task_artificial_only_mRMR$id <- "artificial_only_mRMR"
task_artificial_reduced <- task_artificial$clone()$select(cols = selected_features_reduced)
task_artificial_reduced$id <- "artificial_reduced"

resampling <- rsmp("cv", folds = 5)
design <- benchmark_grid(list(task_artificial_sum_wo_mRMR,
                              task_artificial_sum_w_mRMR,
                              task_artificial_only_mRMR,
                              task_artificial_reduced),
                         learners, resampling)

set.seed(420)
results <- benchmark(design)
results$aggregate(msrs(c("classif.acc", "classif.auc", "classif.bacc")))

results$score(msrs(c("classif.acc", "classif.auc", "classif.bacc"))) %>%
  ggplot(aes(x = fct_relevel(factor(task_id), c("artificial_sum_w_mRMR", "artificial_only_mRMR", "artificial_sum_wo_mRMR", "artificial_reduced")), y = classif.bacc)) +
  geom_boxplot() +
  facet_wrap(~learner_id) +
  theme_bw() +
  scale_x_discrete(
    name = "selected features",
    labels = c("sum of all", "only mRMR", "without mRMR, without correlated", "without mRMR")) +
  scale_y_continuous("balanced accuracy") +
  ggtitle("Comparison of BA for different models for different selection of features", subtitle = "results for 5 iterations of crossvalidation")

ggsave("plots/BA-artificial.png")
