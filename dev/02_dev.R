# Building a Prod-Ready, Robust Shiny Application.
#
# README: each step of the dev files is optional, and you don't have to
# fill every dev scripts before getting started.
# 01_start.R should be filled at start.
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
#
#
###################################
#### CURRENT FILE: DEV SCRIPT #####
###################################

# Engineering

## Dependencies ----
## Amend DESCRIPTION with dependencies read from package code parsing
## install.packages('attachment') # if needed.
attachment::att_amend_desc()
# If you use devtools:
devtools::build_readme()
## Add modules ----
## Create a module infrastructure in R/
golem::add_module(name = "optim_vec", with_test = TRUE) # Name of the module
golem::add_module(name = "optim_aov", with_test = TRUE) # Name of the module
golem::add_module(name = "optim_lm", with_test = TRUE) # Name of the module
golem::add_module(name = "optim_lme", with_test = TRUE) # Name of the module

## Add helper functions ----
## Creates fct_* and utils_*
golem::add_fct("check_grim", with_test = TRUE)
golem::add_fct("weights_vec", with_test = TRUE)
golem::add_fct("weights_est", with_test = TRUE)
golem::add_fct("optim_vec", with_test = TRUE)
golem::add_fct("optim_lm", with_test = TRUE)
golem::add_fct("optim_lme", with_test = TRUE)
golem::add_fct("optim_aov", with_test = TRUE)
golem::add_fct("hill_climb", with_test = TRUE)
golem::add_fct("parallel_lm", with_test = TRUE)
golem::add_fct("parallel_lme", with_test = TRUE)
golem::add_fct("parallel_aov", with_test = TRUE)
golem::add_fct("get_stats", with_test = TRUE)
golem::add_fct("get_stats_parallel", with_test = TRUE)
golem::add_fct("get_rmse", with_test = TRUE)
golem::add_fct("get_rmse_parallel", with_test = TRUE)
golem::add_fct("plot_rmse", with_test = TRUE)
golem::add_fct("summary", with_test = TRUE)
golem::add_fct("print", with_test = TRUE)
golem::add_fct("plot_summary", with_test = TRUE)
golem::add_fct("plot_cooling", with_test = TRUE)
golem::add_fct("plot_error", with_test = TRUE)
golem::add_fct("plot_error_ratio", with_test = TRUE)

golem::add_utils("helpers", with_test = TRUE)
golem::add_utils("helpers_export", with_test = TRUE)
golem::add_utils("discourse-package", with_test = TRUE)
golem::add_utils("server", with_test = TRUE)
## Rcpp
# regenerate Rcpp bindings and NAMESPACE
Rcpp::compileAttributes()


## External resources
## Creates .js and .css files at inst/app/www
golem::add_js_file("script")
golem::add_js_handler("handlers")
golem::add_css_file("custom")
golem::add_sass_file("custom")
golem::add_any_file("file.json")


## Add internal datasets ----
## If you have data in your package
usethis::use_data_raw(name = "data_vec", open = FALSE)
usethis::use_data_raw(name = "data_aov", open = FALSE)
usethis::use_data_raw(name = "data_lm", open = FALSE)
usethis::use_data_raw(name = "data_lme", open = FALSE)

## Tests ----
## Add one line by test you want to create
usethis::use_test("app")
spelling::update_wordlist()
# Documentation

## Vignette ----
usethis::use_vignette("discourse_application")
devtools::build_vignettes()

## Code Coverage----
## Set the code coverage service ("codecov" or "coveralls")
usethis::use_coverage()

# Create a summary readme for the testthat subdirectory
# covrpage::covrpage()

## CI ----
## Use this part of the script if you need to set up a CI
## service for your application
##
## (You'll need GitHub there)
usethis::use_github()

# GitHub Actions
usethis::use_github_action()
# Chose one of the three
# See https://usethis.r-lib.org/reference/use_github_action.html
usethis::use_github_action_check_release()
usethis::use_github_action_check_standard()
usethis::use_github_action_check_full()
# Add action for PR
usethis::use_github_action_pr_commands()

# Circle CI
usethis::use_circleci()
usethis::use_circleci_badge()

# Jenkins
usethis::use_jenkins()

# GitLab CI
usethis::use_gitlab_ci()

# pkgdown
usethis::use_pkgdown_github_pages()

# refresh pkgdown page
# devtools::build_readme()
options(rmarkdown.html_vignette.check_title = FALSE)
pkgdown::build_site_github_pages()

# render about doc
rmarkdown::render("~/Desktop/Research Master/DISCOURSE/inst/app/www/about.Rmd",
                  output_format = "github_document",
                  output_file   = "~/Desktop/Research Master/DISCOURSE/inst/app/www/about.md")

# You're now set! ----
# go to dev/03_deploy.R
rstudioapi::navigateToFile("dev/03_deploy.R")
