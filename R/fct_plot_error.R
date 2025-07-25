#' Plot Error Ratio Evolution for a discourse.object
#'
#' Creates a plot of error versus iteration, to assess the trajectory of the
#' objective function value of a `discourse.object`.
#'
#' @param discourse_obj A `discourse.object` S3 object produced by `optim_*` functions,
#'   containing a `track_error` element (numeric vector or list of vectors).
#' @param run Integer. Index of the run to plot when `track_error` is a list; default `1`.
#' @param show_best Logical. If `TRUE`, adds a point marking the minimum error; default `TRUE`.
#' @param first_iter Integer. Number of initial iterations to skip before plotting (zero-based);
#'   default `1` (plots from iteration 2 onward).
#'
#' @return A `ggplot2` object.
#'
#' @examples
#'  \dontrun{
#' result <- optim_lme(args = ..., ...)
#' plot_error(result, first_iter = 500)
#' }
#' @importFrom rlang .data
#' @import ggplot2
#' @export
plot_error <- function(discourse_obj, run = 1, show_best = TRUE, first_iter = 1) {

  if (!requireNamespace("ggplot2", quietly=TRUE)) {
    stop("`ggplot2` is needed to plot summaries; please install it.")
  }
if (run<1) {
  stop("`run` must be a positive integer.")
}
  # theme
  apa_theme <- ggplot2::theme_minimal(base_size = 12, base_family = "Helvetica") +
    ggplot2::theme(
      panel.grid.major = ggplot2::element_line(color = "gray90"),
      panel.grid.minor = ggplot2::element_blank(),
      plot.title       = ggplot2::element_text(face = "bold", size = 14, hjust = 0),
      axis.text        = ggplot2::element_text(color = "black")
      )

  # input check
  if (!inherits(discourse_obj, "discourse.object")) {
    stop("Input must be a .discourse object.")
  }
  if (is.null(discourse_obj$track_error)) {
    return(NULL)
    stop(sprintf("No track_error element found. PSO routines in the Descriptives module do not have a track_error element."))
  }

  # data
  err_data <- discourse_obj$track_error
  if (is.list(err_data)) {
    n_runs <- length(err_data)
    if (run < 1 || run > n_runs) {
      stop(sprintf(
        "Run index out of bounds. There %s only %d run%s using integer data. PSO routines (continous data) in the Descriptives module do not have a track_error element.",
        if (n_runs == 1) "is" else "are",
        n_runs,
        if (n_runs == 1) "" else "s"
      ))
    }
    err_vec <- err_data[[run]]
  } else {
    if (run != 1) {
      stop("Run index out of bounds. There is only 1 run.")
    }
    err_vec <- err_data
  }
  seg_err <- err_vec[(first_iter + 1):length(err_vec)]
  df <- data.frame(
    Iteration = first_iter + seq_along(seg_err),
    Error     = seg_err
  )
  best_idx   <- which.min(err_vec)[1]
  best_error <- err_vec[best_idx]

  # plot
  p <- ggplot2::ggplot(df, ggplot2::aes(.data$Iteration, .data$Error)) +
    ggplot2::geom_line(color = "steelblue", linewidth = 1) +
    ggplot2::geom_hline(yintercept = 0, linetype = "dashed") +
    ggplot2::labs(
      title = "Error Reduction of Objective Function",
      x     = "Iteration",
      y     = "Error"
    ) +
    apa_theme +
    ggplot2::coord_cartesian(clip = "off")
  if (show_best) {
    best_df <- data.frame(Iteration = best_idx, Error = best_error)
    p <- p + ggplot2::geom_point(
      data        = best_df,
      ggplot2::aes(.data$Iteration, .data$Error, color = "Best Error"),
      size        = 3,
      show.legend = TRUE
    )
  }
  p <- p +
    ggplot2::scale_color_manual(
      name   = "",
      values = c("Best Error" = "red"),
      breaks = "Best Error",
      labels = paste("Best Error =", formatC(best_error, format = "e", digits = 3))
    ) +
    ggplot2::theme(legend.position = "bottom")

  # return
  print(p)
  invisible(p)
}
