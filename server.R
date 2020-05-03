shinyServer(function(input, output) {
	# region ####
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
			geom_col(fill = "#bc80bd") +
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

	# visa ####
	output$arrivals_by_visa <- renderPlot(
		arrivals_by_gender %>%
			group_by(., year, visa_type) %>%
			summarise(., arrivals = sum(arrivals)) %>%
			ggplot(data = ., aes(
				x = year, y = arrivals, fill = visa_type
			)) +
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
	select_visa_by_age <- reactive(
		arrivals_by_age %>%
			filter(., visa_type == input$visa_type) %>%
			group_by(., visa_type, age) %>%
			summarise(., arrivals = sum(arrivals))
	)
	output$select_visa_by_age <- renderPlot(
		select_visa_by_age() %>%
			ggplot(data = ., aes(x = arrivals, y = age)) +
			geom_col(fill = "#bc80bd") +
			labs(
				title = "Type of Visa by Age",
				subtitle = subtitle,
				x = "Arrivals",
				y = "Ages"
			) +
			scale_x_continuous(labels = comma) +
			scale_y_discrete(labels = ages) +
			theme_few()
	)

	# age ####
	output$age_by_year <- renderPlot(
		arrivals_by_age %>%
			group_by(., year, age) %>%
			summarise(., arrivals = sum(arrivals)) %>%
			ggplot(data = ., aes(x = arrivals, y = age)) +
			geom_col(fill = "#bc80bd") +
			labs(
				title = "Arrivals by Age",
				subtitle = subtitle,
				x = "Arrivals",
				y = "Ages"
			) +
			x_commas +
			scale_y_discrete(labels = ages) +
			theme_few()
	)
	output$age_by_visa <- renderPlot(
		arrivals_by_age %>%
			group_by(., visa_type, age) %>%
			summarise(., arrivals = sum(arrivals)) %>%
			ggplot(data = ., aes(
				x = arrivals, y = age, fill = visa_type
			)) +
			geom_col(position = "fill") +
			labs(
				title = "Age by Type of Visa",
				subtitle = subtitle,
				x = "Arrivals",
				y = "Ages",
				fill = "Type of Visa"
			) +
			scale_x_continuous(labels = percent) +
			scale_y_discrete(labels = ages) +
			scale_fill_brewer(palette = "Set3") +
			theme_few()
	)

	# citizenship ####
	output$citizenship_plot <- renderPlot(
		arrivals_by_citizenship %>%
			group_by(., year, citizenship) %>%
			summarise(., arrivals = sum(arrivals)) %>%
			ggplot(data = ., aes(
				x = year, y = arrivals, fill = citizenship
			)) +
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
				values = colorRampPalette(brewer.pal(12, "Set3"))(13)
			) +
			scale_y_continuous(labels = percent) +
			theme_few()
	)

	# occupation ####
	output$workers_by_year <- renderPlot(
		arrivals_by_occup %>%
			group_by(year) %>%
			summarise(., arrivals = sum(total_occup)) %>%
			ggplot(., aes(x = year, y = arrivals)) +
			geom_col(fill = "#bc80bd") +
			labs(
				title = "Workers by Year: ANZSCO Major Occupations Only",
				subtitle = subtitle,
				x = "Year",
				y = "Arrivals"
			) +
			y_commas +
			theme_few()
	)
	output$workers_by_occup <- renderPlot(
		arrivals_by_occup %>%
			pivot_longer(
				.,
				cols = 2:9,
				names_to = "occupation",
				values_to = "arrivals"
			) %>%
			group_by(., occupation) %>%
			summarise(., arrivals = sum(arrivals)) %>%
			ggplot(data = ., aes(y = occupation, x = arrivals)) +
			geom_col(fill = "#bc80bd") +
			labs(
				title = "Workers by Occupation: ANZSCO Major Occupations Only",
				subtitle = subtitle,
				y = "Occupation",
				x = "Arrivals"
			) +
			x_commas +
			theme_few()
	)

	# gender ####
	output$arrivals_by_gender <- renderPlot(
		arrivals_by_gender %>%
			group_by(., year, gender) %>%
			summarise(., arrivals = sum(arrivals)) %>%
			ggplot(data = ., aes(
				x = year, y = arrivals, fill = gender
			)) +
			geom_col(position = "dodge") +
			labs(
				title = "Arrivals by Gender",
				subtitle = subtitle,
				x = "Year",
				y = "Arrivals",
				fill = "Gender"
			) +
			y_commas +
			scale_fill_brewer(palette = "Set3") +
			theme_few()
	)
	output$visa_by_gender <- renderPlot(
		arrivals_by_gender %>%
			group_by(., gender, visa_type) %>%
			summarise(., arrivals = sum(arrivals)) %>%
			ggplot(data = ., aes(
				x = arrivals, y = visa_type, fill = gender
			)) +
			geom_col(position = "dodge") +
			labs(
				title = "Type of Visa by Gender",
				subtitle = subtitle,
				x = "Arrivals",
				y = "Type of Visa",
				fill = "Gender"
			) +
			x_commas +
			scale_fill_brewer(palette = "Set3") +
			theme_few()
	)

	# datatables ####
	output$area_table <- renderDT(arrivals_by_area)
	output$citizenship_table <- renderDT(arrivals_by_citizenship)
	output$occup_table <- renderDT(arrivals_by_occup, options = list(scrollX = T))
	output$age_table <- renderDT(arrivals_by_age)
	output$gender_table <- renderDT(arrivals_by_gender)
})