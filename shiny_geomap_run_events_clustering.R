library(shiny)
library(leaflet)
library(sp)
library(dplyr)




df <- read.csv("data/WCP205 170319 to 220319 GPS Deliveries.csv")


greenVanIcon <- makeIcon(
  iconUrl = "img/green_van.png",
  iconWidth = 38, iconHeight = 38,
  iconAnchorX = 19, iconAnchorY = 37
)



#df <- tidyr::separate(data=df,
#                      col=Location.1,
#                      into=c("Latitude", "Longitude"),
#                      sep=",",
#                      remove=FALSE)

#df$Latitude <- stringr::str_replace_all(df$Latitude, "[(]", "")
#df$Longitude <- stringr::str_replace_all(df$Longitude, "[)]", "")

#df$Latitude <- as.numeric(df$Latitude)
#df$Longitude <- as.numeric(df$Longitude)








# Define UI ----
ui <- fluidPage(
  leafletOutput("mymap", height = 1000)
  )
  



# Define server logic ----
server <- function(input, output, session) {
  data <- reactive({
    x <- df
  })
  
  output$mymap <- renderLeaflet({
    df <- data()
    
    m <- leaflet(data = df) %>% 
      addTiles() %>% 
      addMarkers(data = deliveries, lng= ~Longitude, lat = ~Latitude, icon = greenVanIcon, popup = paste(
        "<strong>TrackingNo:</strong>", deliveries$Tracking.No, "<br/>",
        "<strong>Event DateTime:</strong>", deliveries$Scan.Date, "<br/>",
        "<strong>Event Type:</strong>", deliveries$Scan.Type,
        "<strong>Run.No.:</strong>", deliveries$Run.No.),
        clusterOptions = markerClusterOptions(
          zoomToBoundsOnClick = TRUE)
      )    
  m
  })
}


# Run the app ----
shinyApp(ui = ui, server = server)
