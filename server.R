#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(plotly)


# Source for legend https://stackoverflow.com/questions/50354112/classifying-circle-markers-by-color-in-leaflet-r-and-adding-legend


server <- function(input,output){
    #Data table on the 'Hygiene Data' tab
    output$data <- DT::renderDataTable(
        data, #variable that reads in RDS data from Part C - can be seen in 'data_prep_part_d.rmd'
        options = list(scrollX = TRUE) #Scroll bar for data on 'Hygiene Data' tab
    )
    
    #Map on the 'Hygiene Plots' tab
    output$map <- renderLeaflet({
        map3 #RDS map object created in 'data_prep_part_d.rmd'
    })
    
    #2nd plot on the 'Hygiene Plots' tab
    output$ratings <- renderPlot({
        options(scipen=10000)
        ggplot(plotting_data, aes(x = Rating_Value_updated, fill = Rating_Value_updated)) + theme(text = element_text(size = 15)) + geom_bar() + coord_flip() + labs( x= "Rating Value", y = "Count", fill = "Category") + theme(legend.position = "none")
    })
    
    #'Filtered plot on the 'Filtered Plot' tab
    output$plotlyratingbar <- renderPlotly({
        to_filter <- input$businesstype #Used to filter the chart
        ploth <- ggplot(subset(plotting_data, BusinessType==to_filter),aes(x = Rating_Value_updated, fill = Rating_Value_updated)) + geom_bar() + coord_flip() + labs( x= "Rating Value", y = "Count", fill = "Category")
        ggplotly(ploth)
    })
    
}

shinyApp(ui, server)
