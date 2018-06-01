#---------------------------------------------------------------------#
#                 Shiny UI NLP Text Analytics                         #
#---------------------------------------------------------------------#


library("shiny")

shinyUI(
  fluidPage(
  
    titlePanel("Shiny App for NLP"),
  
  sidebarLayout(
    
    sidebarPanel(
      h3("Input for the App"),
      br(),
      
    fileInput("file1", label = h3("File input")),
      
    br(),
    checkboxGroupInput("checkGroup", 
                       label = h3("Co-occurence Group"), 
                       choices = list("Adjective" = "ADJ", 
                                      "Noun" = "NOUN", 
                                      "Proper Noun" = "PROPN",
                                      "Adverb" = "ADV",
                                      "Verb" = "VERB"),
                       selected = c("ADJ","NOUN","PROPN"))
   # br(),
   # textInput("text", label = h3("Text input"), 
    #        value = "Enter text...")
    
      ),   # end of sidebar panel
    
    
    mainPanel(
      tabsetPanel(type = "tabs",
                  
                  tabPanel("Overview",
                           h4(p("Data input")),
                           p("This app only supports text data file, kindly upload the text file for expected results.",align="justify"),
                           br(),
                           h4('How to use this App'),
                           p('To use this app, click on', 
                             span(strong("Upload data (text file)")),
                             'and uppload the data file. This App uses udpipe package for NLP workflow. This app is going to generate
                              three tabs, one with annotation, another with wordclod and third will prepare co-occurence graph')),
                 
                   tabPanel("Annotated Documents", 
                           dataTableOutput('dout1'),
                           downloadButton("downloadData","Annotated Data Download")),
                  
                  tabPanel("Word Clouds",
                           h3("Noun"),
                           plotOutput("plot1"),
                           h3("Verbs"),
                           plotOutput("plot2")),
                           
                  
                  tabPanel("Co-occurences",
                           plotOutput('plot3'))
                  
      ) # end of tabsetPanel
    )# end of main panel
  ) # end of sidebarLayout
  )  # end if fluidPage
) # end of UI
  


