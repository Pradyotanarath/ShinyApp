require(stringr)

shinyServer(function(input, output) {
  
  Dataset <- reactive({
    
    if (is.null(input$file)) {
      return(NULL) } 
    else{
      Data <- readLines(input$file$datapath)
      Data  =  str_replace_all(Data, "<.*?>", "") # tag removal with blanks
      Data = Data[Data!= ""]
      str(Data)
      return(Data)
    }
  })
  
  model = reactive({
     
    model = udpipe_load_model("english-ud-2.0-170801.udpipe")  
    return(model)
  })
  
  annot.obj = reactive({
    x <- udpipe_annotate(model(),x = Dataset())
    x <- as.data.frame(x)
    return(x)
  })
  
  output$downloadData <- downloadHandler(
    filename = function(){
      "annotated_data.csv"
    },
    content = function(file){
      write.csv(annot.obj()[,-4],file,row.names = FALSE)
    }
  )
  
  output$datatableOutput = renderDataTable({
    if(is.null(input$file)){return(NULL)}
    else{
      out = annot.obj()[,-4]
      return(out)
    }
  })
  
  output$wcplot1 = renderPlot({
    if(is.null(input$file)){return(NULL)}
    else{
      all_nouns = annot.obj() %>% subset(., upos %in% "NOUN") 
      top_nouns = txt_freq(all_nouns$lemma)   
      
      wordcloud(top_nouns$key,top_nouns$freq, min.freq = 4,colors = 1:10 )
    }
  })
  
  output$wcplot2 = renderPlot({
    if(is.null(input$file)){return(NULL)}
    else{
      all_verbs = annot.obj() %>% subset(., upos %in% "VERB") 
      top_verbs = txt_freq(all_verbs$lemma)
      
      wordcloud(top_verbs$key,top_verbs$freq, min.freq = 4,colors = 1:10 )
    }
  })
  
  output$wcplot3 = renderPlot({
    if(is.null(input$file)){return(NULL)}
    else{
      all_adj = annot.obj() %>% subset(., upos %in% "ADJ") 
      top_adj = txt_freq(all_adj$lemma)
      
      wordcloud(top_adj$key,top_adj$freq, min.freq = 4,colors = 1:10 )
    }
  })
  
  output$wcplot4 = renderPlot({
    if(is.null(input$file)){return(NULL)}
    else{
      all_propn = annot.obj() %>% subset(., upos %in% "PROPN") 
      top_propn = txt_freq(all_propn$lemma)
      
      wordcloud(top_propn$key,top_propn$freq, min.freq = 4,colors = 1:10 )
    }
  })
  
  output$wcplot5 = renderPlot({
    if(is.null(input$file)){return(NULL)}
    else{
      all_adv = annot.obj() %>% subset(., upos %in% "ADV") 
      top_adv = txt_freq(all_adv$lemma)
      
      wordcloud(top_adv$key,top_adv$freq, min.freq = 4,colors = 1:10 )
    }
  })
  
  output$coocplot3 = renderPlot({
    if(is.null(input$file)){return(NULL)}
    else{
      nokia_cooc <- cooccurrence(   	 
        x = subset(annot.obj(), upos %in% input$upos), 
        term = "lemma", 
        group = c("doc_id", "paragraph_id", "sentence_id"))
      
      wordnetwork <- head(nokia_cooc, 50)
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork)  
      
      ggraph(wordnetwork, layout = "fr") +  
        
        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
        geom_node_text(aes(label = name), col = "darkgreen", size = 6) +
        
        theme_graph(base_family = "Arial Narrow") +  
        theme(legend.position = "none") +
        
        labs(title = "Co-occurrences within 4 words distance", subtitle = "Select the check boxes on the left to change view")
    }
  })
})