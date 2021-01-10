app_server <- function(ships){
  server <- function(input, output, session) {
    
    
    vessel_type_data <- dropDownServer('vessel_type',
                                       data = ships,
                                       var = 'ship_type')
    
    vessel_by_name_data <-  dropDownServer('vessel_name', 
                                           data = vessel_type_data , 
                                           var ='SHIPNAME')
    
    # Now that the data is filtered we need to move the previous 
    # coordinates to a new column so that we can do the calculations
    vessel_by_name_shifted<- eventReactive(vessel_by_name_data(),{
      
      shift_points(vessel_by_name_data())
      
    })
    
    # After points are shifted we perform distance calculations
    vessel_by_name_distance <- reactive({
      calculate_distance(vessel_by_name_shifted())
    })
    
    # Now that we have the distances we can find the largest distance
    vessel_by_name_longest_distance <- reactive({
      filter_for_longest_distance(vessel_by_name_distance())
    })
    
    
    output$detail_info_table <- DT::renderDataTable(vessel_by_name_distance(),
                                                    options = list(scrollX = TRUE),rownames= FALSE)
    
    
    output$map <- renderLeaflet({
      
      leaflet() %>%
        addProviderTiles(providers$CartoDB.Positron) %>%
        setView(lat = 0, lng = 0, zoom = 2) %>%
        addScaleBar()
    })
    
    
    # As the data changes we need to update the map.
    observeEvent(vessel_by_name_longest_distance(),{
      req(vessel_by_name_longest_distance())
      leafletProxy('map') %>%
        clearGroup('markers') %>%
        
        flyTo(lat = vessel_by_name_longest_distance()$LAT,
              lng = vessel_by_name_longest_distance()$LON,
              zoom = 12) %>%
        
        addPolylines(data = vessel_by_name_longest_distance(),
                     lng = ~c(LON,PREV_LON),
                     lat = ~c(LAT,PREV_LAT),
                     group = 'markers',
                     color = '#000000') %>%
        
        addCircleMarkers(data = vessel_by_name_longest_distance(),
                         lat = ~LAT,
                         lng = ~LON,
                         group = 'markers',
                         popup = ~make_map_note(SHIPNAME,LAT,LON,PORT,
                                                DATETIME,distance),
                         radius = 15,
                         weight = 1,
                         opacity = 1,
                         fillColor = "#008000",
                         color  = "#008000",
                         stroke = FALSE) %>%
        addPopups(data = vessel_by_name_longest_distance(),
                  lat = ~LAT,
                  lng = ~LON,
                  group = 'markers',
                  popup = ~make_map_note(SHIPNAME,LAT,LON,PORT,
                                         DATETIME,distance)) %>%
        
        
        addCircleMarkers(data = vessel_by_name_longest_distance(),
                         lat = ~PREV_LAT,
                         lng = ~PREV_LON,
                         group = 'markers',
                         radius = 12,
                         weight = 1,
                         popup = ~paste('Vessel Name:',SHIPNAME,
                                        '<br>',
                                        'Previous Point:',
                                        '<br>',
                                        '- Latitude: ',PREV_LAT,
                                        '<br>',
                                        '- Longitude :',PREV_LON),
                         opacity = 1,
                         fillColor = "#ff0000",
                         color = "#ff0000",
                         stroke = FALSE)
      
    })
    
    observe({
      if(input$path){
        leafletProxy('map') %>%
          clearGroup('path') %>%
          addPolylines(data = vessel_by_name_distance(),
                       lng = ~c(LON),
                       lat = ~c(LAT),
                       group = 'path',
                       color = '#008080')
      }else{
        leafletProxy('map') %>%
          clearGroup('path')
      }
      
    })
    
    
    
  }
}