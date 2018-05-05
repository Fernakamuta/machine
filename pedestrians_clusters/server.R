library(shiny)
library(dplyr)
library(leaflet)
library(ggplot2)
load("2008ShinyBase.RData")
set.seed(100)
BasePaulista <- Base[Base$lat >= -23.572385 &
                     Base$lat <= -23.554605 & 
                     Base$lon >= -46.66636  &
                     Base$lon <= -46.642499,]
                    
shinyServer(function(input, output) {

  ################# Map 1 #################
  output$Map1 <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%  
      setView(-46.6544,-23.5629,zoom = 16)
    #setMaxBounds(-46.671,-23.577,-46.631,-23.548) %>%
    #fitBounds(-46.671,-23.577,-46.631,-23.548) %>%
    #addMarkers(lng = clusters()$lon,lat = clusters()$lat) #%>%
    #addCircleMarkers(lng = clusters()$lon,lat = clusters()$lat,radius = clusters()$Size)
    #m <- addMarkers(m,lng = clusters()$lon,lat = clusters()$lat)
    #m <- addCircleMarkers(m,lng = clusters()$lon,lat = clusters()$lat,radius = clusters()$Size)
    #m
  }) 
  
  output$Map2 <- renderLeaflet({
    leaflet() %>%
      addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', 
               attribution='Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>%  
      fitBounds(lng1 = -46.66636,lat1 = -23.572385,lng2 = -46.642499,lat2 = -23.554605)%>%
      setMaxBounds(lng1 = -46.66636,lat1 = -23.572385,lng2 = -46.642499,lat2 = -23.554605)
    #setMaxBounds(-46.671,-23.577,-46.631,-23.548) %>%
    #fitBounds(-46.671,-23.577,-46.631,-23.548) %>%
    #addMarkers(lng = clusters()$lon,lat = clusters()$lat) #%>%
    #addCircleMarkers(lng = clusters()$lon,lat = clusters()$lat,radius = clusters()$Size)
    #m <- addMarkers(m,lng = clusters()$lon,lat = clusters()$lat)
    #m <- addCircleMarkers(m,lng = clusters()$lon,lat = clusters()$lat,radius = clusters()$Size)
    #m
  })
  
  
  filteredData1 <- reactive({
    
    filterData(Base,input$Map1_bounds,input$Time,input$Day)
    
  })
  
  Clusters1 <- reactive({
    
    clusters(filteredData1(),input$nClusters1)
    
  })
  
  graphData1 <- reactive({
    
    graphFilter(Base,input$Map1_bounds,input$Day)
    
  })
  
  output$Graph1 <- renderPlot({
    
    ggplot(graphData1(), aes(x= Hour))+
      geom_bar(aes(alpha=Stats),fill="blue",color = "black",alpha=0.5)+
      geom_vline(xintercept = c(9,17), colour="red", linetype = "longdash",size=1,alpha=0.8)+
      scale_x_continuous(name = "Tempo",breaks = seq(2,24,by = 2))+
      scale_y_continuous(name = "Quantidade")+
      theme(axis.text=element_text(size=12),
            axis.title=element_text(size=14,face="bold"))
  })
  
  observe({
    clusts <- Clusters1()
    proxy <- leafletProxy("Map1",data = clusts)
    proxy%>%
      clearMarkers()%>%
      addMarkers(lng = ~lon,lat =~lat,popup = ~paste(Size," Pontos"))%>%
      addCircleMarkers(lng = ~lon,lat =~lat,radius = ~(sqrt(Size)))
  })
  
  ################# Map 2 #################
  
  #filteredData2
  filteredData2 <- reactive({
    
    filterData2(BasePaulista,input$Day2)
    
  })
  
  #Clusters2
  Clusters2 <- reactive({
      
     clusters2(filteredData2())
    
  })
  
  
  #Graph2
  graphData2 <- reactive({
    
    graphFilter2(BasePaulista,input$Day2)
    
  })
  
  output$Graph2 <- renderPlot({
    
    ggplot(graphData2(), aes(x= Hour))+
      geom_bar(aes(alpha=Stats),fill="blue",color = "black",alpha=0.5)+
      geom_vline(xintercept = c(9,17), colour="red", linetype = "longdash",size=1,alpha=0.8)+
      scale_x_continuous(name = "Tempo",breaks = seq(2,24,by = 2))+
      scale_y_continuous(name = "Quantidade")+
      theme(axis.text=element_text(size=12),
            axis.title=element_text(size=14,face="bold"))
  })
  
  observe({
    proxy <- leafletProxy("Map2",data = Clusters2())
    proxy%>%
      clearShapes()%>%
      addCircles(data = filter(Clusters2(),Color %in% input$checkCluster & Index==input$Time2),lng = ~lon,lat =~lat,popup = ~Time,radius =~sqrt(Size),color=~Color) %>%
      addPolylines(data = filter(Clusters2(),Color==input$checkCluster[1]& Index <= input$Time2),lng=~lon,lat=~lat,color=~Color, weight=1)%>%
      addPolylines(data = filter(Clusters2(),Color==input$checkCluster[2]& Index <= input$Time2),lng=~lon,lat=~lat,color=~Color, weight=1)%>%
      addPolylines(data = filter(Clusters2(),Color==input$checkCluster[3]& Index <= input$Time2),lng=~lon,lat=~lat,color=~Color, weight=1)
  })
})