library(dplyr)
library(sf)
###Combine federal and voting districts
Combined_Data <- st_intersection(spatial_federal_districts, spatial_voting_districts)

Combined_Data$intersection_area <- st_area(Combined_Data)

Combined_Data<-Combined_Data%>%
  group_by(ARS)%>%
  mutate(percentage=intersection_area/sum(intersection_area)*100)%>%
  ungroup()

Combined_Data$percentage<-as.numeric(as.character(Combined_Data$percentage))

Combined_Data<-Combined_Data%>%
 filter(percentage>10)%>%
group_by(ARS)%>%
  mutate(percentage=intersection_area/sum(intersection_area)*100)%>%
  ungroup()

Combined_Data$percentage<-as.numeric(as.character(Combined_Data$percentage))

###Implement Migration Data
Combined_Data<-left_join(Combined_Data,migration2022%>%select(Year,Man,Woman,Total,Number),by=c("ARS"="Number"))
Combined_Data$Woman<-as.numeric(Combined_Data$Woman)
Combined_Data$Man<-as.numeric(Combined_Data$Man)
Combined_Data$Total<-as.numeric(Combined_Data$Total)

Combined_Data<-Combined_Data%>%
  mutate(Man2022=Man*percentage/100,
         Woman2022=Woman*percentage/100,
         Total2022=Total*percentage/100)

###Implement Election Data