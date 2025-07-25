# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

candidate_cor_cpp <- function(candidate, outcome) {
    .Call(`_discourse_candidate_cor_cpp`, candidate, outcome)
}

candidate_reg_cpp <- function(candidate, y, positions) {
    .Call(`_discourse_candidate_reg_cpp`, candidate, y, positions)
}

candidate_reg_cpp_se <- function(candidate, y, positions) {
    .Call(`_discourse_candidate_reg_cpp_se`, candidate, y, positions)
}

objective_cpp <- function(x, target_mean, target_sd, obj_weight, eps, mean_dec, sd_dec) {
    .Call(`_discourse_objective_cpp`, x, target_mean, target_sd, obj_weight, eps, mean_dec, sd_dec)
}

error_function_cpp <- function(candidate, outcome, target_cor, target_reg, weight, positions, cor_dec, reg_dec) {
    .Call(`_discourse_error_function_cpp`, candidate, outcome, target_cor, target_reg, weight, positions, cor_dec, reg_dec)
}

error_function_cpp_se <- function(candidate, outcome, target_cor, target_reg_se, weight, positions, cor_dec, reg_dec) {
    .Call(`_discourse_error_function_cpp_se`, candidate, outcome, target_cor, target_reg_se, weight, positions, cor_dec, reg_dec)
}

ols_from_design <- function(X, y) {
    .Call(`_discourse_ols_from_design`, X, y)
}

