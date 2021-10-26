#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(DT)
library(ggplot2)
library(plotly)
library(tidyverse)
library(leaflet)
library(mapdeck)


data <- readRDS("Part_C2.rds") #Data file created in Part C

ui <- dashboardPage(
    dashboardHeader(title="UK Hygiene Dashboard",     
                    dropdownMenu(
                        type = "notification", #Notification with a hyperlink to the Food Hygiene Ratings Scheme API
                        notificationItem(
                            text = "Data Source", 
                            href = "https://data.food.gov.uk/catalog/datasets/38dd8d6a-5ab1-4f50-b753-ab33288e3200"
                        )
                    )
                    
    ),
    
    
    
    dashboardSidebar(  
        sidebarMenu(
            menuItem("Hygiene Data", #First tab on the side bar
                     tabName = "hygienedata", 
                     icon = icon("dashboard")
            ),
            menuItem("Hygiene Plots", #Second tab on the side bar
                     tabName = "hygieneplots", 
                     icon = icon("th")
            ),
            menuItem("Filtered Plot", #Third tab on the side bar
                     tabName = "hygienewithcontrols", 
                     icon = icon("filter")
            )
        )
    ),
    
    
    dashboardBody(    
        tabItems(
            # First tab content
            tabItem(tabName = "hygienedata",
                    fluidRow( h1("Dataset") ), 
                    fluidRow(
                        column(width = 12,
                               DT::dataTableOutput("data", width = 1250)
                        )
                    )
                    
            ),
            
            # Second tab content
            tabItem(tabName = "hygieneplots",
                    fluidRow(column(width=12, h1("Plots") #Title for second tab content 
                    )
                    ),
                    
                    fluidRow(
                        #Creating box to display map on left half of 'hygieneplots' dashboard page
                        column(width = 6, 
                               box(title="United Kingdom Business Locations", 
                                   width=12,
                                   mapdeckOutput("map")
                               )
                        ),
                        #Creating box to display chart on right half of 'hygieneplots' dashboard page
                        column(width = 6, 
                               box(title="Count of Ratings", 
                                   width = 12,
                                   plotOutput("ratings")
                               )
                        )
                    )
            ),
            
            
            
            
            # Third tab content 
            tabItem(tabName = "hygienewithcontrols",
                    fluidRow(column(width = 12, h1("Hygiene Rating by Business Type")
                    )
                    ),
                    fluidRow(column(width = 6, #Creating options for the drop down menu on the third tab
                                    selectInput("businesstype", label = h3("Select Type"), 
                                                choices = list("Distributors/Transporters" = "Distributors/Transporters", "Farmers/growers"="Farmers/growers",
                                                               "Hospitals/Childcare/Caring Premises"="Hospitals/Childcare/Caring Premises",
                                                               "Hotel/bed & breakfast/guest house"="Hotel/bed & breakfast/guest house",
                                                               "Importers/Exporters"="Importers/Exporters", "Manufacturers/packers"="Manufacturers/packers",
                                                               "Mobile caterer"="Mobile caterer", "Other catering premises"="Other catering premises",
                                                               "Pub/bar/nightclub"="Pub/bar/nightclub", "Restaurant/Cafe/Canteen"="Restaurant/Cafe/Canteen",
                                                               "Retailers - other"="Retailers - other", "Retailers - supermarkets/hypermarkets"="Retailers - supermarkets/hypermarkets",
                                                               "School/college/university"="School/college/university", "Takeaway/sandwich shop"="Takeaway/sandwich shop"
                                                ),
                                                selected = "Distributors/Transporters")
                    )       
                    ),
                    
                    fluidRow(column(width = 12, #Plotting area for chart on third tab dashboard 
                                    plotlyOutput("plotlyratingbar")
                    )
                    )
            )
        )
    )
)


