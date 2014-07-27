library(shiny)
library(TTR)
library(xts)
library(quantmod)
library(forecast)
#Get cuotes of the assets
tickers <- c("^GSPC", "AAPL", "MSFT", "GOOG", "^IBEX")
getSymbols(tickers) 
#Some finance indicators
indtypes <<- c("EMA","MACD","Stochastic","ATR","RSI") 



shinyServer(
  function(input, output) {
    
    # Set the different indicators available
    output$typeIndicators <- renderUI({
      if(1) {
        checkboxGroupInput('indtypes', 'Indicadores :', indtypes, selected=indtypes)
      }
    })
    
    # Tittle of the current plot asset
    output$caption <- renderText({label(input$asset)})
    
    # Generate a plot of the requested variable
    output$myPlot <- renderPlot({
      
      if (input$asset=="sp"){ 
        candleChart(GSPC,subset=paste(paste(input$date[1],sep="","::"),sep="",
                                      input$date[2]),theme="white",up.col='green',
                    dn.col='red',TA = 'addVo()')
        
        
      }
      else if (input$asset =="ib"){
        candleChart(IBEX,subset=paste(paste(input$date[1],sep="","::"),sep="",
                                      input$date[2]),theme="white",up.col='green',
                    dn.col='red',TA = 'addVo()')
       
        
      }
      else if (input$asset =="msft"){
        candleChart(MSFT,subset=paste(paste(input$date[1],sep="","::"),sep="",
                                      input$date[2]),theme="white",up.col='green',
                    dn.col='red',TA = 'addVo()')
        
      }
      else if (input$asset =="goog"){
        candleChart(GOOG,subset=paste(paste(input$date[1],sep="","::"),sep="",
                                      input$date[2]),theme="white",up.col='green',
                    dn.col='red',TA = 'addVo()')
        
      }
      else{
        candleChart(AAPL,subset=paste(paste(input$date[1],sep="","::"),sep="",
                                      input$date[2]),theme="white",up.col='green',
                    dn.col='red',TA = 'addVo()')
        
      }
      myIndicators(input$asset,input$indtypes)
    },height = 1100, width = "auto")
    
    output$prediction <- renderText({(myPredict(input$asset,input$prediction))})
    
  })
 
 # Set the name of the asset for the plot tittle
 label <- function(stock){
   if(stock=="ib"){result <- "IBEX 35 - daily quotes"}
   if(stock=="msft"){result <- "Microsoft - daily quotes"}
   if(stock=="aapl"){result <- "Apple - daily quotes"}
   if(stock=="goog"){result <- "Google - daily quotes"}
   if(stock=="sp"){result <- "S&P 500 - daily quotes"}
   return(result)
 }  

 # Make a prediction based on ARIMA function
 myPredict <- function(stock,pred){
   
   while (pred==TRUE){ 
     if(stock=="ib"){
       cierre <- Cl(IBEX)  
       ts1 <- ts(cierre,frequency = 365)
       ts1_ret <- diff(ts1) / lag(ts1, k = -1) * 100
       mod <- auto.arima(ts1_ret, stationary = TRUE, seasonal = FALSE,ic="aic")
       pred <- predict(mod,n.ahead=1)
     }
     else if(stock=="sp"){
       cierre <- Cl(GSPC) 
       ts1 <- ts(cierre,frequency = 365)
       ts1_ret <- diff(ts1) / lag(ts1, k = -1) * 100
       mod <- auto.arima(ts1_ret, stationary = TRUE, seasonal = FALSE,ic="aic")
       pred <- predict(mod,n.ahead=1)
     }
     if(stock=="msft"){
       cierre <- Cl(MSFT)  
       ts1 <- ts(cierre,frequency = 365)
       ts1_ret <- diff(ts1) / lag(ts1, k = -1) * 100
       mod <- auto.arima(ts1_ret, stationary = TRUE, seasonal = FALSE,ic="aic")
       pred <- predict(mod,n.ahead=1)
     }
     if(stock=="goog"){
       cierre <- Cl(GOOG)
       ts1 <- ts(cierre,frequency = 365)
       ts1_ret <- diff(ts1) / lag(ts1, k = -1) * 100
       mod <- auto.arima(ts1_ret, stationary = TRUE, seasonal = FALSE,ic="aic")
       pred <- predict(mod,n.ahead=1)
     }
     if(stock=="aapl"){
       cierre <- Cl(AAPL)
       ts1 <- ts(cierre,frequency = 365)
       ts1_ret <- diff(ts1) / lag(ts1, k = -1) * 100
       mod <- auto.arima(ts1_ret, stationary = TRUE, seasonal = FALSE,ic="aic")
       pred <- predict(mod,n.ahead=1)
     }
     
     if (as.numeric(pred[1]) > 0){result <- "BUY"}
     else if(as.numeric(pred[1]) < 0){result <- "SELL"}
     else {result <- "HOLD"}
     return(result)
     break
   }
   
   
 }
 
 # Plot the selected indicators
 myIndicators <- function(stock,indi){
   while(stock=="sp"){
     if ("EMA" %in% indi){plot(addTA(EMA(Cl(GSPC)), on=1, col=6))}
     if ("RSI" %in% indi){plot(addTA(RSI(Cl(GSPC))))}
     if ("ATR" %in% indi){plot(addTA(ATR(HLC(GSPC))))}
     if ("MACD" %in% indi){plot(addTA(MACD(Cl(GSPC))))}
     if ("Stochastic" %in% indi){plot(addTA(stoch(HLC(GSPC))))}
     break
   }
   while(stock=="msft"){
     if ("EMA" %in% indi){plot(addTA(EMA(Cl(MSFT)), on=1, col=6))}
     if ("RSI" %in% indi){plot(addTA(RSI(Cl(MSFT))))}
     if ("ATR" %in% indi){plot(addTA(ATR(HLC(MSFT))))}
     if ("MACD" %in% indi){plot(addTA(MACD(Cl(MSFT))))}
     if ("Stochastic" %in% indi){plot(addTA(stoch(HLC(MSFT))))}
     break
   }
   while(stock=="goog"){
     if ("EMA" %in% indi){plot(addTA(EMA(Cl(GOOG)), on=1, col=6))}
     if ("RSI" %in% indi){plot(addTA(RSI(Cl(GOOG))))}
     if ("ATR" %in% indi){plot(addTA(ATR(HLC(GOOG))))}
     if ("MACD" %in% indi){plot(addTA(MACD(Cl(GOOG))))}
     if ("Stochastic" %in% indi){plot(addTA(stoch(HLC(GOOG))))}
     break
   }
   while(stock=="aapl"){
     if ("EMA" %in% indi){plot(addTA(EMA(Cl(AAPL)), on=1, col=6))}
     if ("RSI" %in% indi){plot(addTA(RSI(Cl(AAPL))))}
     if ("ATR" %in% indi){plot(addTA(ATR(HLC(AAPL))))}
     if ("MACD" %in% indi){plot(addTA(MACD(Cl(AAPL))))}
     if ("Stochastic" %in% indi){plot(addTA(stoch(HLC(AAPL))))}
     break
   }
   while(stock=="ib"){
     if ("EMA" %in% indi){plot(addTA(EMA(Cl(IBEX)), on=1, col=6))}
     if ("RSI" %in% indi){plot(addTA(RSI(Cl(IBEX))))}
     if ("ATR" %in% indi){plot(addTA(ATR(HLC(IBEX))))}
     if ("MACD" %in% indi){plot(addTA(MACD(Cl(IBEX))))}
     if ("Stochastic" %in% indi){plot(addTA(stoch(HLC(IBEX))))}
     break
   }
 }

 
  
