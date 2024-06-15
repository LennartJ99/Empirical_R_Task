library(here)
library(dplyr)


UnE_Income<-read.csv(here("input","Unemployment+Income.csv"), sep=";", header=TRUE, encoding="UTF-8",skip=1)
UnE_Income<-UnE_Income%>%
  mutate(ARS=ifelse(nchar(X)==4,paste0("0",X),X))%>%
  
  mutate(Unemployment2017=as.numeric(gsub(",", ".", X2017Arbeitslosenquote, fixed=TRUE)))%>%
  mutate(Unemployment2018=as.numeric(gsub(",", ".", X2018Arbeitslosenquote, fixed=TRUE)))%>%
  mutate(Unemployment2021=as.numeric(gsub(",", ".", X2021Arbeitslosenquote, fixed=TRUE)))%>%
  mutate(PurchasePower2017=as.numeric(gsub(".","",sub(",.*", "", X2017Kaufkraft),fixed=TRUE)))%>%
  mutate(PurchasePower2018=as.numeric(gsub(".","",sub(",.*", "", X2018Kaufkraft),fixed=TRUE)))%>%
  mutate(PurchasePower2021=as.numeric(gsub(".","",sub(",.*", "", X2021Kaufkraft),fixed=TRUE)))%>%
  select("ARS","Unemployment2017","Unemployment2018","Unemployment2021",
         "PurchasePower2017","PurchasePower2018","PurchasePower2021")