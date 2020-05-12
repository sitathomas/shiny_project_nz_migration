shinyUI(
	dashboardPage(
	  skin = "green",
	  dashboardHeader(
	  	title = "Exploring Migration to New Zealand",
	  	titleWidth = "100%"),
		# sidebar ####
	  dashboardSidebar(
		  sidebarMenu(
		    menuItem("Region Data", tabName = "region", icon = icon("compass")),
		    menuItem("Visa Data", tabName = "visa", icon = icon("stamp")),
		    menuItem("Age Data", tabName = "age", icon = icon("clock")),
		  	menuItem(
		    	"Citizenship Data",
		    	tabName = "citizenship",
		    	icon = icon("passport")),
		    menuItem(
		    	"Occupation Data",
		    	tabName = "occupation",
		    	icon = icon("briefcase")),
		    menuItem("Gender Data", tabName = "gender", icon = icon("user")),
		  	menuItem("Data Tables", tabName = "datatables", icon = icon("database"))
	    )
	  ),
	  dashboardBody(
		  # CSS ####
		  tags$head(
		  	tags$link(
		  		rel = "stylesheet", type = "text/css", href = "custom.css"
				)
			),
	    tabItems(
	      # region ####
	      tabItem(tabName = "region",
	      	p("In this app, you can explore some of the data available for
	      		Permanent and Long-Term Migration to New Zealand from 2010-2017."),
	        leafletOutput("nz_regions"),

	        p("The vast majority of migrants land in the Auckland area, followed
	        	by Canturbury and Wellington. A travel company can use this data to
	        	focus on improving networks and offerings in the most popular
	        	destinations, in order to reach the largest number of migrants per
	        	offering."),
	        plotOutput("arrivals_by_area")
	      ),

	      #visa ####
	      tabItem(tabName = "visa",
	        p("Citizens returning to the country or moving from Australia make up
	        	the majority of arrivals, followed by migrants with work visas. A
	        	travel company needs to know why migrants are arriving, as workers
	        	have different needs and wants than students, who have different
	        	wants and needs than residents. Offerings and marketing can be
	        	customized for each group."),
	        plotOutput("arrivals_by_visa"),

	      	p("Given that work and student visas combined make up the majority of
	      		arrivals, it is unsurprising that most arrivals are late teens to
	      		young adults. Offerings for these groups could focus on career and
	      		professional networking resources. Citizens returning to New Zealand
	      		do so most often between ages 25 and 29, potentially indicating that
	      		education and/or early career opportunities were pursued overseas.
	      		This group's offerings could be focused on social networking and
	      		local travel excursions, as they may have truly disposable income to
	      		spend for the first time in their lives."),
	      	selectizeInput(
	      		inputId = "visa_type",
	      		label = "Select a Type of Visa to Sort Arrivals by Age",
	      		choices = unique(arrivals_by_age$visa_type)
	      	),
	      	plotOutput("select_visa_by_age")
	      ),

	      # age ####
	      tabItem(tabName = "age",
	        p("Most arrivals are in their teens, 20s, and early 30s, but their
	        	types of visas vary, potentially indicating other factors about
	        	their residency, such as length of stay (students or seniors may
	        	stay upwards of 5 years, while workers may stay 2 or 3), or economic
	        	activity (young students may not have money for local travel
	        	but a worker in their 40s may be happy to spend a lot)."),
	        plotOutput("age_by_year"),

	        p("As to be expected, the ratio of visa type to arrivals for a given
	        	age group largely correlates with standard life cycles. Most
	        	arrivals in their 20s and 30s are students and workers, and seniors
	        	with a Residence visa are likely retirees. Most arrivals in their
	        	50s are citizens, possibly returning as empty-nesters after children
	        	become independent, or to care for aging parents."),
	        plotOutput("age_by_visa")
	      ),

	      # citizenship ####
	      tabItem(tabName = "citizenship",
	        p("Most arrivals are returning citizens, followed by people from the
	        	UK, India, and China. Aside from a small surge in migrants from
	        	India in 2014 and 2015, as well as growing numbers from the
	        	Philippines and South Africa, numbers from most countries don't
	        	fluctate much. Citizenship can be used by a travel company to tailor offerings in
	      		certain languages, cultivate networks of ex-pats, or highlight
	      		cultural resources like neighborhoods, cultural organizations,
	      		religious groups, or markets/restaurants by cuisine."),
	        plotOutput("citizenship_plot")
	      ),

	      # occupation ####
	      tabItem(tabName = "occupation",
	        p("Permanent and long-term migration to New Zealand for workers in the
	        	ANZSCO Major Occupation groups has increased more than threefold
	        	since 2010 despite negative net arrivals in 2011 and 2012,
	        	indicating potentially good prospects for migrants on a work visa."),
	        plotOutput("workers_by_year"),

	        p("However, most permanent and long-term migrants are Professionals by
	        	far, while more Sales Workers and Machinery Operators and Drivers
	        	have departed New Zealand than have arrived. Because workers have
	        	different needs than those with other visas, they can be targeted
	        	accordingly - types of jobs indicate income levels and interests,
	        	and industries may indicate destination."),
	        plotOutput("workers_by_occup")
	      ),

	      # gender ####
	      tabItem(tabName = "gender",
	        p("Slightly more men tend to migrate on average, which could be due to
	        a variety of factors, such as more opportunities in male-dominated
	        fields or greater economic mobility for men."),
	        plotOutput("arrivals_by_gender"),

	        p("More men than women migrate as students and for work, which is
	        likely due to the same variety of factors that includes those listed
	        above. More women tend to migrate for residency and to visit. These
	        women possibly have a tendency be the wives, daughters, and mothers of
	        men who migrate, and may therefore be more likely to seek visas based
	        on their relationships rather than work or student visas."),
	        plotOutput("visa_by_gender")
	      ),
	    	tabItem(tabName = "datatables",
	    		p("The raw data can be found under the headings Subject Categories >
	      		Tourism > International Travel and Migration > Permanent and long-
	    			term migration... at",
	    			tags$a(href = "http://archive.stats.govt.nz/infoshare/",
	    				"Stats NZ"), "."
	    		),
					tabBox(
						width = 12,
						tabPanel("Arrivals by Area", DTOutput("area_table")),
		    		tabPanel("Arrivals by Citizenship", DTOutput("citizenship_table")),
		    		tabPanel("Arrivals by Occupation", DTOutput("occup_table")),
		    		tabPanel("Arrivals by Age", DTOutput("age_table")),
		    		tabPanel("Arrivals by Gender", DTOutput("gender_table"))
					)
  			)
	    )
	  )
	)
)