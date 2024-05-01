
library(dplyr)
library(sf)
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