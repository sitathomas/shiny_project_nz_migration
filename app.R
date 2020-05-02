# UI ####
ui <-
    dashboardPage(
        skin = "green",
        dashboardHeader(title = "Exploring Migration to New Zealand", titleWidth = "100%"),
        dashboardSidebar(
            sidebarUserPanel(name = "Sita Thomas", image = "sita.jpg"),
            sidebarMenu(
                menuItem("Location and Visa Data", tabName = "location", icon = icon("compass")),
                menuItem("Occupation Data", tabName = "occupations", icon = icon("briefcase")),
                menuItem("Gender Data", tabName = "visa", icon = icon("users")),
                menuItem("Citizenship Data", tabName = "citizenship", icon = icon("passport"))
            )
        ),
        dashboardBody(
            tabItems(
                tabItem(tabName = "location",
                    p("Here you can explore some of the data available for Permanent and Long-Term
                        Migration to New Zealand from 2010-2017. The raw data can be found at
                        http://archive.stats.govt.nz/infoshare/ under the headings
                        Subject Categories > Tourism > International Travel and Migration"),
                    leafletOutput("nz_regions"),

                    p("The vast majority of migrants land in the Auckland area, followed by Canturbury
                        and Wellington. The distribution fluctuates very little year to year."),
                    plotOutput("arrivals_by_area"),

                    p("Citizens returning to the country or moving from Australia make up the majority
                        of arrivals, followed by migrants with work visas."),
                    plotOutput("arrivals_by_visa")
                ),
                tabItem(tabName = "occupations",
                    p("Permanent and long-term migration to New Zealand for workers in the ANZSCO
                        Major Occupation groups has increased more than threefold since 2010 despite
                        negative net arrivals in 2011 and 2012, indicating potentially good prospects
                        for migrants on a work visa."),
                    plotOutput("workers_by_year"),
                    p("However, most permanent and long-term migrants are Professionals by far, while
                        more Sales Workers and Machinery Operators and Drivers have departed New Zealand
                        than have arrived. Therefore the type of occupation may be an important factor
                        for someone considering moving to New Zealand on a work visa."),
                    plotOutput("workers_by_occup")
                ),
                tabItem(tabName = "visa",
                    p("Slightly more men tend to migrate on average, which could be due to a variety of
                        factors, such as more opportunities in male-dominated fields, greater mobility
                        for men, and/or greater desire or self-efficacy to migrate on the part of men."),
                    plotOutput("arrivals_by_gender"),
                    p("More men than women migrate as students and for work, which is likely due to the
                        same variety of factors that includes those listed above. More women tend to
                        migrate for residency and to visit. These women may be spirited adventurers, but
                        possibly tend be the wives, daughters, and mothers of men who migrate, and may
                        therefore be more likely to seek visas based on their relationships rather than
                        work or student visas."),
                    plotOutput("visa_by_gender")
                ),
                tabItem(tabName = "citizenship",
                    p("Most arrivals are returning citizens, followed by people from the UK, India, and
                        China. Aside from a small surge in migrants from India in 2014 and 2015, as well
                        as recently growing numbers from the Philippines and South Africa, numbers from
                        most countries don't fluctate dramatically."),
                    plotOutput(arrivals_by_citizenship),
                    # plotOutput()
                )
            ),
            tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"))
        )
    )

# SERVER ####
server <-
    shinyServer(function(input, output) {
        # location ####
        output$nz_regions <- renderLeaflet(
            leaflet() %>%
            	addProviderTiles("OpenTopoMap") %>%
            	addPolygons(
            		data = nz_regions,
            		weight = 1,
            	    label = ~ REGC2020_2,
            	    highlight = highlightOptions(
            	        weight = 5,
            	        color = "green",
            	        bringToFront = TRUE
        	        )
            	)
        )
        output$arrivals_by_area <- renderPlot(
            arrivals_by_area %>%
            group_by(., year, area) %>%
            summarise(., arrivals = sum(arrivals)) %>%
            ggplot(data = ., aes(x = arrivals, y = area)) +
            geom_col(fill = "#d95f02") +
            labs(
                title = "Arrivals by NZ Area",
                subtitle = subtitle,
                x = "Arrivals",
                y = "Region",
                fill = "Area"
            ) +
            x_commas +
            theme_few()
        )
        output$arrivals_by_visa <- renderPlot(
            arrivals_by_gender %>%
                group_by(., year, visa_type) %>%
                summarise(., arrivals = sum(arrivals)) %>%
                ggplot(data = ., aes(x = year, y = arrivals, fill = visa_type)) +
                geom_col(position = "fill") +
                labs(
                    title = "Arrivals by Visa",
                    subtitle = subtitle,
                    x = "Year",
                    y = "Arrivals",
                    fill = "Type of Visa"
                ) +
                scale_y_continuous(labels = percent) +
                scale_fill_brewer(palette = "Set3") +
                theme_few()
        )
        # occupation ####
        output$workers_by_year <- renderPlot(
            arrivals_by_occup %>%
        	group_by(year) %>%
        	summarise(., arrivals = sum(total_occup)) %>%
        	ggplot(., aes(x = year, y = arrivals)) +
        		geom_col(fill = "#d95f02") +
        		labs(
        			title = "Workers by Year: ANZSCO Major Occupations Only",
		        	subtitle = subtitle,
        			x = "Year", y = "Arrivals"
        		) +
        		y_commas +
        		theme_few()
        )
        output$workers_by_occup <- renderPlot(
            arrivals_by_occup %>%
        	pivot_longer(.,
        		cols = 2:9,
        		names_to = "occupation",
        		values_to = "arrivals"
        	) %>%
        	group_by(., occupation) %>%
        	summarise(., arrivals = sum(arrivals)) %>%
        	ggplot(data = ., aes(y = occupation, x = arrivals)) +
        		geom_col(fill = "#d95f02") +
        		labs(
        			title = "Workers by Occupation: ANZSCO Major Occupations Only",
        			subtitle = subtitle,
        			y = "Occupation", x = "Arrivals"
        		) +
        		x_commas +
        		theme_few()
        )
        # gender ####
        output$arrivals_by_gender <- renderPlot(
            arrivals_by_gender %>%
        	group_by(., year, gender) %>%
        	summarise(., arrivals = sum(arrivals)) %>%
        	ggplot(data = ., aes(x = year, y = arrivals, fill = gender)) +
        		geom_col(position = "dodge") +
        		labs(
        			title = "Arrivals by Gender",
        			subtitle = subtitle,
        			x = "Year", y = "Arrivals",
        			fill = "Gender"
        		) +
        		y_commas +
        		scale_fill_brewer(palette = "Dark2")+
        		theme_few()
        )
        output$visa_by_gender <- renderPlot(
            arrivals_by_gender %>%
                group_by(., gender, visa_type) %>%
                summarise(., arrivals = sum(arrivals)) %>%
                ggplot(data = ., aes(x = arrivals, y = visa_type, fill = gender)) +
                geom_col(position = "dodge") +
                labs(
                    title = "Type of Visa by Gender",
                    subtitle = subtitle,
                    x = "Arrivals",
                    y = "Type of Visa",
                    fill = "Gender"
                ) +
                x_commas +
                scale_fill_brewer(palette = "Dark2") +
                theme_few()
        )
        output$arrivals_by_citizenship <- renderPlot(
            arrivals_by_citizenship %>%
                group_by(., year, citizenship) %>%
                summarise(., arrivals = sum(arrivals)) %>%
                ggplot(data = ., aes(x = year, y = arrivals, fill = citizenship)) +
                geom_col(position = "fill") +
                labs(
                    title = "Arrivals by Citizenship",
                    subtitle = subtitle,
                    x = "Year",
                    y = "Arrivals",
                    fill = "Citizenship"
                ) +
                scale_fill_manual(
                    labels = c(
                        "new_zealand" = "New Zealand",
                        "australia" = "Australia",
                        "fiji" = "Fiji",
                        "china,_people's_republic_of" = "China",
                        "india" = "India",
                        "japan" = "Japan",
                        "korea,_republic_of" = "South Korea",
                        "philippines" = "The Philippines",
                        "germany" = "Germany",
                        "united_kingdom" = "The UK",
                        "canada" = "Canada",
                        "united_states_of_america" = "The US",
                        "south_africa" = "South Africa"
                    ),
                    values = c(
                        "australia" = "saddlebrown",
                        "canada" = "yellow3",
                        "china,_people's_republic_of" = "royalblue4",
                        "fiji" = "coral2",
                        "germany" = "yellowgreen",
                        "india" = "darkorchid4",
                        "japan" = "orange",
                        "korea,_republic_of" = "green4",
                        "new_zealand" = "lightgoldenrod3",
                        "philippines" = "hotpink3",
                        "south_africa" = "aquamarine3",
                        "united_kingdom" = "darkolivegreen",
                        "united_states_of_america" = "red4"
                    )
                ) +
                scale_y_continuous(labels = percent) +
                theme_few()
        )
        # output$ <- renderPlot(
        #
        # )
        # output$ <- renderPlot(
        #
        # )

    })



shinyApp(ui, server)
