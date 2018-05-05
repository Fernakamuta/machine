library(shiny)
library(dplyr)
# filterData
filterData <- function(Data,Bounds,Time,Day){
  
  if (!is.null(Bounds)){
    latRng <- range(Bounds$north, Bounds$south)
    lngRng <- range(Bounds$east, Bounds$west)
    
    
    filterData <- Data[Data$lat >= latRng[1] &
                         Data$lat <= latRng[2] &
                         Data$lon >= lngRng[1] &
                         Data$lon <= lngRng[2] &
                         Data$TimePlayer >= Time[1] &
                         Data$TimePlayer <= Time[2] &
                         Data$Week %in% Day,]
    
    return(filterData[,c("lat","lon")])
    
  }else{
    filterData <- Data[Data$TimePlayer >= Time[1] &
                         Data$TimePlayer <= Time[2] &
                         Data$Week %in% Day,]
    return(filterData[,c("lat","lon")])
  }
  
}

# graphFilter
graphFilter <- function(Data,Bounds,Day){
  
  if (!is.null(Bounds)){
    bounds <- Bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    graphFilter <- Data[Data$lat >= latRng[1] &
                          Data$lat <= latRng[2] &
                          Data$lon >= lngRng[1] &
                          Data$lon <= lngRng[2] &
                          Data$Week %in% Day,]
    return(graphFilter)
  }else{
    graphFilter <- Data[Data$Week %in% Day,]
    return(graphFilter)
  }
}

# Kmeans1
clusters <- function(filteredData,nClusters){
  Kmeans <- kmeans(filteredData,nClusters,iter.max = 100000)
  Centers <- as.data.frame(Kmeans$centers)
  Size <- Kmeans$size
  return(as.data.frame(cbind(Centers,Size)))
}

# filterData2
filterData2 <- function(Data,Day){
  
  #if (!is.null(Bounds)){
  #  latRng <- range(Bounds$north, Bounds$south)
  #  lngRng <- range(Bounds$east, Bounds$west)
    
    
    filterData <- Data[#Data$lat >= latRng[1] &
                         #Data$lat <= latRng[2] &
                         #Data$lon >= lngRng[1] &
                         #Data$lon <= lngRng[2] &
                         Data$Week %in% Day,]
    
    return(filterData[,c("lat","lon","Hour")])
    
  #}else{
  #  filterData <- Data[(Data$Week %in% Day),]
   # return(filterData[,c("lat","lon","Hour")])
  #}
  
}

# graphFilter
graphFilter2 <- function(Data,Day){
  
  #if (!is.null(Bounds)){
   # bounds <- Bounds
    #latRng <- range(bounds$north, bounds$south)
    #lngRng <- range(bounds$east, bounds$west)
    
    graphFilter <- Data[#Data$lat >= latRng[1] &
                         # Data$lat <= latRng[2] &
                          #Data$lon >= lngRng[1] &
                          #Data$lon <= lngRng[2] &
                          Data$Week %in% Day,]
    return(graphFilter)
  #}else{
    #graphFilter <- Data[Data$Week %in% Day,]
    #return(graphFilter)
  
}


############
reorderClusters <- function(ClusterS,NewClusters){
  
  Clusts <- data.frame()
  
  m <- matrix(nrow = 3,ncol = 3)
  
  orderIndex <- data.frame()
  
  for (i in 1:3){
    for(j in 1:3){
      m[i,j] <- sqrt((ClusterS$lat[i] - NewClusters$lat[j])^2 + (ClusterS$lon[i] - NewClusters$lon[j])^2)
    }
  }
  k<-1
  while (k<=3){
    Mins <- which(m== min(m), arr.ind = TRUE)
    m[Mins[1],] <- 90
    m[,Mins[2]] <- 90
    ClustsTemp <- NewClusters[Mins[1,2],]
    ClustsTemp$Order <- Mins[1,1]
    Clusts <- rbind.data.frame(Clusts,ClustsTemp)
    k <- k+1
  }
  Clusts <- Clusts %>%
    arrange(Order)
  return(Clusts)
}

clusters2 <- function(filteredData){
  
  dfCluster <- data.frame()  
  baseClusters <-  data.frame()
  
  for(i in (0:23)){
    
    Kmeans <- kmeans(filteredData[filteredData$Hour==i,c("lat","lon")],3)
    
    iCluster <- cbind.data.frame(Kmeans$centers,Kmeans$size)
    
    if(i+1<10){
      iCluster$Time <- paste("0",i,":00",sep = "")
    }else{
      iCluster$Time <- paste(i,":00",sep = "")  
    }
    iCluster$Index <- i
    dfCluster <- rbind.data.frame(dfCluster,iCluster)
  }
  baseClusters <- dfCluster[dfCluster$Index==0,]
  baseClusters$Order <- seq(1:3)
  #  for(i in seq(1,67,by = 3)){
  for(j in (0:22)){
    lCluster <- baseClusters[baseClusters$Index==j,]
    rCluster <- dfCluster[dfCluster$Index==(j+1),]
    #lCluster <- dfCluster[(i):(i+2),]
    #rCluster <- dfCluster[(i+3):(i+5),]  
    rCluster <- reorderClusters(lCluster,rCluster)
    baseClusters <- rbind.data.frame(baseClusters, rCluster)  
  }
  
  #Colors <- rep(c("#ff0000","#0033ff","#fff200","#0cff00","#ffffff"),times=24)
  Colors <- rep(c("#ff0000","#0033ff","#fff200"),times=24)
  baseClusters$Color <- Colors
  #names(baseClusters)<- c("lat","lon","Size","Time","i","Color")
  colnames(baseClusters)<- c("lat","lon","Size","Time","Index","Order","Color")
  return(baseClusters)
}