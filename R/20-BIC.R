if (!require(MASS)) {
  install.packages("MASS")
  library(MASS)
}

generate_formula <- function(data) {
  paste0(
    "labels ~ ",
    paste0("X", seq_along(data$train), collapse = " + ")
  )
}

run_BIC <- function(data, ...) {
  BIC_data <- bind_cols(labels = data$labels, data$train)
  model <- glm(labels ~ 1, family = "binomial", data = BIC_data)
  stepAIC(model,
          scope = list(lower = as.formula("labels ~ 1"),
                       upper = as.formula(generate_formula(data))),
          direction = "both",
          steps = 1e4,
          k = log(nrow(BIC_data)), ...)
}

extract_features_BIC <- function(BIC_model) {
  # returns a vector of integers with column indices
  BIC_model$coefficients[-1] %>%
    names() %>%
    substr(2, 10) %>%
    as.integer()
}

BIC_model_artificial <- run_BIC(artificial)
BIC_features_artificial <- extract_features_BIC(BIC_model_artificial)

BIC_model_digits <- run_BIC(digits)
BIC_features_digits <- extract_features_BIC(BIC_model_digits)
