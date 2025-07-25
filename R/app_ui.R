#' The application User-Interface
#' tools::showNonASCIIfile("R/app_ui.R")
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # External resources
    golem_add_external_resources(),

    fluidPage(
      lang = "en",
      navbarPage(
        title = tags$img(
          src    = "www/logo.png",
          alt    = "DISCOURSE",
          height = "30px",
          style  = "margin-top:-5px;"
        ),
        id = "main",
        windowTitle = "DISCOURSE",

        # Home
        tabPanel(
          title = "Home",
          fluidRow(
            column(width = 12,
                   h1("Welcome to the DISCOURSE App"),
                   p(HTML(
                     "I introduce the DISCOURSE framework - <strong>D</strong>ata-simulation via <strong>I</strong>terative <strong>S</strong>tochastic <strong>C</strong>ombinatorial <strong>O</strong>ptimization <strong>U</strong>sing <strong>R</strong>eported <strong>S</strong>ummary <strong>E</strong>stimates. This algorithmic framework reconstructs complete datasets using only summary statistics, giving researchers a way - when raw data are unavailable - to inform replication-study decision-making."
                   )),
                   h3("Purpose and Scope"),
                   p("The primary objective of DISCOURSE is to simulate an entire data set based solely on the available summary statistics."),
                   tags$ul(
                     tags$li(strong("Iterative:"), " The algorithm employs a cyclical process that continuously refines the simulated data."),
                     tags$li(strong("Stochastic:"), " The method incorporates random sampling techniques to explore the data space effectively."),
                     tags$li(strong("Combinatorial:"), " By transforming a high dimensional infinite search space into a finite optimization problem, DISCOURSE efficiently navigates potential data arrangements.")
                   ),
                   h3("Modular Structure"),
                   p("The DISCOURSE framework is composed of four interchangeable optimization modules tailored to different data structures and statistical models, each following a similar high-level workflow. Modules are organized by data dimensionality: in the univariate setting, iterative adjustments apply to a single vector, while in the multivariate context, moves operate on an entire matrix of multiple variables. An overview is presented in Table 1 below. These modules can operate independently or sequentially, depending on the specific requirements of the optimization context."),
                   div(
                     class = "table-responsive",
                     style = "max-width:800px; margin-left:0; margin-right:auto;",
                     tags$table(
                       class = "table table-bordered text-center",
                       tags$caption(
                         tags$b("Table 1."), " ",
                         tags$em("Modules and their corresponding functions in the R package"),
                         style = "caption-side: top; text-align: left; color: black;"
                       ),
                       tags$thead(
                         tags$tr(
                           tags$th(tags$em("Data Structure"), colspan = 2, style = "text-align:center; color:black;" )
                         ),
                         tags$tr(
                           tags$th("Univariate", style = "text-align:center; color:black;"),
                           tags$th("Multivariate", style = "text-align:center; color:black;")
                         )
                       ),
                       tags$tbody(
                         tags$tr(
                           tags$td(HTML("Descriptives (<code>optim_vec()</code>)")),
                           tags$td(HTML("Linear Regression (<code>optim_lm()</code>)")),
                         ),
                         tags$tr(
                           tags$td(HTML("ANOVA (<code>optim_aov()</code>)")),
                           tags$td(HTML("LME (<code>optim_lme()</code>)"))
                         )
                       )
                     )
                   ),
                   br(),
                   tags$a(
                     href   = "https://example.com/research_article.pdf",
                     target = "_blank",
                     class  = "btn btn-primary",
                     "Research Article"
                   )
            )
          )
        ),
        # High Level Workflow
        tabPanel(
          title = "High Level Workflow",
          fluidRow(
            column(width = 6,
                   h2("High Level Workflow"),
                   p("The process begins with the candidate initialization, thus, the creation of an initial simulated vector or matrix. The algorithm then iteratively refines the candidate by optimizing an objective function that quantifies the discrepancy between the summary statistics of the candidate and the reported targets. At each iteration the following two steps are performed."),
                   h5("Candidate Modification"),
                   p("Modifications to the data are produced through different types of moves (e.g. global and local; heuristic and stochastic) within the search space."),
                   h5("Candidate Evaluation"),
                   p("Each candidate is evaluated by an objective function and accepted based on a stochastic optimization criterion, ensuring that modifications progressively reduce the objective value."),
                   h4("Convergence"),
                   p("The algorithm is deemed to have met the convergence criteria as soon as the best objective function score f_best falls below the user-specified tolerance. If convergence is not reached after Max Iteration steps, the algorithm restarts (up to Max Starts times) from the candidate with f_best. Only when all allowed iterations and restarts have been exhausted without achieving the tolerance does the routine stop due to iteration limits rather than error criteria.
")
            ),
            column(width = 6,
                   tags$img(
                     src   = "www/workflow.png",
                     alt   = "High Level Workflow",
                     class = "img-responsive center-block",
                     style = "border:1px solid #ddd; padding:4px; border-radius:4px; max-height:80vh;"
                   )
            )
          )
        ),
        # Modules Dropdown
        navbarMenu(
          title = "Modules",
          tabPanel(title = "Descriptives", mod_optim_vec_ui("optim_vec")),
          tabPanel(title = "ANOVA", mod_optim_aov_ui("optim_aov")),
          tabPanel(title = "Linear Regression", mod_optim_lm_ui("optim_lm")),
          tabPanel(title = "Mixed-Effect Linear Regression", mod_optim_lme_ui("optim_lme"))
        ),
        # About
        tabPanel("About",
                includeMarkdown(app_sys("app/www/about.md"))
        )
      )
    )
  )
}



#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "DISCOURSE"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
