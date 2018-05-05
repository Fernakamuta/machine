######   ######   ######   ######   ######   ######   ######   ######   
# INTERFACE DO OAUTH PARA TWITTER - Nov/2015
#
# Elaboração: Fernando (03/12/2015) 
# Formatação: Fernando (03/12/2015)
#
# Aplicação principal: Captura os dados do Twitter
#
# Pré-Requisitos: Autenticação com API do Twitter (my_oauth.RData)  
#
######   ######   ######   ######   ######   ######   ######   ###### 


rm(list=ls())
library(streamR)

#1) Autenticar
load("my_oauth.RData")

Sys.Date()
#2) Captura Stream
while(TRUE){
  
  NameJson <- paste("Base_",Sys.Date(),".json",sep = "")
  
  filterStream(file.name = NameJson,
               locations=c(-47.20694,-24.06307,-45.694611, -23.18326),
               tweets=NULL,
               oauth = my_oauth,
               timeout = 900
  )
  
}
