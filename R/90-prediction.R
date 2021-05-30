library(mlr3)
library(mlr3learners)
library(ranger)

selected_features_artificial <- c(49, 106, 242, 339, 425)
selected_features_digits <- c(339, 558, 2302, 3003, 3464, 3657, 3976, 4508)

task_artificial <- TaskClassif$new(
  id = "artificial",
  backend = cbind(artificial$train, y = {
    y <- artificial$labels
    class(y) <- "factor"
    y}),
  target = "y",
  positive = "1"
)$select(paste0("X", selected_features_artificial))

task_digits <- TaskClassif$new(
  id = "digits",
  backend = cbind(digits$train, y = {
    y <- digits$labels
    class(y) <- "factor"
    y}),
  target = "y",
  positive = "1"
)$select(paste0("X", selected_features_digits))


mdl_artificial <- lrn("classif.ranger", predict_type = "prob")
mdl_artificial$train(task_artificial)
preds_artificial <- mdl_artificial$predict_newdata(newdata = artificial$valid[, selected_features_artificial])

mdl_digits <- lrn("classif.ranger", predict_type = "prob")
mdl_digits$train(task_digits)
preds_digits <- mdl_digits$predict_newdata(newdata = digits$valid[, selected_features_digits])

write_csv(data.frame(DOMRAF = preds_artificial$prob[, 1]), "DOMRAF_artificial_prediction.txt")
write_csv(data.frame(DOMRAF = selected_features_artificial), "DOMRAF_artificial_features.txt")
write_csv(data.frame(DOMRAF = preds_digits$prob[, 1]), "DOMRAF_digits_prediction.txt")
write_csv(data.frame(DOMRAF = selected_features_digits), "DOMRAF_digits_features.txt")
