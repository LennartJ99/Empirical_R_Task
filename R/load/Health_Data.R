library(here)
library(dplyr)


Healthcare<-read.csv(here("input","Healthcare+Kids.csv"), sep=";", header=TRUE, encoding="UTF-8",skip=1)
Healthcare<-Healthcare%>%
  mutate(ARS=ifelse(nchar(X)==4,paste0("0",X),X))%>%
  mutate(KH2017=as.numeric(gsub(",", ".", X2017Krankenhausversorgung, fixed=TRUE)))%>%
  mutate(KH2018=as.numeric(gsub(",", ".", X2018Krankenhausversorgung, fixed=TRUE)))%>%
  mutate(KH2021=as.numeric(gsub(",", ".", X2021Krankenhausversorgung, fixed=TRUE)))%>%
  select("ARS","KH2017","KH2018","KH2021")