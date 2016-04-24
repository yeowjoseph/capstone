library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Simple N-Gram Next Word Predictor"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      textInput("text", label = h3("Text Input"), value = "Good Morning"),
      helpText("Type a pharse in the input box, press the submit button and the top predictions based on frequency will be displayed."),
      submitButton("submit"),
      hr()
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("App",
          h2("Top Predictions base on Frequency", align="center"),
          div(tableOutput("alts"), align="center")
        ),
        tabPanel("Algorithm",
          h2("NGram model (Simple Backoff)"),
          p("Prediction algorithm works by matching the input text with the highest (NGram). If no match is found, the input text is match with the next highest (NGram) and so forth.")
        )
      )
    )
  )
  ))