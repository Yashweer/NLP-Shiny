
shinyServer(function(input, output) {
  
  Dataset <- reactive({
    if (is.null(input$file1)) { return(NULL) }
    else{
      text1 <- readLines(input$file1$datapath)
      text1 = str_replace_all(text1,"<.*?>", "")
      text1 = text1[text1 != ""] 
      return(text1)
    }
  })
  
  model_english = reactive({
    
    model_english = udpipe_load_model("english-ud-2.0-170801.udpipe")
    return(model_english)
  })
  
  
  annot.obj = reactive({
    
    x <- udpipe_annotate(model_english(),x = Dataset())
    x <- as.data.frame(x)
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      "annotate_data.csv"
    },
    content = function(file){
      write.csv(annot.obj()[,-4],file,row.names = FALSE)
    
    }
  )
  
  output$dout1 = renderDataTable({
    if (is.null(input$file1)) {return(NULL)}
    else {
      out = annot.obj()[,-4]
      return(out)
    }
  })
  
  output$plot1 = renderPlot({
    if (is.null(input$file1)) {return(NULL)}
    else {
      all_nouns = annot.obj() %>% subset(., upos %in% "NOUN")
      top_nouns = txt_freq(all_nouns$lemma)
      
      wordcloud(top_nouns$key,top_nouns$freq,min.frq = 3, colors = 1:10)
    }
  })
 
  output$plot2 = renderPlot({
    if (is.null(input$file1)) {return(NULL)}
    else {
      all_verbs = annot.obj() %>% subset(., upos %in% "VERB")
      top_verbs = txt_freq(all_verbs$lemma)
      
      wordcloud(top_verbs$key,top_verbs$freq,min.frq = 3, colors = 1:10)
    }
  })
  
  output$plot3 = renderPlot({
    if (is.null(input$file1)) {return(NULL)}
    else {
      nlp_cooc <- cooccurrence( 	# try `?cooccurrence` for parm options
        x = subset(annot.obj(), upos %in% input$checkGroup),
        term = "lemma", 
        group = c("doc_id", "paragraph_id", "sentence_id"))
      
      wordnetwork <- head(nlp_cooc, 50)
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
      
      ggraph(wordnetwork, layout = "fr") +  
        
        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
        geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
        
        theme_graph(base_family = "Arial Narrow") +  
        theme(legend.position = "none") +
        
        labs(title = "Cooccurrences within 3 words distance", subtitle = "Nouns & Adjective")
    }
  })

  })
  
  