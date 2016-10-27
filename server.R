library(shiny)
library(ggmap)
coords = readRDS("citation_coordinates.rds")
und_coords = readRDS('underage_citations.rds')
map = get_map(location = c(lon = mean(coords$Longitude) , lat = mean(coords$Latitude)) ,
              maptype = "roadmap", zoom = 14 , color = "bw" )

# Define server logic required to draw graphs
shinyServer(function(input, output) {
  
pointsmap =  ggmap(map) +
    geom_point(data = coords , aes( x = Longitude , y = Latitude , fill = "blue") , size = 3 ,
               shape = 21)+ 
  theme(legend.position = "none")

pointsmap2 = ggmap(map) +
  geom_point(data = coords , aes( x = Longitude , y = Latitude , fill = "blue") , size = 3 ,
             shape = 21) +
  geom_point(data = und_coords , aes( x = Longitude , y = Latitude , fill = "red") , size = 3 ,
             shape = 21) + 
  theme(legend.position = "none")

heatmap = ggmap(map) +
  stat_density2d(data = coords, 
                 aes(x = Longitude , y = Latitude, fill = ..level.., alpha = ..level..),
                 size = 0.01, bins = 16 , geom = "polygon") +
  scale_fill_gradient(low = "yellow" , high = "red") +
  scale_alpha(range = c(0,0.3) , guide = FALSE) + 
  theme(legend.position = "none")

heatmap2 = ggmap(map) +
  stat_density2d(data = coords, 
                 aes(x = Longitude , y = Latitude, fill = ..level.., alpha = ..level..),
                 size = 0.01, bins = 16 , geom = "polygon") +
  scale_fill_gradient(low = "yellow" , high = "red") +
  scale_alpha(range = c(0,0.3) , guide = FALSE) +
  geom_point(data = und_coords , aes( x = Longitude , y = Latitude ),
             fill = "#00BFC4" ,size = 3, pch = 21) + 
  theme(legend.position = "none")

x = reactive({input$drinks})  

  output$plot2 <- renderPlot({
    if(x() == FALSE){
      pointsmap
    } else if(x() == TRUE){
      pointsmap2
    } 
  
  })
  output$plot1 <- renderPlot({
    if(x() == FALSE){
    heatmap
    } else if(x() == TRUE ){
    heatmap2
    }
  })
  

})