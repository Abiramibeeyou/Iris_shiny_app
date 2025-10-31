# app.R
library(shiny)
library(shinydashboard)
library(plotly)
library(DT)
library(DBI)
library(RSQLite)
library(dplyr)
library(ggplot2)


db_file <- "iris_db.sqlite"
con <- dbConnect(SQLite(), db_file)
if (!dbExistsTable(con, "iris_data")) {
  dbWriteTable(con, "iris_data", iris)
}
dbDisconnect(con)


ui <- dashboardPage(
  dashboardHeader(title = "Iris Analytics Dashboard 🌸"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Data Manager", tabName = "data", icon = icon("table")),
      menuItem("Visual Analytics", tabName = "viz", icon = icon("chart-line")),
      menuItem("Species Comparison", tabName = "species", icon = icon("seedling")),
      menuItem("Insights & Summary", tabName = "summary", icon = icon("lightbulb"))
    )
  ),
  
  dashboardBody(
    tabItems(
      # Data & Crud Operations
      tabItem(tabName = "data",
              fluidRow(
                box(title = "Add / Update Record", width = 4, solidHeader = TRUE, status = "primary",
                    textInput("sepal_length", "Sepal Length"),
                    textInput("sepal_width", "Sepal Width"),
                    textInput("petal_length", "Petal Length"),
                    textInput("petal_width", "Petal Width"),
                    selectInput("species", "Species", choices = unique(iris$Species)),
                    actionButton("add", "Add Record", class = "btn-success"),
                    actionButton("update", "Update Selected", class = "btn-warning"),
                    actionButton("delete", "Delete Selected", class = "btn-danger")
                ),
                box(title = "Iris Data Table", width = 8,
                    DTOutput("table"))
              )
      ),
      
      # Visualisations
      tabItem(tabName = "viz",
              fluidRow(
                box(title = "Sepal vs Petal Scatter", width = 6, plotlyOutput("scatter_plot")),
                box(title = "Sepal Width Distribution", width = 6, plotlyOutput("hist_plot"))
              ),
              fluidRow(
                box(title = "Correlation Heatmap", width = 12, plotlyOutput("heatmap"))
              )
      ),
      
      # Species Comaprison
      tabItem(tabName = "species",
              fluidRow(
                box(title = "Average Measurements per Species", width = 6, plotlyOutput("bar_plot")),
                box(title = "Boxplot by Species", width = 6, plotlyOutput("box_plot"))
              )
      ),
      
      # Summary Statistics
      tabItem(tabName = "summary",
              fluidRow(
                box(title = "Statistical Summary", width = 6, verbatimTextOutput("summary_text")),
                box(title = "Key Insights", width = 6,
                    h4("🔍 Observations:"),
                    tags$ul(
                      tags$li("Setosa species has the smallest petals and sepals."),
                      tags$li("Virginica species shows largest measurements overall."),
                      tags$li("Petal dimensions show strong positive correlation."),
                      tags$li("Sepal width has weaker correlation with others.")
                    )
                )
              )
      )
    )
  )
)

# Server
server <- function(input, output, session) {
  con <- dbConnect(SQLite(), "iris_db.sqlite")
  data <- reactiveVal(dbReadTable(con, "iris_data"))
  
  # Refresh Data
  refreshData <- function() {
    data(dbReadTable(con, "iris_data"))
  }
  
  # CRUD Operations
  observeEvent(input$add, {
    new_row <- data.frame(
      Sepal.Length = as.numeric(input$sepal_length),
      Sepal.Width = as.numeric(input$sepal_width),
      Petal.Length = as.numeric(input$petal_length),
      Petal.Width = as.numeric(input$petal_width),
      Species = input$species
    )
    dbWriteTable(con, "iris_data", new_row, append = TRUE)
    refreshData()
  })
  
  output$table <- renderDT({
    datatable(data(), selection = "single")
  })
  
  observeEvent(input$update, {
    selected <- input$table_rows_selected
    if (length(selected)) {
      all_data <- data()
      all_data[selected, ] <- list(
        Sepal.Length = as.numeric(input$sepal_length),
        Sepal.Width = as.numeric(input$sepal_width),
        Petal.Length = as.numeric(input$petal_length),
        Petal.Width = as.numeric(input$petal_width),
        Species = input$species
      )
      dbWriteTable(con, "iris_data", all_data, overwrite = TRUE)
      refreshData()
    }
  })
  
  observeEvent(input$delete, {
    selected <- input$table_rows_selected
    if (length(selected)) {
      all_data <- data()
      all_data <- all_data[-selected, ]
      dbWriteTable(con, "iris_data", all_data, overwrite = TRUE)
      refreshData()
    }
  })
  
  # visualisations
  output$scatter_plot <- renderPlotly({
    plot_ly(data(), x = ~Sepal.Length, y = ~Petal.Length,
            color = ~Species, type = "scatter", mode = "markers")
  })
  
  output$hist_plot <- renderPlotly({
    plot_ly(data(), x = ~Sepal.Width, type = "histogram", color = ~Species)
  })
  
  output$heatmap <- renderPlotly({
    df <- data()[,1:4]
    corr <- round(cor(df), 2)
    plot_ly(z = corr, x = names(df), y = names(df),
            type = "heatmap", colorscale = "Viridis")
  })
  
  output$bar_plot <- renderPlotly({
    avg <- data() %>%
      group_by(Species) %>%
      summarise(across(where(is.numeric), mean))
    
    plot_ly(avg, x = ~Species, y = ~Sepal.Length, type = "bar", name = "Sepal Length") %>%
      add_trace(y = ~Petal.Length, name = "Petal Length") %>%
      layout(barmode = "group")
  })
  
  output$box_plot <- renderPlotly({
    plot_ly(data(), x = ~Species, y = ~Petal.Length, color = ~Species, type = "box")
  })
  
  output$summary_text <- renderPrint({
    summary(data())
  })
  
  session$onSessionEnded(function() {
    dbDisconnect(con)
  })
}

shinyApp(ui, server)
