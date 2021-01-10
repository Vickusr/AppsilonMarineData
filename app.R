library(shiny)
library(shiny.semantic)
library(leaflet)
library(dplyr)
library(data.table)
library(readr)
library(geosphere)
library(shinycssloaders)
library(tidyr)

# Loading the data in globally, this will aid in better memory utilisation
ships <- reactiveVal(readRDS('data/ships.rds'))

ui <- app_ui()

server <- app_server(ships)

shinyApp(ui = ui, server = server)
