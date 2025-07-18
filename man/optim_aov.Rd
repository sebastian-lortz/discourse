% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fct_optim_aov.R
\name{optim_aov}
\alias{optim_aov}
\title{Optimize simulated data to match ANOVA F-values}
\usage{
optim_aov(
  N,
  levels,
  target_group_means,
  target_f_list,
  integer,
  range,
  formula,
  factor_type,
  subgroup_sizes = NULL,
  df_effects = NULL,
  tolerance = 1e-08,
  typeSS = 3,
  max_iter = 1000,
  init_temp = 1,
  cooling_rate = NULL,
  max_step = 0.2,
  max_starts = 1,
  checkGrim = FALSE,
  min_decimals = 1,
  progress_bar = TRUE,
  progress_mode = "console"
)
}
\arguments{
\item{N}{Integer. Total number of subjects (sum of `subgroup_sizes`).}

\item{levels}{Integer vector. Number of factor levels per factor in the design.}

\item{target_group_means}{Numeric vector. Desired means for each group in the design.}

\item{target_f_list}{List with components:
\describe{
  \item{F}{Numeric vector of target F-statistics.}
  \item{effect}{Character vector of effect names matching `F`.}
  \item{contrast}{Optional character formula for contrasts.}
  \item{contrast_method}{Optional character specifying contrast method.}
}}

\item{integer}{Logical. If TRUE, candidate values are treated as integers, if FALSE treated as continuous values.}

\item{range}{Numeric vector of length 2. Lower and upper bounds for candidate means.}

\item{formula}{Formula or character. Model formula used to compute F-values (e.g., `y ~ A + B + A*B`).}

\item{factor_type}{Character vector. Type of each factor (`"between"` or `"within"`) matching length of `levels`.}

\item{subgroup_sizes}{Numeric vector. Optional sizes of each between-subjects group for unbalanced designs; length must equal product of `levels` for between factors.}

\item{df_effects}{Numeric vector. Degrees of freedom of the model effects. Default is `NULL`.}

\item{tolerance}{Numeric. Error tolerance for convergence; stops early if best error < `tolerance`. Default `1e-6`.}

\item{typeSS}{Integer. Type of sums-of-squares for ANOVA (2 or 3). Default is 3.}

\item{max_iter}{Integer. Maximum iterations per restart. Default is 1e3.}

\item{init_temp}{Numeric. Initial temperature for annealing. Default is 1.}

\item{cooling_rate}{Numeric. Cooling rate per iteration (between 0 and 1); if NULL, calculated automatically as `(init_temp-10)/init_temp`.}

\item{max_step}{Numeric. Maximum move size as proportion of `range`. Default is 0.2.}

\item{max_starts}{Integer. Number of annealing restarts. Default is 1.}

\item{checkGrim}{Logical. If TRUE and `integer = TRUE`, perform GRIM checks on `target_group_means`. Default is FALSE.}

\item{min_decimals}{Integer. Minimum number of decimal places for target values (including trailing zeros). Default `1`.}

\item{progress_bar}{Logical. Show text progress bar during optimization. Default is TRUE.}

\item{progress_mode}{Character. Either "console" or "shiny" (or "off" internally set) for progress handler. Default `console`.}
}
\value{
A `discourse.object` list containing:
\describe{
  \item{best_error}{Numeric. Minimum error (RMSE) achieved.}
  \item{data}{Data frame of optimized outcome values (and grouping variables).}
  \item{inputs}{List of all input arguments.}
  \item{track_error}{Numeric vector of best error at each iteration.}
  \item{grim}{List of the GRIM results.}
}
}
\description{
Uses the DISCOURSE algorithmic framework to simulate data that
produce target ANOVA F-statistics under a specified factorial design given input parameters.
}
\examples{
 \dontrun{
# Balanced 2x2 design
optim_aov(
  N = 40,
  levels = c(2, 2),
  target_group_means = c(1, 2, 3, 4),
  target_f_list = list(effect = c("A", "B"),
                       F = c(5.6, 8.3), ),
  formula = y ~ A + B + A*B,
  factor_type = c("between", "between"),
  range = c(0, 5),
  integer = FALSE,
  max_iter = 1000,
  max_starts = 3
)
}
}
