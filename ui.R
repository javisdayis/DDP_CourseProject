library(shiny)
shinyUI(pageWithSidebar(
  # Application title
  headerPanel("Magic Trade"),
  # Sidebar with controls to select the asset to plot
  sidebarPanel(
    sliderInput('date', 'Data frame:', min = 2010, max = 2014, value = c(2010, 2014),
                format="####",step = 1,round=FALSE,ticks=TRUE),
    selectInput('asset', 'Asset:',
                list("S&P 500" = "sp",
                     "Microsoft" = "msft",
                     "Apple" = "aapl",
                     "Google" = "goog",
                     "IBEX35" = "ib"),'ib'),
   
    uiOutput("typeIndicators"),
    h4('Expert Advisor'),
    checkboxInput("prediction","Make a prediction for tomorrow ?"),
    h1(textOutput("prediction"))
    
    
  ),
  mainPanel(
    h3(textOutput("caption")),
    plotOutput("myPlot",width="100%"))
   
))

