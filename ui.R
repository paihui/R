
			   
# Define UI for application that draws a histogram
shinyUI(fluidPage(

	# Application title
	titlePanel("Shiny!-文字雲"),

	# Sidebar with a slider input for the number of bins
	sidebarLayout(
		sidebarPanel(
	
							  
			sliderInput("freq",
					  "最小出現頻率:",
					  min = 1,  max = 8, value = 3),
					  
			sliderInput("max",
					  "顯示最大字數:",
					  min = 1,  max = 200,  value = 20)
		),

    # Show a plot of the generated distribution
    mainPanel(
		plotOutput("plot")
    )
	
  )
  
 ))