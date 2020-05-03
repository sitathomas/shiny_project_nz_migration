# libraries ####
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(RColorBrewer)
library(scales)
library(rgdal)
library(leaflet)
library(shiny)
library(shinydashboard)
library(DT)
library(rsconnect)

# occupation preprocessing ####
arrivals_by_occup <- read_csv("data/arrivals_by_occup.csv", col_names = T, skip = 3)
arrivals_by_occup <- arrivals_by_occup[-(9:44),]
colnames(arrivals_by_occup)[1] = "year"
colnames(arrivals_by_occup)[10] = "total_occup"
arrivals_by_occup

# gender preprocessing ####
arrivals_by_gender <-
	read_csv("data/arrivals_by_gender.csv", col_names = T, skip = 4)
arrivals_by_gender <- arrivals_by_gender[-(9:41),]
colnames(arrivals_by_gender)[1] = "year"
females <- arrivals_by_gender %>%
	pivot_longer(., 2:7, names_to = "visa_type", values_to = "females") %>%
	select(., year, visa_type, females)
males <- arrivals_by_gender %>%
	pivot_longer(., 8:13, names_to = "visa_type", values_to = "males") %>%
	select(., year, visa_type, males) %>%
	mutate(., visa_type = gsub("_1", "", visa_type))
arrivals_by_gender <- inner_join(females, males, by = c("year", "visa_type")) %>%
	pivot_longer(., 3:4, names_to = "gender", values_to = "arrivals")

# age preprocessing ####
arrivals_by_age <-
	read_csv("data/arrivals_by_age.csv", col_names = T, skip = 4)
arrivals_by_age <- arrivals_by_age[-(9:41),]
colnames(arrivals_by_age)[1] = "year"
age_00_04 <- arrivals_by_age %>%
	pivot_longer(., 2:7, names_to = "visa_type", values_to = "age_00_04") %>%
	select(., year, visa_type, age_00_04) %>%
	mutate(., age_00_04 = as.integer(age_00_04))
age_05_09 <- arrivals_by_age %>%
	pivot_longer(., 8:13, names_to = "visa_type", values_to = "age_05_09") %>%
	select(., year, visa_type, age_05_09) %>%
	mutate(., age_05_09 = as.integer(age_05_09),
		visa_type = gsub("_1", "", visa_type))
age_10_14 <- arrivals_by_age %>%
	pivot_longer(., 14:19, names_to = "visa_type", values_to = "age_10_14") %>%
	select(., year, visa_type, age_10_14) %>%
	mutate(., age_10_14 = as.integer(age_10_14),
		visa_type = gsub("_2", "", visa_type))
age_15_19 <- arrivals_by_age %>%
	pivot_longer(., 20:25, names_to = "visa_type", values_to = "age_15_19") %>%
	select(., year, visa_type, age_15_19) %>%
	mutate(., age_15_19 = as.integer(age_15_19),
		visa_type = gsub("_3", "", visa_type))
age_20_24 <- arrivals_by_age %>%
	pivot_longer(., 26:31, names_to = "visa_type", values_to = "age_20_24") %>%
	select(., year, visa_type, age_20_24) %>%
	mutate(., age_20_24 = as.integer(age_20_24),
		visa_type = gsub("_4", "", visa_type))
age_25_29 <- arrivals_by_age %>%
	pivot_longer(., 32:37, names_to = "visa_type", values_to = "age_25_29") %>%
	select(., year, visa_type, age_25_29) %>%
	mutate(., age_25_29 = as.integer(age_25_29),
		visa_type = gsub("_5", "", visa_type))
age_30_34 <- arrivals_by_age %>%
	pivot_longer(., 38:43, names_to = "visa_type", values_to = "age_30_34") %>%
	select(., year, visa_type, age_30_34) %>%
	mutate(., age_30_34 = as.integer(age_30_34),
		visa_type = gsub("_6", "", visa_type))
age_35_39 <- arrivals_by_age %>%
	pivot_longer(., 44:49, names_to = "visa_type", values_to = "age_35_39") %>%
	select(., year, visa_type, age_35_39) %>%
	mutate(., age_35_39 = as.integer(age_35_39),
		visa_type = gsub("_7", "", visa_type))
age_40_44 <- arrivals_by_age %>%
	pivot_longer(., 50:55, names_to = "visa_type", values_to = "age_40_44") %>%
	select(., year, visa_type, age_40_44) %>%
	mutate(., age_40_44 = as.integer(age_40_44),
		visa_type = gsub("_8", "", visa_type))
age_45_49 <- arrivals_by_age %>%
	pivot_longer(., 56:61, names_to = "visa_type", values_to = "age_45_49") %>%
	select(., year, visa_type, age_45_49) %>%
	mutate(., age_45_49 = as.integer(age_45_49),
		visa_type = gsub("_9", "", visa_type))
age_50_54 <- arrivals_by_age %>%
	pivot_longer(., 62:67, names_to = "visa_type", values_to = "age_50_54") %>%
	select(., year, visa_type, age_50_54) %>%
	mutate(., age_50_54 = as.integer(age_50_54),
		visa_type = gsub("_10", "", visa_type))
age_55_59 <- arrivals_by_age %>%
	pivot_longer(., 68:73, names_to = "visa_type", values_to = "age_55_59") %>%
	select(., year, visa_type, age_55_59) %>%
	mutate(., age_55_59 = as.integer(age_55_59),
		visa_type = gsub("_11", "", visa_type))
age_60_64 <- arrivals_by_age %>%
	pivot_longer(., 74:79, names_to = "visa_type", values_to = "age_60_64") %>%
	select(., year, visa_type, age_60_64) %>%
	mutate(., age_60_64 = as.integer(age_60_64),
		visa_type = gsub("_12", "", visa_type))
age_65_69 <- arrivals_by_age %>%
	pivot_longer(., 80:85, names_to = "visa_type", values_to = "age_65_69") %>%
	select(., year, visa_type, age_65_69) %>%
	mutate(., age_65_69 = as.integer(age_65_69),
		visa_type = gsub("_13", "", visa_type))
age_70_74 <- arrivals_by_age %>%
	pivot_longer(., 86:91, names_to = "visa_type", values_to = "age_70_74") %>%
	select(., year, visa_type, age_70_74) %>%
	mutate(., age_70_74 = as.integer(age_70_74),
		visa_type = gsub("_14", "", visa_type))
age_75_up <- arrivals_by_age %>%
	pivot_longer(., 92:97, names_to = "visa_type", values_to = "age_75_up") %>%
	select(., year, visa_type, age_75_up) %>%
	mutate(., age_75_up = as.integer(age_75_up),
		visa_type = gsub("_15", "", visa_type))
arrivals_by_age <-
	inner_join(age_00_04, age_05_09, by = c("year", "visa_type")) %>%
	inner_join(., age_10_14, by = c("year", "visa_type")) %>%
	inner_join(., age_15_19, by = c("year", "visa_type")) %>%
	inner_join(., age_20_24, by = c("year", "visa_type")) %>%
	inner_join(., age_25_29, by = c("year", "visa_type")) %>%
	inner_join(., age_30_34, by = c("year", "visa_type")) %>%
	inner_join(., age_35_39, by = c("year", "visa_type")) %>%
	inner_join(., age_40_44, by = c("year", "visa_type")) %>%
	inner_join(., age_45_49, by = c("year", "visa_type")) %>%
	inner_join(., age_50_54, by = c("year", "visa_type")) %>%
	inner_join(., age_55_59, by = c("year", "visa_type")) %>%
	inner_join(., age_60_64, by = c("year", "visa_type")) %>%
	inner_join(., age_65_69, by = c("year", "visa_type")) %>%
	inner_join(., age_70_74, by = c("year", "visa_type")) %>%
	inner_join(., age_75_up, by = c("year", "visa_type")) %>%
	pivot_longer(., c(
		age_00_04, age_05_09, age_10_14, age_15_19,
		age_20_24, age_25_29, age_30_34, age_35_39,
		age_40_44, age_45_49, age_50_54, age_55_59,
		age_60_64, age_65_69, age_70_74, age_75_up
		),
		names_to = "age",
		values_to = "arrivals"
	)

ages <- c(
			"age_00_04" = "0 to 4", "age_05_09" = "5 to 9",
			"age_10_14" = "10 to 14", "age_15_19" = "15 to 19",
			"age_20_24" = "20 to 24", "age_25_29" = "25 to 29",
			"age_30_34" = "30 to 34", "age_35_39" = "35 to 39",
			"age_40_44" = "40 to 44", "age_45_49" = "45 to 49",
			"age_50_54" = "50 to 54", "age_55_59" = "55 to 59",
			"age_60_64" = "60 to 64", "age_65_69" = "65 to 69",
			"age_70_74" = "70 to 74", "age_75_up" = "75 and up"
		)

# citizenship preprocessing ####
arrivals_by_citizenship <- read_csv("data/arrivals_by_citizenship.csv", col_names = T)
colnames(arrivals_by_citizenship) <- gsub(" ", "_", colnames(arrivals_by_citizenship))
colnames(arrivals_by_citizenship) <- tolower(colnames(arrivals_by_citizenship))
arrivals_by_citizenship <- arrivals_by_citizenship %>%
	pivot_longer(., 2:14, names_to = "citizenship", values_to = "arrivals")

# area preprocessing ####
arrivals_by_area <- read_csv("data/arrivals_by_area.csv", col_names = T, skip = 4)
arrivals_by_area <- arrivals_by_area[-(9:49),]
colnames(arrivals_by_area)[1] = "year"
colnames(arrivals_by_area) <- gsub("region", "Region", colnames(arrivals_by_area))
arrivals_by_area <- arrivals_by_area %>%
	pivot_longer(., 2:17, names_to = "area", values_to = "arrivals") %>%
	group_by(., year, area) %>%
	summarise(., arrivals = sum(arrivals))

# ggplot preprocessing ####
subtitle <- "Permanent and Long-Term Migration to New Zealand, 2010 - 2017"
x_commas <- scale_x_continuous(labels = comma)
y_commas <- scale_y_continuous(labels = comma)

# nz_regions preprocessing ####
nz_regions <-
	readOGR(
		dsn="./data/statsnzregional-council-2020-generalised-SHP",
  	layer="regional-council-2020-generalised",
		verbose = F
	)
nz_regions <- nz_regions[1:16,]
nz_regions <- spTransform(nz_regions, CRS("+proj=longlat +datum=WGS84"))