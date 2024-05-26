library(dplyr)
library(sf)
library(tidyverse)
###Combine federal and voting districts
Combined_Data17 <- st_intersection(spatial_federal_districts, spatial_voting_districts_17)
Combined_Data <- st_intersection(spatial_federal_districts, spatial_voting_districts_21)

Combined_Data17$intersection_area17<- st_area(Combined_Data17)
Combined_Data17 <- Combined_Data17 %>%
  group_by(ARS, WKR_NR) %>%
  summarize(
    intersection_area17 = sum(intersection_area17),
    geometry = st_union(geometry)
  )
Combined_Data$intersection_area21<- st_area(Combined_Data)
Combined_Data <- Combined_Data %>%
  group_by(ARS, WKR_NR) %>%
  summarize(
    intersection_area21 = sum(intersection_area21),
    geometry = st_union(geometry)
  )
Combined_Data17_df <- st_drop_geometry(Combined_Data17)

Combined_Data<-Combined_Data%>%
  left_join(.,Combined_Data17_df %>%
              select(ARS, WKR_NR, intersection_area17), by = c("ARS", "WKR_NR"))



Combined_Data<-Combined_Data%>%
  group_by(ARS,WKR_NR)%>%
  mutate(percentage17=intersection_area17/sum(intersection_area17)*100)%>%
  mutate(percentage21=intersection_area21/sum(intersection_area21)*100)%>%
  ungroup()

Combined_Data$percentage17<-as.numeric(as.character(Combined_Data$percentage17))
Combined_Data$percentage21<-as.numeric(as.character(Combined_Data$percentage21))

Combined_Data<-Combined_Data%>%
  filter(percentage17>3)%>%
  filter(percentage21>3)%>%
  ###There were districts that overlapped in the spatial data but not in reality
  ###By Trial and Error we found that 3% is a good threshold to filter out these districts
group_by(ARS)%>%
  mutate(percentage17=intersection_area17/sum(intersection_area17)*100)%>%
  mutate(percentage21=intersection_area21/sum(intersection_area21)*100)%>%
  ungroup()%>%
  ###Now we manually adjust the percentage for big cities. We for example know, that Berlin is divided into
  ###12 districts, who have roughly the same population but vastly differ in size.
  ###Berlin
  mutate(percentage17=ifelse(WKR_NR>=75&WKR_NR<=86,100/12,percentage17))%>%
  ###Hannover
  mutate(percentage17=ifelse(WKR_NR==41|WKR_NR==42|WKR_NR==43|WKR_NR==47,25,percentage17))%>%
  ###Hamburg
  mutate(percentage17=ifelse(WKR_NR>=18&WKR_NR<=23,100/6,percentage17))%>%
  ###Düsseldorf
  mutate(percentage17=ifelse(WKR_NR==103|WKR_NR==107,50,percentage17))%>%
  ###Duisburg
  mutate(percentage17=ifelse(WKR_NR==115|WKR_NR==116,50,percentage17))%>%
  ###Dortmund
  mutate(percentage17=ifelse(WKR_NR==142|WKR_NR==143,50,percentage17))%>%
  ###Frankfurt/M.
  mutate(percentage17=ifelse(WKR_NR==182|WKR_NR==183,50,percentage17))%>%
  ###München
  mutate(percentage17=ifelse(WKR_NR>=217&WKR_NR<=220,25,percentage17))%>%
  ###Stuttgart
  mutate(percentage17=ifelse(WKR_NR==258|WKR_NR==259,50,percentage17))%>%
  ###Berlin
  mutate(percentage21=ifelse(WKR_NR>=75&WKR_NR<=86,100/12,percentage21))%>%
  ###Hannover
  mutate(percentage21=ifelse(WKR_NR==41|WKR_NR==42|WKR_NR==43|WKR_NR==47,25,percentage21))%>%
  ###Hamburg
  mutate(percentage21=ifelse(WKR_NR>=18&WKR_NR<=23,100/6,percentage21))%>%
  ###Düsseldorf
  mutate(percentage21=ifelse(WKR_NR==103|WKR_NR==107,50,percentage21))%>%
  ###Duisburg
  mutate(percentage21=ifelse(WKR_NR==115|WKR_NR==116,50,percentage21))%>%
  ###Dortmund
  mutate(percentage21=ifelse(WKR_NR==142|WKR_NR==143,50,percentage21))%>%
  ###Frankfurt/M.
  mutate(percentage21=ifelse(WKR_NR==182|WKR_NR==183,50,percentage21))%>%
  ###München
  mutate(percentage21=ifelse(WKR_NR>=217&WKR_NR<=220,25,percentage21))%>%
  ###Stuttgart
  mutate(percentage21=ifelse(WKR_NR==258|WKR_NR==259,50,percentage21))
Combined_Data$percentage17<-as.numeric(as.character(Combined_Data$percentage17))
Combined_Data$percentage21<-as.numeric(as.character(Combined_Data$percentage21))
###Implement Migration Data
Combined_Data<-left_join(Combined_Data,migration2022%>%select(Year,Man,Woman,Total,Number),by=c("ARS"="Number"))
Combined_Data$Woman<-as.numeric(Combined_Data$Woman)
Combined_Data$Man<-as.numeric(Combined_Data$Man)
Combined_Data$Total<-as.numeric(Combined_Data$Total)

Combined_Data<-Combined_Data %>%
  mutate(Man2022=Man*percentage/100,
         Woman2022=Woman*percentage/100,
         Total2022=Total*percentage/100)%>%
  select(-c(Man, Woman, Total))

###Implement Election Data