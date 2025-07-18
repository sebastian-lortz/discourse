#' optim_aov UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs disable enable
#' @importFrom shinyWidgets numericRangeInput
#' @importFrom rhandsontable rHandsontableOutput renderRHandsontable hot_to_r hot_col hot_table
#' @importFrom htmltools HTML
#' @noRd
NULL
mod_optim_aov_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shinyjs::useShinyjs(),
    tags$head(
      tags$style(HTML("
    .rhandsontable .ht_master .wtHolder,
    .rhandsontable .ht_master .handsontable {
      overflow: visible !important;
    }
    .rhandsontable .ht_master .htDropdownMenu,
    .rhandsontable .ht_master .htContextMenu {
      z-index: 9999 !important;
    }
    .rhandsontable .ht_master .htDropdownMenu .dropdown-menu {
      max-height: none !important;
      white-space: normal !important;
    }
    .rhandsontable .ht_master .htDropdownMenu table {
      width: auto !important;
    }
  "))
    ),

    div(style = "white-space: nowrap;",
            div(
              style = "display:inline-block; vertical-align:top; margin-right:10px;",
            wellPanel(
              h4("Reported Summary Statistics"),
              numericInput(ns("N"),  name_with_info(
                "Sample Size",
                "The length of the target vectors.")
                , 443, min = 10, step = 1),
                p(tags$b(name_with_info(
                  "Factors",
                  "Define each factor: its name, # levels, and whether between- or within-subjects."
                ))),
                div(
                  style = "width:100%; overflow-x:auto; overflow-y:visible; position:relative;",
                  rhandsontable::rHandsontableOutput(ns("factor_table"), height = "100px")
                ),
                fluidRow(
                  column(6, actionButton(ns("add_factor"),    "Add factor",    class = "btn-sm btn-block")),
                  column(6, actionButton(ns("remove_factor"), "Remove factor", class = "btn-sm btn-block"))
                ),
                p(tags$b(name_with_info(
                  "Subgroup Means",
                  "All combinations of factor levels; enter the mean and sample size for each."
                ))),
                div(
                  style = "width:100%; overflow-x:auto; overflow-y:visible; position:relative;",
                  rhandsontable::rHandsontableOutput(ns("subgroup_table"))
                ),
                fluidRow(
                  column(6)
                ),
              p(tags$b(name_with_info(
                "ANOVA Outcomes",
                "The ANOVA's effect, df, F-values, and contrasts"
              ))),
              div(
                style = "width:100%; overflow-x:auto; overflow-y:visible; position:relative;",
                rHandsontableOutput(ns("anova_table"), height = "100px")
              ),
              fluidRow(
                column(6, actionButton(ns("add_effect"),    "Add row",    class = "btn-sm btn-block")),
                column(6, actionButton(ns("remove_effect"), "Remove row", class = "btn-sm btn-block"))
              ),
              fluidRow(
                    column(
                        width = 6,
                        checkboxGroupInput(
                            ns("main_effects"),
                            label   = tags$span(style = "font-size:90%;", "Main Effects:"),
                           choices = NULL
                          )
                      ),
                    column(
                        width = 6,
                        checkboxGroupInput(
                            ns("inter_effects"),
                            label   = tags$span(style = "font-size:90%;", "Interaction Effects:"),
                            choices = NULL
                          )
                      )
                  ),

              div(
                style = "margin-top: 10px; width:100%;",
                shinyWidgets::numericRangeInput(
                  ns("range"),
                  label = name_with_info(
                    "Outcome Range",
                    "Lower and upper bounds for simulated outcome values."
                  ),
                  value = c(0, 60),
                  min   = NA,
                  max   = NA,
                  separator = " to ",
                  width = "200px"
                ),
                checkboxInput(
                  ns("integer"),
                  label = name_with_info(
                    "Integer",
                    "If checked, the ANOVA optimization will treat the outcome as integer-valued."
                  ),
                  value = TRUE
                ),
                selectInput(
                  ns("typeSS"),
                  label = name_with_info(
                    "Type of Sum-of-Squares",
                    "Choose Type II or Type III sums of squares."
                  ),
                  choices  = c("Type II" = 2, "Type III" = 3),
                  selected = 3,
                  width    = "100%"
                )
              )
            ))
            ,

        div(
          style = "display:inline-block; vertical-align:top; margin-right:20px;",
        wellPanel(
              h4("Algorithm Hyperparameters"),
              numericInput(
                ns("tolerance"),
                name_with_info(
                  "Tolerance",
                  "The threshold for the weighted objective function value below which the optimization will stop."),
                value = 1e-12,
                min   = 0,
                step  = 1e-12,
                width = "100%"
              ),
              numericInput(ns("max_iter"), name_with_info(
                "Max Iterations",
                "The maximum number of iterations the algorithm will run each time it restarts and for each variable."), 1e4,   min = 1,    step = 1000),
              numericInput(ns("init_temp"), name_with_info(
                "Initial Temperature",
                "The starting temperature for the simulated annealing, which sets the initial likelihood of accepting worse solutions in the first start."),
                1, min = 0, max = 10,    step = 0.01),
              numericInput(ns("cooling_rate"), name_with_info(
                "Cooling Rate",
                "The factor by which the temperature is multiplied after each iteration, governing how quickly the algorithm reduces its acceptance of worse solutions."),
                (1e4-10)/1e4, min = 0, max = 1, step = 0.0001),
              numericInput(ns("max_step"), name_with_info(
                "Max Step Size",
                "The proportion of the range governing the maximum magnitude of modification in an iteration, preventing early convergence."),
                0.2, min = 0, max = 1, step = 0.01),
              numericInput(ns("max_starts"), name_with_info(
                "Max Starts",
                "The maximum number of times the optimization algorithm will restart from the current best solution using reduced inital temperatures."),
                1,     min = 1,    step = 1),
              numericInput(ns("parallel_start"),
                name_with_info(
                  "Number of Datasets",
                  "How many independent optimization runs to perform."),
                value = 1, min = 1, step = 1),
              checkboxInput(ns("return_best"), name_with_info(
                  "Return Best Dataset",
                  "If checked, only the dataset with the lowest objective value is returned."),
                value = FALSE)
            )
        ),

        div(style = "display:inline-block; vertical-align:top; margin-left:20px; width: calc(100% - auto);",
          h4("Optimization Output"),
          div(style = "margin-bottom:10px;",
              actionButton(ns("run"), name_with_info(
                "Run Optimization",
                "Executes DISCOURSE: Data-Simulation via iterative stochastic combinatorial optimization using reported summary estimates."), class = "btn-primary")
          ),
          div(
            id    = ns("processing_msg"),
            style = "display:none; margin:10px; font-weight:bold; color:#337ab7;",
            "Processing, please wait ..."
          ),
          textOutput(ns("status_text")),
          selectInput(ns("dataset_selector"), name_with_info("Select Dataset", "Choose the data set to inspect or download."),
                      choices = NULL, selected = 1,   width    = "100px"),
          h5(name_with_info("Objective Function Value","The minimum weighted value of the objective function attained by the optimization.")),
          tableOutput(ns("best_error")),
          fluidRow( style = "margin-bottom: 10px;",
            column(12,
                   actionButton(ns("plot_summary"),    name_with_info("Plot Summary","Plot summary differences"), class = "btn-sm"),
                   actionButton(ns("plot_error"),      name_with_info("Plot Errors","Show objective value trajectory"), class = "btn-sm"),
                   actionButton(ns("plot_cooling"),    name_with_info("Plot Cooling","Show temperature schedule"), class = "btn-sm"),
                   actionButton(ns("plot_rmse"),       name_with_info("Plot RMSE","Plot RMSE across runs"), class = "btn-sm"),
                   actionButton(ns("get_rmse"),        name_with_info("Get RMSE","Compute unweighted RMSE"), class = "btn-sm"),
                   actionButton(ns("get_rmse_parallel"),name_with_info("Get RMSE Parallel","Compute RMSE across all runs"), class = "btn-sm")
            )
          ),
          fluidRow(
            column(12,
                   actionButton(ns("display_data"),    name_with_info("Display Data","Show head of simulated data"), class = "btn-sm"),
                   actionButton(ns("download"),        name_with_info("Download","Download data or full object"), class = "btn-sm")
            )
          ),
          div(style = "overflow:auto; margin-top:10px;", uiOutput(ns("main_output")))
        )
    )
  )
}


#' optim_aov Server Functions
#'
#' @noRd
mod_optim_aov_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    initial_factors <- data.frame(
      name   = c("Factor1", "Factor2"),
      levels = c(2, 2),
      type   = c("between", "within"),
      stringsAsFactors = FALSE
    )
    initial_subgroups <- data.frame(
      Factor1 = rep(1:2, each = 2),
      Factor2 = rep(1:2, 2),
      Mean    = c(31.4, 21.4, 30.1, 17.8),
      Size    = c(230,230,213,213),
      stringsAsFactors = FALSE
    )
    initial_aov <- data.frame(
      effect    = c("Factor1","Factor2","Factor1:Factor2"),
      df_effect = c(1,1,1),
      F         = c(8.2,321.2,3.4),
      stringsAsFactors = FALSE
    )

    rv <- reactiveValues(
      factors   = initial_factors,
      subgroups = initial_subgroups,
      status    = "ready",
      result = NULL,
      dirty = TRUE
    )

    observeEvent({
      list(
      input$N,
      input$factor_table,
      input$add_factor,
      input$remove_factor,
      input$subgroup_table,
      input$anova_table,
      input$main_effects,
      input$inter_effects,
      input$range,
      input$integer,
      input$typeSS,
      input$tolerance,
      input$max_iter,
      input$init_temp,
      input$cooling_rate,
      input$max_starts,
      input$parallel_start,
      input$return_best)
    }, {
      rv$dirty <- TRUE
      for (btn in c(
        "plot_error","get_rmse","get_rmse_parallel",
        "plot_summary","plot_rmse","plot_cooling",
        "display_data","download","dataset_selector"
      )) {
        shinyjs::disable(btn)
      }
    })

    output$subgroup_table <- renderRHandsontable({
      req(rv$subgroups)
      rhandsontable(rv$subgroups, rowHeaders = NULL) %>%
        {
          tb <- .
          factor_cols <- names(rv$subgroups)[ names(rv$subgroups) %in% rv$factors$name ]
          for (col in factor_cols) {
            tb <- hot_col(tb, col = col, readOnly = TRUE)
          }
          hot_col(tb, "Mean", type = "numeric", format = "0.00") %>%
            hot_col("Size", type = "numeric", format = "0")
        }
    })

    build_subgroups <- function(factors_df) {
      lvls <- lapply(factors_df$levels, function(n) seq_len(n))
      names(lvls) <- factors_df$name
      sg <- expand.grid(rev(lvls), KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE)
      sg <- sg[, rev(seq_along(sg)), drop = FALSE]
      sg$Mean <- NA_real_
      sg$Size <- NA_real_
      sg
    }

    observeEvent(rv$factors, {
       ff <- rv$factors
      valid <- !is.na(ff$levels) &
        ff$levels >= 2     &
         ff$levels == floor(ff$levels)
      if (all(valid)) {
        rv$subgroups <- build_subgroups(ff)
      }
    }, ignoreInit = TRUE)

    output$factor_table <- renderRHandsontable({
      rhandsontable(rv$factors, rowHeaders = NULL) %>%
        hot_col("name",   type = "text") %>%
        hot_col("levels", type = "numeric", format = "0") %>%
        hot_col("type",   type = "dropdown", source = c("between", "within"))
    })

    observeEvent(input$factor_table, {
      req(input$factor_table)
      rv$factors <- hot_to_r(input$factor_table)
    })

    observeEvent(input$add_factor, {
      df <- rv$factors
      df[nrow(df) + 1, ] <- list(name = sprintf("Factor%d", nrow(df) + 1),
                                 levels = NA_integer_,
                                 type = "between")
      rv$factors <- df
    })
    observeEvent(input$remove_factor, {
      df <- rv$factors
      if (nrow(df) > 1) rv$factors <- df[-nrow(df), ]
    })

    observeEvent(input$subgroup_table, {
      req(input$subgroup_table)
      rv$subgroups <- hot_to_r(input$subgroup_table)
    })

    initial_df_aov <- data.frame(
      effect          = c("Factor1", "Factor2", "Factor1:Factor2"),
      df_effect       = c(1,    1,     1),
      F               = c(8.2, 321.2, 3.4),
      stringsAsFactors = FALSE
    )
    rv_aov <- reactiveValues(
      params = initial_df_aov,
      result = NULL,
      status = "ready",
      last   = NULL
    )

    output$anova_table <- renderRHandsontable({
      facts <- rv$factors$name
      inters <- if (length(facts)>1) utils::combn(facts,2, FUN = function(x) paste(x,collapse=":")) else character(0)
      choices <- c(facts, inters)
      rhandsontable(rv_aov$params, useTypes = TRUE) %>%
        hot_table(overflow = "visible") %>%
        hot_col(
          "effect",
          type         = "dropdown",
          source       = choices,
          strict       = TRUE,
          allowInvalid = FALSE
        ) %>%
        hot_col("df_effect", type = "numeric", format = "0") %>%
        hot_col("F",         type = "numeric", format = "0.00")
    })

    observeEvent(input$anova_table, {
      req(input$anova_table)
      rv_aov$params <- hot_to_r(input$anova_table)
    })

    observeEvent(input$add_effect, {
      df <- rv_aov$params
      df[nrow(df)+1, ] <- list(
        effect          = "",
        df_effect       = NA_real_,
        F               = NA_real_
      )
      rv_aov$params <- df
    })
    observeEvent(input$remove_effect, {
      df <- rv_aov$params
      if (nrow(df) > 1) rv_aov$params <- df[-nrow(df), , drop = FALSE]
    })

    observe({
      facts <- rv$factors$name
      inters <- if (length(facts) > 1)
        combn(facts, 2, FUN = function(x) paste(x, collapse = ":"), simplify = TRUE)
      else
        character(0)
      updateCheckboxGroupInput(
        session, "main_effects",
        choices  = facts,
        selected = facts
      )
      updateCheckboxGroupInput(
        session, "inter_effects",
        choices  = inters,
        selected = inters
      )
    })

    formula_reactive <- reactive({
      sel <- c(input$main_effects, input$inter_effects)
      req(sel)
      rhs <- paste(sel, collapse = " + ")
      if (rhs == "") return(NULL)

      within_facts <- rv$factors$name[ rv$factors$type == "within" ]
      if (length(within_facts)) {
        rhs <- paste0(rhs,
                      " + Error(ID/",
                      paste(within_facts, collapse = "/"),
                      ")")
      }
      as.character(paste("outcome ~", rhs))
    })

    observeEvent(input$max_iter, {
      updateNumericInput(session, "cooling_rate",
                         value = max(0, min(1, (input$max_iter - 10)/input$max_iter))
      )
    })

    for(btn in c("run", "plot_error","get_rmse","get_rmse_parallel",
                 "plot_summary","plot_rmse","plot_cooling",
                 "display_data","download", "dataset_selector")) {
      shinyjs::disable(btn)
    }

    observe({
      df_sub <- rv$subgroups
      ok1 <- !is.null(df_sub) &&
        nrow(df_sub) > 0 &&
        all(!is.na(df_sub$Mean), !is.na(df_sub$Size))
      df_aov <- rv_aov$params
      ok2 <- !is.null(df_aov) &&
        nrow(df_aov) > 0 &&
        all(nzchar(df_aov$effect),
            !is.na(df_aov$df_effect),
            !is.na(df_aov$F))
      if (ok1 && ok2) {
        shinyjs::enable("run")
      } else {
        shinyjs::disable("run")
      }
    })

    observeEvent(input$run, {
      shinyjs::show("processing_msg")
      on.exit(shinyjs::hide("processing_msg"), add = TRUE)
      levels_int         <- as.integer(rv$factors$levels)
      target_group_means <- rv$subgroups$Mean
      subgroup_sizes     <- rv$subgroups$Size[rv$factors$type == "between"]
      N                  <- input$N
      if (length(subgroup_sizes) == 0) {
        total_subgroups <- N
      } else {
        total_subgroups <- sum(subgroup_sizes)
      }
      if (N != total_subgroups) {
        showNotification(
          sprintf("Total N (%d) must equal sum of subgroup sizes (%d).", N, total_subgroups),
          type = "error"
        )
        return()
      }

      aov_df             <- hot_to_r(input$anova_table)
      target_f_list      <- list(
        effect          = aov_df$effect,
        F               = aov_df$F,
        contrast        = NULL,
        contrast_method = NULL
      )
      df_effects         <- aov_df$df_effect
      integer            <- input$integer
      range              <- input$range
      formula            <- formula_reactive()
      tolerance          <- input$tolerance
      factor_type        <- rv$factors$type
      typeSS             <- as.integer(input$typeSS)
      max_iter           <- input$max_iter
      init_temp          <- input$init_temp
      cooling_rate       <- input$cooling_rate
      max_step           <- input$max_step
      max_starts         <- input$max_starts
      checkGrim          <- TRUE
      parallel_start     <- input$parallel_start
      return_best_solution <- input$return_best
      fn_args <- list(
        N                    = N,
        levels               = levels_int,
        subgroup_sizes       = subgroup_sizes,
        target_group_means   = target_group_means,
        target_f_list        = target_f_list,
        df_effects           = df_effects,
        integer              = integer,
        range                = range,
        formula              = formula,
        tolerance            = tolerance,
        factor_type          = factor_type,
        typeSS               = typeSS,
        max_iter             = max_iter,
        init_temp            = init_temp,
        cooling_rate         = cooling_rate,
        max_step             = max_step,
        max_starts           = max_starts,
        checkGrim            = checkGrim,
        parallel_start       = parallel_start,
        return_best_solution = return_best_solution,
        progress_mode        = "shiny"
      )
      check.args <- fn_args[names(fn_args) %in% names(formals(check_aov_inputs))]
      input.check <- do.call(check_aov_inputs, check.args)
      if (!input.check) {return()}
      # cat(paste(unlist(fn_args), collapse = ", "), "\n")
      lapply(c(  "factor_table", "add_factor", "remove_factor",
                 "subgroup_table",
                 "anova_table", "add_effect", "remove_effect",
                 "main_effects", "inter_effects",
                 "range", "integer", "typeSS",
                 "tolerance", "max_iter", "init_temp",
                 "cooling_rate", "max_step", "max_starts",
                 "parallel_start", "return_best",
                 "run","plot_error","get_rmse","get_rmse_parallel",
                 "plot_summary","plot_rmse","plot_cooling",
                 "display_data","download","dataset_selector"), shinyjs::disable)
      for (tbl in c("factor_table","subgroup_table","anova_table")) {
        shinyjs::runjs(
          sprintf('$("#%s .ht_master").css({"pointer-events":"none","opacity":0.5});',
                  ns(tbl))
        )
      }
      rv$status <- "running"
      withProgress(message = "Running optimization...", value = 0, {
      if (parallel_start > 1) {
        rv$result <- do.call(parallel_aov, fn_args)
        } else {
        seq_args <- fn_args[names(fn_args) %in% names(formals(optim_aov))]
        rv$result <- do.call(optim_aov, seq_args)
        }
      })
      is_parallel <- input$parallel_start > 1 && !input$return_best
      rv$status <- "done"
      rv$dirty <- FALSE
      shinyjs::enable("run")
      for(btn in c( "factor_table", "add_factor", "remove_factor",
                    "subgroup_table",
                    "anova_table", "add_effect", "remove_effect",
                    "main_effects", "inter_effects",
                    "range", "integer", "typeSS",
                    "tolerance", "max_iter", "init_temp",
                    "cooling_rate", "max_step", "max_starts",
                    "parallel_start", "return_best","plot_error",
                    "get_rmse","plot_summary","plot_cooling",
                    "display_data","download")) {
        shinyjs::enable(btn)
      }
      if (is_parallel) {
        shinyjs::enable("get_rmse_parallel")
        shinyjs::enable("plot_rmse")
        updateSelectInput(session, "dataset_selector",
                          choices = seq_len(length(rv$result)), selected = 1)
        shinyjs::enable("dataset_selector")
      } else {
        shinyjs::disable("get_rmse_parallel")
        shinyjs::disable("plot_rmse")
        updateSelectInput(session, "dataset_selector", choices = 1, selected = 1)
        shinyjs::disable("dataset_selector")
      }
      for (tbl in c("factor_table","subgroup_table","anova_table")) {
        shinyjs::runjs(
          sprintf('$("#%s .ht_master").css({"pointer-events":"auto","opacity":1});',
                  ns(tbl))
        )
      }
    })

    output$status_text <- renderText({
      if (rv$dirty) return(NULL)
      if (rv$status == "running") "Optimization is running..." else ""
    })

    output$best_error <- renderTable({
      if (rv$dirty) return(NULL)
      ds <- selected_dataset()
      req(ds)
      bes <- ds$best_error
      is_conv <- (bes == 0) | (bes <= input$tolerance)
      disp <- ifelse(is_conv, "converged", format(bes))
      data.frame(
        ANOVA = disp,
        stringsAsFactors = FALSE,
        check.names = FALSE
      )
    }, rownames = FALSE,
    colnames = FALSE)

    last_action <- reactiveVal(NULL)
    observeEvent(input$plot_error, last_action("plot_error"))
    observeEvent(input$get_rmse,       last_action("get_rmse"))
    observeEvent(input$get_rmse_parallel,  last_action("get_rmse_parallel"))
    observeEvent(input$plot_summary,    last_action("plot_summary"))
    observeEvent(input$plot_rmse,    last_action("plot_rmse"))
    observeEvent(input$plot_cooling,    last_action("plot_cooling"))
    observeEvent(input$display_data,    last_action("display_data"))
    observeEvent(input$download, {
      showModal(modalDialog(
        title = "Download",
        downloadButton(ns("dl_object"), "Full object"),
        downloadButton(ns("dl_data"),   "Data CSV"),
        easyClose = TRUE
      ))
    })

    output$plot_error <- renderPlot({
      if (rv$dirty) return(NULL)
      plot_error(selected_dataset(),
                 first_iter = as.integer(input$iter_select)
      ) })
    output$get_rmse    <- renderPrint({
      if (rv$dirty) return(NULL)
      get_rmse(selected_dataset()) })
    output$get_rmse_parallel <- renderPrint({
      if (rv$dirty) return(NULL)
      get_rmse_parallel(rv$result) })
    output$plot_summary <- renderPlot({
      if (rv$dirty) return(NULL)
      plot_summary(selected_dataset(),
                   standardised = input$std) })
    output$plot_cooling<- renderPlot({
      if (rv$dirty) return(NULL)
      plot_cooling(selected_dataset()) })
    output$plot_rmse   <- renderPlot({
      if (rv$dirty) return(NULL)
      plot_rmse(rv$result) })
    output$display_data <- renderTable({
      if (rv$dirty) return(NULL)
      ds <- selected_dataset()
      if (!is.list(ds)) {
        return(data.frame(Message = "No data available."))
      }
      if (is.null(ds$data)) {
        return(data.frame(Message = "No data available."))
      }
      utils::head(as.data.frame(ds$data), min(nrow(ds$data),15))
    })

    output$main_output <- renderUI({
      if (rv$dirty) return(NULL)
      req(last_action())
      switch(last_action(),
             "plot_error"         = tagList(
               plotOutput(ns("plot_error"), width = "600px", height = "400px"),
               fluidRow(
                 column(
                   width = 6,
                   numericInput(
                     ns("iter_select"),
                     name_with_info(
                       "Start Iteration",
                       "Plot errors beginning at this iteration."
                     ),
                     value = isolate(input$iter_select %||% 1),
                     min   = 1,
                     max   = length(
                       rv$result$track_error[[
                         as.integer(input$run_select %||% 1)
                       ]]
                     ),
                     step  = 100,
                     width = "100px"
                   )
                 )
               )
             ),
             "get_rmse"           = verbatimTextOutput(ns("get_rmse")),
             "get_rmse_parallel"  = verbatimTextOutput(ns("get_rmse_parallel")),
             "plot_summary"       = tagList(
               plotOutput(ns("plot_summary"), width = "600px", height = "400px"),
               fluidRow(
                 column(
                   width = 6,
                   checkboxInput(
                     ns("std"),
                     name_with_info(
                       "Standardized",
                       "Select whether the differences between simulated and target values are standardized."
                     ),
                     TRUE,
                     width = "100%"
                   ),
                 ))),
             "plot_rmse"          = plotOutput(ns("plot_rmse"),   width = "600px", height = "400px"),
             "plot_cooling"       = plotOutput(ns("plot_cooling"),   width = "600px", height = "400px"),
             "display_data"       = tableOutput(ns("display_data"))
      )
    })

    selected_dataset <- reactive({
      if (rv$dirty) return(NULL)
      if (is.list(rv$result) && input$parallel_start > 1 && !input$return_best) {
        rv$result[[as.integer(input$dataset_selector)]]
      } else rv$result
    })

    output$dl_object <- downloadHandler(
      filename = "discourse_object.rds",
      content  = function(file) {
        req(!rv$dirty)
        ds <- selected_dataset()
        saveRDS(ds, file)
        }
    )
    output$dl_data <- downloadHandler(
      filename = "optimized_data.csv",
      content  = function(file) {
        req(!rv$dirty)
        ds <- selected_dataset()
        utils::write.csv(as.data.frame(ds$data), file, row.names = FALSE)}
    )

  })
}
