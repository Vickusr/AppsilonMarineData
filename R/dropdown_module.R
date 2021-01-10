dropDownUI <- function(id, text, choices){
  dropdown_input(NS(id,'dropdown'),default_text = text, choices = choices)
}

dropDownServer <- function(id, data, var){
  
  moduleServer(id, function(input,output,session){
   
    
    # update the data as the data frame changes
    observeEvent(data()$SPEED, {
      update_dropdown_input(session, "dropdown", choices = unique(data()[[var]]))
    })
    
    filter_data_to_app <- eventReactive(input$dropdown,{
      req(input$dropdown)
      req(data())
      
      filtered_data <- data() %>% 
                 filter(.data[[var]] == input$dropdown) 
      filtered_data
      
  })
    
    
    
    })
}
