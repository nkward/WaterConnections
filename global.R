# Call up the libraries you need to use to run the app
library(shiny) # Makes shiny apps
library(dplyr) # Data manipulation
library(flexdashboard)
library(shinyBS)
library(tidyverse)





# Bring in data for app
datasetR<-read_csv("data/property.csv")
dataset3<-as.data.frame(datasetR)



