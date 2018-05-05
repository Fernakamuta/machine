library(shiny)
library(dplyr)
library(leaflet)
library(ggplot2)
library(shinydashboard)

header <- dashboardHeader(
  title = "UTG Big Data"
)

sidebar <- dashboardSidebar(
  sidebarMenu(id="sidebarmenu",
    menuItem("Processo",tabName = "processo",icon = icon("magic")),
    menuItem("Kmeans",tabName = "kmeans",icon=icon("map-marker"),
         menuSubItem("Kmeans1",tabName = "kmeans1", icon = icon("toggle-right")),                 
         menuSubItem("Kmeans2",tabName = "kmeans2", icon = icon("toggle-right"))               
    ))

  )


body <- dashboardBody(
  tabItems(
    
    
################################TAB PROCESSO ###########################################################    
      tabItem("processo",
            fluidPage(
              fluidRow(box(status="primary",solidHeader = TRUE,
                           title = "Processo",
                           p("Utilizamos a seguinte medotologia em nosso estudo:"),
                           tags$img(src ="Picture2.png",width = "800px")
              ))
            )),
    
################################TAB KMEANS1 ###########################################################

    tabItem("kmeans1",
            fluidRow(
              box(
                width = 4, status = "info", solidHeader = TRUE,
                title = "Options",
                numericInput('nClusters1', 
                             'Cluster count',5,
                             min = 1, max = 10),
                
                sliderInput("Time","Time",min = 0,max = 23.75,value = c(7,9),step = 0.25,animate = animationOptions(interval=1000, loop=T)),  
                
                checkboxGroupInput("Day",label="", 
                                   choices = list("Domingo"= "Sunday","Segunda" = "Monday", "Terca" = "Tuesday", "Quarta" = "Wednesday","Quinta" = "Thursday","Sexta"= "Friday","Sabado"="Saturday"), 
                                   selected = c("Monday","Tuesday","Wednesday","Thursday","Friday")),
                plotOutput("Graph")
              ),
              box(
                width = 8, status = "info",
                title = "Centroides",
                leafletOutput("Map1",height = 800)
              )
            )
    ),
################################TAB KMEANS2 ###########################################################

    tabItem("kmeans2",
            
              box(
                width = 4, status = "info", solidHeader = TRUE,
                title = "Options",
                
                sliderInput("Time2","Time",min = 0,max = 23,value = 9,step = 1,animate = animationOptions(interval=1000, loop=T)),  
                
                checkboxGroupInput("Day2",label="Selecione os dias da semana", 
                                   choices = list("Domingo"= "Sunday","Segunda" = "Monday", "Terca" = "Tuesday", "Quarta" = "Wednesday","Quinta" = "Thursday","Sexta"= "Friday","Sabado"="Saturday"), 
                                   selected = c("Monday","Tuesday","Wednesday","Thursday","Friday")),
                checkboxGroupInput("checkCluster",label="Selecione os clusters desejados", 
                                   choices = list("Vermelho" = "#ff0000","Azul" = "#0033ff", "Amarelo"="#fff200","Verde"= "#0cff00","Roxo"= "#6517d3","Branco"="#ffffff"), 
                                   selected = c("#ff0000","#0033ff","#fff200","#0cff00","#6517d3","#ffffff")),
                plotOutput("Graph2")
              ),
              box(
                width = 8, status = "info",
                title = "Centroides",
                leafletOutput("Map2",height = 800)
              )
              
            
    )    

######
))


dashboardPage(header, sidebar, body)