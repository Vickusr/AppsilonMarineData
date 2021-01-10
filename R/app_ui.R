#UI File
app_ui <- function(){
  require(shiny.semantic)
  my_grid <- grid_template(default = list(
    areas = rbind(
      c('map'),
      c('filter'),
      c('detail_info')
    ),
    rows_heigth = c('700px'),
    cols_width = c('100%')
  ))
  
  gridUI <- grid(my_grid,map = withSpinner(div(style= 'margin-bottom: 30px;',
    
                                          leafletOutput('map',height = '700px')), 
                                           color = "#008080"),
                 filter = div(class= 'ui three column stackable grid',style = 'margin-bottom:30px;' ,
                              
                               div(class = 'column',align='center',
                                   
                                   card(class = 'ui card',h4(align='center','Ship Type:'),
                                    dropDownUI('vessel_type',
                                               text = 'Vessel Type', 
                                               c(''))
                               )),
                              div(class = 'column', align='center',
                                  
                                  card(h4(align='center','Vessel:'),
                                    dropDownUI('vessel_name',
                                               text = 'Vessel', 
                                               c(''))
                                    
                               )),
                              div(class = 'column',align='center', 
                                  
                                  card(h4(align='center','Explore:'),
                                    div(align = 'center',
                                        style = "margin-bottom:20px",
                                        checkbox_input('path',
                                                       label = 'Show Full Path',
                                                       is_marked = FALSE,
                                                       type = 'slider')))
                               
                 )),
                 detail_info =
                   tagList(div(style = 'margin-bottom:30px;',
                               h3(align='center',
                              "Detailed information of selected Vessel"),
                           DT::dataTableOutput('detail_info_table')))
                   
  )
  
  semanticPage(title = 'Appsilon Ports',suppress_bootstrap = FALSE,
               gridUI
  )
  
}