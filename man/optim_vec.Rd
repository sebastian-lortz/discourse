% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fct_optim_vec.R
\name{optim_vec}
\alias{optim_vec}
\title{Optimize a vector or matrix to match target means and SDs}
\usage{
optim_vec(
  N,
  target_mean,
  target_sd,
  range,
  integer,
  tolerance = 1e-08,
  max_iter = 1e+05,
  init_temp = 1,
  cooling_rate = NULL,
  int.probs = NULL,
  progress_bar = TRUE,
  obj_weight = list(c(1, 1)),
  maxit_pso = 2000,
  eps = 1e-12,
  max_starts = 3,
  checkGrim = TRUE,
  prob_heuristic = 0.1,
  parallel = FALSE,
  min_decimals = 1,
  progress_mode = "console"
)
}
\arguments{
\item{N}{Integer. Number of values in each vector.}

\item{target_mean}{Named numeric vector. Desired means for each variable (names identify columns).}

\item{target_sd}{Named numeric vector. Desired standard deviations for each variable.}

\item{range}{Numeric vector of length 2 or numeric matrix. Allowed value range for all variables (vector),
or per-variable bounds as a two-row matrix matching `target_mean`.}

\item{integer}{Logical or logical vector. If TRUE, optimize integer values; length 1 or same length as `target_mean`.}

\item{tolerance}{Numeric. Error tolerance for convergence; stops early if best error < `tolerance`. Default `1e-8`.}

\item{max_iter}{Integer. Maximum iterations for simulated annealing per start. Default `1e5`.}

\item{init_temp}{Numeric. Initial temperature for annealing. Default `1`.}

\item{cooling_rate}{Numeric or NULL. Cooling rate per iteration (0–1); if NULL, computed as `(max_iter - 10) / max_iter`.}

\item{int.probs}{List of numeric vectors, one per variable. Sampling probabilities for integer moves; NULL for uniform.}

\item{progress_bar}{Logical. Show text progress bar during optimization. Default `TRUE`.}

\item{obj_weight}{List of numeric vectors length 2, one per variable. Weights for mean vs. SD error. Default `list(c(1,1))`.}

\item{maxit_pso}{Integer. Maximum PSO iterations for continuous variables. Default `2000`.}

\item{eps}{Numeric. Small constant to avoid division by zero in objective. Default `1e-12`.}

\item{max_starts}{Integer. Number of annealing restarts. Default `3`.}

\item{checkGrim}{Logical. If TRUE and `integer = TRUE`, perform GRIM checks on `target_mean`. Default is FALSE.}

\item{prob_heuristic}{Numeric. Probability of heuristic move vs. random swap in integer mode. Default `0.1`.}

\item{parallel}{Logical. If TRUE, optimize each variable in parallel. Default `FALSE`.}

\item{min_decimals}{Integer. Minimum number of decimal places for target values (including trailing zeros). Default `1`.}

\item{progress_mode}{Character. Either "console" or "shiny" for progress handler. Default `console`.}
}
\value{
A `discourse.object` list containing:
\describe{ A list with the following elements for each variable:
    \item{best_error}{Numeric. Minimum objective error achieved.}
    \item{data}{Data.frame or matrix of optimized vectors (columns named by `target_mean`).}
    \item{track_error}{Numeric vector of best error at each iteration of annealing.}
    \item{inputs}{List of all input parameters for reproducibility.}
    \item{grim}{List of the GRIM results.}
}
}
\description{
Uses the DISCOURSE algorithmic framework to simulate one or multiple
vectors so that each matches specified target means and standard deviations under given input parameters.
}
\examples{
 \dontrun{
# Optimize a vector of length 100
res <- optim_vec(
  N            = 100,
  target_mean  = 10,
  target_sd    = 2,
  range        = c(0, 20),
  integer      = TRUE,
  max_iter     = 50000,
  max_starts   = 2
)
}
}
