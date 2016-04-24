library(shiny)
library(RSQLite)
library(tm)
library(stringi)
library(stringr)

shinyServer(function(input, output) { 
  db <- dbConnect(SQLite(), dbname="predict.db")
  dbout <- reactive({predict_with_ngram_backoff(input$text, db)})
  output$predicted <- renderText({out <- dbout()})
  output$alts <- renderTable({dbout()})
  
  predict_with_ngram_backoff <- function(raw, db) {    
    max = 3
    gstring <- tolower(raw)
    gstring <- gsub("[[:punct:]]", "", gstring)
    gstring <- gsub("\\s+"," ",gstring)
    gstring <- gsub('[[:digit:]]+', '', gstring)
    gstring <- gsub(" $", "", gstring)
    gstring <- str_split(gstring, " ")
    sentence <- unlist(gstring)
    
    for (i in min(length(sentence), max):1) {
      gram <- paste(tail(sentence, i), collapse=" ")
      sql <- paste("SELECT word, freq FROM NGram WHERE ", 
                   " pre=='", paste(gram), "'",
                   " AND n==", i + 1, " LIMIT 10", sep="")
      res <- dbSendQuery(conn=db, sql)
      words <- dbFetch(res, n=-1)
      names(words) <- c("Next Possible Word", "Frequency")
      if (nrow(words) > 0) return(words)
    }
  }
  
})