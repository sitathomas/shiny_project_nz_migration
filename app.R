# UI ####
ui <-
    dashboardPage(
        dashboardHeader(),
        dashboardSidebar(
            sidebarUserPanel("Sita Thomas", image = "sita.jpg"),
            sidebarMenu(
                menuItem("Occupation Data", tabName = "occupations", icon = icon("briefcase")),
                menuItem("Visa Data", tabName = "visa", icon = icon("passport"))
            )
        ),
        dashboardBody(
            tabItems(
                tabItem(tabName = "occupations",
                    plotOutput("occup_by_year"),
                    plotOutput("arrivals_by_occup")
                ),
                tabItem(tabName = "visa",
                    plotOutput("gender_by_visa")
                )
            )
        )
    )


# SERVER ####
server <-
    shinyServer(function(input, output) {
        output$occup_by_year <- renderPlot(
            occup_by_year %>%
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
        output$arrivals_by_occup <- renderPlot(
            occup_by_year %>%
            	pivot_longer(.,
            		cols = managers:labourers,
            		names_to = "occupation",
            		values_to = "occupation_count"
            	) %>%
            	group_by(., occupation) %>%
            	summarise(., occupation_sum = sum(occupation_count)) %>%
            	ggplot(data = ., aes(y = occupation, x = occupation_sum)) +
            		geom_col(fill = "sienna3") +
            		labs(
            			title = "Net Permanent and Long-Term Migration to New Zealand by Occupation",
            			subtitle = "ANZSCO Major Occupations, 2010 - 2017",
            			y = "Occupation", x = "Arrivals"
            			) +
            		theme_few() +
            		scale_y_discrete(
            			labels = c(
            				"technicians__trades_workers" = "Technicians and Trades Workers",
            				"sales_workers" = "Sales Workers",
            				"professionals" = "Professionals",
            				"managers" = "Managers",
            				"machinery_operators__drivers" = "Machinery Operators and Drivers",
            				"labourers" = "Laborers",
            				"community__personal_service_workers" = "Community and Personal Service Workers",
            				"clerical__administrative_workers" = "Clerical and Administrative Workers"
            			)
            		)
        )
        output$gender_by_visa <- renderPlot(
            by_visa_gender %>%
            	group_by(., gender, visa_type) %>%
            	summarise(., arrivals = sum(arrivals)) %>%
            	ggplot(data = ., aes(x = arrivals, y = visa_type, fill = gender)) +
            		geom_col(position = "dodge") +
            		labs(
            			title = "Net Permanent and Long-Term Migration to New Zealand by Gender and Visa Type",
            			subtitle = "2010 - 2017",
            			x = "Arrivals", y = "Type of Visa",
            			fill = "Gender"
            		) +
            		scale_x_continuous(labels = comma) +
            		scale_fill_brewer(palette = "Dark2")+
            		theme_few()
        )
        # output$ <- renderPlot(
        #
        # ),
        # output$ <- renderPlot(
        #
        # ),
        # output$ <- renderPlot(
        #
        # ),
        # output$ <- renderPlot(
        #
        # ),

    })

shinyApp(ui, server)
