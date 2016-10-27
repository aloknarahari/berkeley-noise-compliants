library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Noise Citations in Berkeley"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("maptype", "Select Map Type", 
                  c("Heat Map" , "Points Map") , selected = "Heat Map"),
      checkboxInput(inputId = "drinks" , label = "Add Underage Drinking Citation Locations")
      
    ),
      
    # Show a plot of the generated distribution
    mainPanel(
      conditionalPanel(
        condition = "input.maptype == 'Heat Map'", plotOutput("plot1", height = "600px")),
      conditionalPanel(
        condition = "input.maptype == 'Points Map'" , plotOutput("plot2" , height = "600px"))
      )
    )
  )
)