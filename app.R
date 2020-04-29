# GLOBAL ####
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(scales)
library(shiny)
library(shinydashboard)
library(DT)

# UI ####
ui <-
    shinyUI(
        dashboardPage(
            dashboardHeader(title = "Exploring Migration to New Zealand"),
            dashboardSidebar(
                sidebarUserPanel("Sita Thomas", image = "sita.jpg"),
                sidebarMenu(
                    menuItem("By Occupation", tabName = "By Occupation", icon = icon("briefcase")),
                    menuItem("By Visa Type", tabName = "By Visa Type", icon = icon("passport"))
                )
            ),
            dashboardBody(
                tabItems(
                    tabItem(tabName = "By Occupation", "stuff"),
                    tabItem(tabName = "By Visa Type", "things")
                )
            )
        )
    )


# SERVER ####
server <-
    shinyServer(function(input, output) {
        output$major_occup <- renderPlot(
            major_occup %>%
                group_by(year) %>%
                summarise(., total = sum(total_occupations)) %>%
                ggplot(., aes(x = year, y = total)) +
                geom_col(fill = "sienna3") +
                labs(
                    title = "Net Permanent and Long-Term Migration to New Zealand by Year",
                    subtitle = "ANZSCO Major Occupations, 2010 - 2017",
                    x = "Year",
                    y = "All Major ANZSCO Occupations"
                ) +
                theme_few()
        )
    })

shinyApp(ui, server)
