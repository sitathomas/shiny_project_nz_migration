library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)
library(readr)
library(scales)
library(ggthemes)

arrivals_by_area <- read_csv("data/arrivals_by_area.csv", col_names = T, skip = 4)
arrivals_by_area <- arrivals_by_area[-(9:49),]
colnames(arrivals_by_area)[1] = "year"
colnames(arrivals_by_area) <- gsub("region", "Region", colnames(arrivals_by_area))
arrivals_by_area <- arrivals_by_area %>%
	pivot_longer(., 2:17, names_to = "area", values_to = "arrivals") %>%
	group_by(., year, area) %>%
	summarise(., arrivals = sum(arrivals))

subtitle <- "Net Permanent and Long-Term Migration to New Zealand, 2010 - 2017"
x_commas <- scale_x_continuous(labels = comma)

# UI ####
ui <-
  fluidPage(
    titlePanel("Test"),
    sidebarLayout(
      sidebarPanel(
        selectizeInput(inputId = "year",
                       label = "Year",
                       choices = unique(arrivals_by_area$year)),
      ),
      mainPanel(
        tabsetPanel(
          tabPanel("Graphs",
                   fluidRow(
                   	 plotOutput("area_plot"),
                   )
          )
        )
      )
    )
  )

# SERVER ####
server <-
  function(input, output, session) {
	  by_area <- reactive(
	      arrivals_by_area %>%
	          filter(., year == input$year) %>%
						group_by(., year, area) %>%
  					summarise(., arrivals = sum(arrivals))
	  )
  	output$area_plot <- renderPlot(
  		by_area() %>%
				ggplot(data = ., aes(x = arrivals, y = area)) +
				geom_col(fill = "#d95f02") +
				labs(
					title = "Arrivals by NZ Area",
					subtitle = subtitle,
					x = "Arrivals", y = "Region",
					fill = "Area"
				) +
				x_commas +
				theme_few()
  	)
}

shinyApp(ui, server)