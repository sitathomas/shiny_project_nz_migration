shinyUI(
	dashboardPage(
	  skin = "green",
	  dashboardHeader(title = "Exploring Migration to New Zealand", titleWidth = "100%"),
	  dashboardSidebar(
		  sidebarMenu(
		    menuItem("Region Data", tabName = "region", icon = icon("compass")),
		    menuItem("Visa Data", tabName = "visa", icon = icon("stamp")),
		    menuItem("Citizenship Data", tabName = "citizenship", icon = icon("passport")),
		    menuItem("Occupation Data", tabName = "occupation", icon = icon("briefcase")),
		    menuItem("Age Data", tabName = "age", icon = icon("clock")),
		    menuItem("Gender Data", tabName = "gender", icon = icon("users"))
	    )
	  ),
	  dashboardBody(
	    tabItems(
	      # region ####
	      tabItem(tabName = "region",
	        p("Here you can explore some of the data available for Permanent and Long-Term
	            Migration to New Zealand from 2010-2017. The raw data can be found under the
	            headings Subject Categories > Tourism > International Travel and Migration at:"),
	        p("http://archive.stats.govt.nz/infoshare/"),
	        leafletOutput("nz_regions"),

	        p("The vast majority of migrants land in the Auckland area, followed by Canturbury
	            and Wellington."),
	        plotOutput("arrivals_by_area")
	      ),

	      #visa ####
	      tabItem(tabName = "visa",
	        p("Citizens returning to the country or moving from Australia make up the majority
	            of arrivals, followed by migrants with work visas."),
	        plotOutput("arrivals_by_visa")
	      ),

	      # citizenship ####
	      tabItem(tabName = "citizenship",
	        p("Most arrivals are returning citizens, followed by people from the UK, India, and
	            China. Aside from a small surge in migrants from India in 2014 and 2015, as well
	            as growing numbers from the Philippines and South Africa, numbers from most
	            countries don't fluctate dramatically."),
	        plotOutput("citizenship_plot")
	      ),

	      # occupation ####
	      tabItem(tabName = "occupation",
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

	      # age ####
	      tabItem(tabName = "age",
	        p("Most arrivals are students and young professionals, and likely citizens returning
	            after college education elsewhere."),
	        plotOutput("age_by_year"),

	        p("As to be expected, the type of visa largely correlates with standard life cycles -
	            the young are students, young adults are workers, and seniors are likely retirees.
	            Citizens returning to New Zealand peak in their 50s, possibly returning as
	            empty-nesters after children become independent, or to care for aging parents."),
	        plotOutput("age_by_visa")
	      ),

	      # gender ####
	      tabItem(tabName = "gender",
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
	      )

	    ),
	      # CSS ####
	      tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"))
	  )
	)
)