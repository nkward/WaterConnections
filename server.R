## Source global.R file
## This file must be in the same directory as your ui.R and server.R files
source('global.R')

## Server processing
shinyServer(function(input, output, session) {
  
  current_selection<-reactiveVal(NULL)                                   # maintain current selection for fertilizer dropdown if user changes selection in different dropdown
  observeEvent(input$dropdownfert,{
    current_selection(input$dropdownfert)
  })
  
  output$dropdownbuffer <- renderUI({                                              # make dropdown manu for selecting buffer size
    selectInput("dropdownbuffer",shiny::HTML("<p><span style='color: black'>Select Vegetated Buffer Width (Feet):</span></p>"),
                unique(dataset3$buffer))})                                         # menu selections are unique character values in column 'buffer' of dataset3
  
  
  output$dropdownfert <- renderUI({                                                # make dropdown manu for applying fertilizer
    req(input$dropdownbuffer)
    selectInput("dropdownfert",shiny::HTML("<p><span style='color: black'>Apply Fertilizer on Lawn?</span></p>"),
                unique(dataset3$fertilizer),selected=current_selection())})        # menu selections are unique character values in column 'fertilizer' of dataset3
  
  current_selection2<-reactiveVal(NULL)                                # maintain current selection for dropdown if user changes selection in different dropdown
  observeEvent(input$dropdownferttype,{
    current_selection2(input$dropdownferttype)
  })
  
  output$dropdownferttype <- renderUI({                                            # make dropdown manu for fertilizer type
    req(input$dropdownfert)
    data_available=dataset3[dataset3$fertilizer==input$dropdownfert,"fert_type"]   # menu selections are unique character values in column 'fert_type' of dataset3
    selectInput(inputId = "dropdownferttype",label = shiny::HTML("<p><span style='color: black'>Select Fertilizer Type:</span></p>"),
                choices = unique(data_available),selected =current_selection2())}) 
  
  
  current_selection3<-reactiveVal(NULL)                               # maintain current selection for fertilizer dropdown if user changes selection in different dropdown
  observeEvent(input$dropdownferttiming,{
    current_selection3(input$dropdownferttiming)
  })
  
  output$dropdownferttiming <- renderUI({                                               # make dropdown manu for fertilizer application timing
    req(input$dropdownbuffer)
    data_available3=dataset3[dataset3$fert_type==input$dropdownferttype,"fert_timing"]  # menu selections are unique character values in column 'fert_timing' of dataset3
    selectInput(inputId = "dropdownferttiming",label = shiny::HTML("<p><span style='color: black'>Select Timing of Fertilizer Application:</span></p>"),
                choices = unique(data_available3),selected = current_selection3())}) 
  


  dataInput <- reactive({                                              # create reactive phosphorus data
    req(input$dropdownbuffer)                                          # slow load of gauge so it is loaded upon landing on page, before user makes selection
    
    bf_index<-input$dropdownbuffer                                     # identify drop down menu selections
    fert_index<-input$dropdownfert
    fertty_index<-input$dropdownferttype
    ferttm_index<-input$dropdownferttiming
    
    p_index<-dataset3[which(dataset3$buffer==bf_index&dataset3$fertilizer==fert_index&dataset3$fert_type==fertty_index&dataset3$fert_timing==ferttm_index),
                      'Phosphorus_kg_ha_yr']                            # extract corresponding P export
    
    v = round(p_index*0.892179,digits = 1)                              # convert to lbs per acre
  })
  
  output$gauge = renderGauge({                                          # create P export gauge visualization
    req(dataInput)                                                      # slow down load of visualization until dataInput is identified, so visualizaiton is loaded upong landing on page
    gauge(dataInput(),symbol = "",
          min = 0,                                                      # select min and max values for gauge visualization
          max = 4, 
          sectors = gaugeSectors(success = c(0, 0.4999), 
                                 warning = c(0.5000, 1.499),
                                 danger = c(1.5, 6.5)))                 # categorize values to assign different colors to bar on gauge depending on value
  })
  
  dataInput4 <- reactive({                                                            # Water Clarity Gauge Reactive Settings
    bf_index<-input$dropdownbuffer                                                    # pull buffer selection from dropdown (100/50/0)
    fert_index<-input$dropdownfert                                                    # pull fertilizer selection from dropdown (yes/no)
    fertty_index<-input$dropdownferttype                                              # pull fertilizer type selection from dropdown (No/Low/High Phosphorus)
    ferttm_index<-input$dropdownferttiming                                            # pull application timing selection from dropdown (warm,dry/cool,wet weather) 
    
    wc_index<-dataset3[which(dataset3$buffer==bf_index&
                               dataset3$fertilizer==fert_index&
                               dataset3$fert_type==fertty_index&
                               dataset3$fert_timing==ferttm_index),'clarity']         # find corresponding water clarity number from data table
    
    v = wc_index
   
  })
  output$gauge4 = renderGauge({                                                       # create water quality gauge visualization
    req(dataInput4)                                                                   # must have dataInput4 from above
    gauge(dataInput4(),symbol = "",                                                   
          min = 0,     
          max = 30,                                                                   # set min and max of gauge scale
          sectors = gaugeSectors(success = c(17, 30),                                 # set color of bar in guage based on value range
                                 warning = c(5, 17),
                                 danger = c(0, 4.9999), 
                                 colors = c("deepskyblue","slategrey","tan")))
  })
  
  
  output$Image2 <- renderImage({                                                      # select image for "view from the dock"
    # Read myImage's width and height. These are reactive values, so this
    # expression will re-run whenever they change.
    req(input$dropdownbuffer)                                                         # slow down loading of image so image is selected upon landing on page, before user makes dropdown selection
    width3  <- session$clientData$output_Image_width                                  # adjust width and height of image according to user screen size/dimensions
    height3  <- session$clientData$output_Image_height
    
    bf_index<-input$dropdownbuffer                                                    # identify user selections in dropdown menus
    fert_index<-input$dropdownfert
    fertty_index<-input$dropdownferttype
    ferttm_index<-input$dropdownferttiming
    
    pc_index<-dataset3[which(dataset3$buffer==bf_index&                               # identify corresponding image based on dataset3 table                        
                               dataset3$fertilizer==fert_index&
                               dataset3$fert_type==fertty_index&
                               dataset3$fert_timing==ferttm_index),'dock']
    filename2 <- normalizePath(file.path('./www',paste("Dock_",pc_index, '.png',      # path to image  for "view from the dock"
                                                      sep='')))
    list(src = filename2,width = width3*0.5,height=height3*0.6)                       # adjust dimensions
  },
  deleteFile = FALSE)                                                                 # DO NOT delete file after rendering
  
  output$Image <- renderImage({                                                       # select image for "Relationship between property and lake"
    # Read myImage's width and height. These are reactive values, so this
    # expression will re-run whenever they change.
    req(input$dropdownbuffer)
    width  <- session$clientData$output_Image_width
    
    bf_index<-input$dropdownbuffer                                                    # Identify dropdown menu selections
    fert_index <- input$dropdownfert     
    
    if(input$dropdownferttype=="Not Applicable"){                                     # save only first word of fert_type and fert_timing columns of dataset 3
      fertty_index<-"Not"
    }else{
      fertty_index<-strsplit(input$dropdownferttype," ")[[1]][1]
    }
    if(input$dropdownferttiming=="Not Applicable"){
      ferttm_index<-"Not"
    }else{
      ferttm_index<-strsplit(input$dropdownferttiming," ")[[1]][1]
    }
    
    filename <- normalizePath(file.path('./www',
                                        paste("Diagram_",bf_index,"_",fert_index,
                                         "_",fertty_index,'_',ferttm_index,'.png',
                                                      sep='')))                     # file path to image for "Relationship between property and lake"
    list(src = filename,width=width,height=width*0.4)                               # adjust size
  },
  deleteFile = FALSE)                                                               # DO NOT delete file after rendering
  
})