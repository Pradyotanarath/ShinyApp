## Required libraries installation

if (!require(shiny)){install.packages("shiny")}
if (!require(udpipe)){install.packages("udpipe")}
if (!require(textrank)){install.packages("textrank")}
if (!require(lattice)){install.packages("lattice")}
if (!require(igraph)){install.packages("igraph")}
if (!require(ggraph)){install.packages("ggraph")}
if (!require(wordcloud)){install.packages("wordcloud")}
if (!require(stringr)){install.packages("stringr")}
if (!require(readr)){install.packages("readr")}
if (!require(rvest)){install.packages("rvest")}
library(shiny)
library(udpipe)
library(textrank)
library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(wordcloud)
library(stringr)
library(readr)
library(rvest)


ui <- shinyUI(
  fluidPage(

## Title of the page
    titlePanel("Shiny App Project"),

## Side pane    
    sidebarLayout( 
      
      sidebarPanel(  
        
        fileInput("file", "Upload file"),
        
        
        checkboxGroupInput(inputId = 'upos',
                           label = h3('Select Part of speech (Unselect the ones not needed)'),
                           choices =list("Adjective"= "ADJ",
                                         "Noun" = "NOUN",
                                         "Proper noun" = "PROPN",
                                         "Adverb"="ADV",
                                         "Verb"= "VERB"),
                           selected = c("ADJ","NOUN","PROPN","ADV","VERB"))
        
      ),
## Mainpane design      
      mainPanel(
        
        tabsetPanel(type = "tabs",
                    
                    tabPanel("Overview",
                             h4(p("Data input")),
                             br(),
                             p('This App has been developed for ISB,', 
                               span(strong("Text Analytics")),
                               'subject as a project submission. ')),
                    tabPanel("Annotated data", 
                             dataTableOutput('datatableOutput'),
                             downloadButton("downloadData", "Download Annotated values")),
 
## Below plots have been retrieved from the server.r file                   
                    tabPanel("Word Clouds",
                             h3("Nouns"),
                             plotOutput('wcplot1'),
                             h3("Verbs"),
                             plotOutput('wcplot2'),
                             h3("Adjectives"),
                             plotOutput('wcplot3'),
                             h3("Proper Noun"),
                             plotOutput("wcplot4"),
                             h3("Adverb"),
                             plotOutput("wcplot5")
                             ),
        
                    
                    
                    tabPanel("Co-occurrences",
                             h3("Co-occurrences"),
                             plotOutput('coocplot3'))
                    
        ) 
      )
    ) 
  )  
) 
