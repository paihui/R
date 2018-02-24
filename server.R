

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot

  output$plot <- renderPlot({
	#windowsFonts(myFont=windowsFont("华文彩云"))
	#wordcloud(tableWord[,1],tableWord[,2],random.order=F,col= rainbow(length(wordFreq)),family="myFont")##参数应该能看懂吧

	wordcloud(words = df$word, freq = df$freq,  min.freq = input$freq,max.words=input$max, random.order = F, ordered.colors = F,colors = rainbow(length(row.names(m1))))

  })
})
