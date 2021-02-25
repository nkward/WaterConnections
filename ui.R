## Source global.R file
## This file must be in the same directory as your ui.R and server.R files
source("global.R")


## Build user interface (how your app looks)
shinyUI(
  fluidPage(theme="superhero.css",                                               ## This .css file is located in 'www' folder. 
           
           ## formating settings:
            tags$head(tags$style("#choice{color: #317eac;
                                 font-family: Helvetica, Arial, sans-serif; #font-weight: 500;line-height: 1.2;
                                 font-size: 125%;text-align: center;
                                 }
                           
                                 .popover-header{ 
                                 background: #ffff99; 
                                 }
                                 .popover-content{ 
                                 background: #913737; 
                                 }
                                 #sidebar {
                                 background-color: #dcf0fa;
                                 }

                                 .popover-title{
                                 color: #000000;
                                 font-size: 16px;
                                 background-color: #f2cbcb;
                                 }
                                 

                                 div#Image { 
                                 width: 100%;
                                 height: 100%;
                                 }
                                 element-style{
                                 height:100%
                                 
                                 }
                                 svg g text{
                                 font-size:30px
                                 }
                                 div#gauge3{
                                 height:150%;
                                  width:150%;
                                 font-size: 30px;
                                 }
                                 div#gauge4{
                                 height:100%
                                 }
                            
                                 .shiny-image-output shiny-bound-output{
                                 height:100%
                                 }
                                 
                                 ")),
    
         
            navbarPage("Water Quality Connections", #title of page (upper left corner)
                  
                       #side bar settings:
                                sidebarLayout(
                                  sidebarPanel(id="sidebar",style = "height: height4; position:relative;",
                                    h4("Property Management Decisions:",strong(span(("(start below here)"),style="color:red")),style="color:black"),
                                    hr(style = " margin-top:-0.5em"),
                                    p("1. Start with a 100 foot vegetated buffer and see what happens to the images on the right if you decrease or remove the buffer",style="color:black"),
                                    uiOutput('dropdownbuffer'),
                                    hr(style = " margin-top:-0.5em"),
                                    p("2. Next, start with no fertilizer application and incrementally change the 3 settings below to see how fertilizer use affects water quality",style="color:black"),
                                    uiOutput('dropdownfert'),
                                    uiOutput('dropdownferttype'),
                                   uiOutput('dropdownferttiming'),
                                   hr(style = " margin-top:-0.5em"),
                                   p("3. How does installing/removing the buffer with different fertilizer settings affect water quality?",style="color:black"),
                                   hr(),
                                   p("4. Change the property management decision menus above. Which combinations result in the best water quality? the worst water quality?",style="color:black"),
                                   hr(),
                                  p(" ",style="color:black") 
                                  ),
                                  
                                  # main panel settings:
                                  mainPanel(width = 8,
                                      column(width = 12,style = " margin-top:-2em",
                                             h3("Anticipated Effects on Water Quality", align = "center"),
                                             hr(style = " margin-top:-0.5em"),
                                             fluidRow(
                                               column(width = 6,style = "margin-top:-1.5em;margin-bottom:-2em",
                                                      h4("View From Dock in 10 years",align = "center"),
                                                      div(id="Image2",class="shiny-image-output",style="width: 100% ; height: 100%"),
                                                      p("(hover mouse over image and gauges to learn more)",align = "center",style="color:grey"),
                                                      bsPopover(id = "Image2",title = "The Vicious Cycle of Algae",
                                                                content = paste0("<p>As more phosphorus becomes available in the water, algae grow faster.",
                                                                                 "</p><p>The algae inevitably die, decompose, releasing more phosphorus, causing more algae scums in the future.</p>"),
                                                                placement = "left",trigger = "hover")
                                                       ),
                                               column(6,style = " margin-top:-1.5em",
                                                      h4("Environmental Indicator Gauges", align = "center"),
                                                      p("(current water clarity in lake is ~ 20 feet)",align = "center",style="color:lightblue;margin-top:-0.75em"),
                                                      column(width=6,style = "padding:-10em;margin-bottom:-2em;margin-top:-1em",
                                                                 gaugeOutput("gauge",width = "100%",height = "100%"),
                                                             p(strong("Phosphorus leaving property (lbs/acre)"),align = "center",
                                                                style = "padding:-6em;margin-top:-0.5em;font-size:150%"),
                                                             bsPopover(id = "gauge",title = "Phosphorus Effects",
                                                                       content = paste0("<p>As more phosphorus leaves the property, there is more phosphorus available in the water for algae to grow out of control.",
                                                                                        "</p><p>Phosphorus is food for algae! More phosphorus means more algae and worse water quality.</p>"),
                                                                       placement = "left",trigger = "hover")),
                                                      column(width=6,style = "padding:-10em;margin-bottom:-2em;margin-top:-1em",
                                                                  gaugeOutput("gauge4",width = "100%",height = "100%"),
                                                             p(strong("Water clarity (feet) in 10 years if all properties in region made the selected decisions"),align = "center",
                                                               style = "padding:-6em;margin-top:-0.5em;font-size:150%"),
                                                             
                                                             bsPopover(id = "gauge4",title = "Water Clarity Decreases with More Phosphorus",
                                                                       content = paste0("<p>Water clarity is the distance into the water you can see.</p>",
                                                                                        "<p>With more algae in the water, water clarity can decrease dramatically.</p>",
                                                                                        "</p><p>Less algae generally means higher water clarity.</p>"),
                                                                       placement = "left",trigger = "hover"))
                                                      )
                                             ),
                                             hr(style = " margin-top:1.5em"),
                                             h4("Relationship Between Property and Lake", align = "center",style = " margin-top:-0.5em"),
                                             imageOutput("Image")
                                      )
                                             )
                                             )
                    
                        )
                                
                       )
)