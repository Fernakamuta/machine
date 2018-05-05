
Base$Weekend <- "Dias úteis"

Base$Weekend[Base$Week=="Saturday"|Base$Week=="Sunday"] <- "Final de Semana"

# Base Cheia
ggplot(Base, aes(x= Hour))+
  ggtitle("Base Total")+
  geom_bar(aes(y = (..count..)/sum(..count..)),fill="blue",color = "black",alpha=0.5)+
  scale_x_continuous(name = "Horário",breaks = seq(2,24,by = 2))+
  scale_y_continuous(name = "Frequência")+
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=14,face="bold"))+
  theme_light()


# Base FDS
ggplot(Base[Base$Week =="Saturday"|Base$Week =="Sunday",], aes(x= Hour))+
  ggtitle("Finais de Semana") + 
  geom_bar(aes(y = (..count..)/sum(..count..)),fill="blue",color = "black",alpha=0.5)+
  scale_x_continuous(name = "Horário",breaks = seq(2,24,by = 2))+
  scale_y_continuous(name = "Frequência")+
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=14,face="bold"))+
  theme_light()

# Base Weekdays
ggplot(Base[Base$Week !="Saturday" & Base$Week !="Sunday",], aes(x= Hour))+
  ggtitle("Dias Úteis") + 
  geom_bar(aes(y = (..count..)/sum(..count..)),fill="blue",color = "black",alpha=0.5)+
  geom_vline(xintercept = c(9,17), colour="black", linetype = "longdash",size=1,alpha=0.8)+
  scale_x_continuous(name = "Horário",breaks = seq(2,24,by = 2))+
  scale_y_continuous(name = "Frequência")+
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=14,face="bold"))+
  theme_light()


ggplot(Base, aes(x= Hour))+
  ggtitle("Finais de Semana") + 
  facet_grid(. ~ Weekend) +
  geom_bar(aes(y = (..count..)/sum(..count..)),fill="blue",color = "black",alpha=0.5)+
  scale_x_continuous(name = "Horário",breaks = seq(2,24,by = 2))+
  scale_y_continuous(name = "Frequência")+
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=14,face="bold"))+
  theme_light()









