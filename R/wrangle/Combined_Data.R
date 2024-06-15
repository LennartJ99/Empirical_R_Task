library(dplyr)
library(sf)
library(tidyverse)
library(rlang)
###Combine federal and voting districts
Combined_Data17 <- st_intersection(spatial_federal_districts, spatial_voting_districts_17)
Combined_Data <- st_intersection(spatial_federal_districts, spatial_voting_districts_21)

###Calculate Intersection Areas. Due to some pairings appearing twice, we
###add up the areas and union the geometries.
Combined_Data17$intersection_area17<- st_area(Combined_Data17)
Combined_Data17 <- Combined_Data17 %>%
  group_by(ARS, WKR_NR) %>%
  summarize(
    intersection_area17 = sum(intersection_area17),
    geometry = st_union(geometry)
  )%>%
  ungroup()

Combined_Data$intersection_area21<- st_area(Combined_Data)
Combined_Data <- Combined_Data %>%
  group_by(ARS, WKR_NR) %>%
  summarize(
    intersection_area21 = sum(intersection_area21),
    geometry = st_union(geometry) )%>%
  ungroup()
###dropping geometry, wont be needing it anymore.
Combined_Data <- st_drop_geometry(Combined_Data)
Combined_Data17 <- st_drop_geometry(Combined_Data17)
Combined_Data17$intersection_area17<-as.numeric(Combined_Data17$intersection_area17)
Combined_Data$intersection_area21<-as.numeric(Combined_Data$intersection_area21)
###There were districts that overlapped in the spatial data but not in reality
###By Trial and Error we found that 3% is a good threshold to filter out these districts
###Important!!!!
Combined_Data<-Combined_Data%>%
  group_by(ARS)%>%
  mutate(percentage21=intersection_area21/sum(intersection_area21)*100)%>%
  ungroup()
Combined_Data$percentage21<-as.numeric(as.character(Combined_Data$percentage21))
Combined_Data<-Combined_Data%>%
  group_by(ARS)%>%
  filter(percentage21>3)%>%
  mutate(percentage21=intersection_area21/sum(intersection_area21)*100)%>%
  select(-c(intersection_area21))%>%
  ungroup()


Combined_Data17<-Combined_Data17%>%
  group_by(ARS)%>%
  mutate(percentage17=intersection_area17/sum(intersection_area17)*100)%>%
  ungroup()
Combined_Data17$percentage17<-as.numeric(as.character(Combined_Data17$percentage17))
Combined_Data17<-Combined_Data17%>%
  group_by(ARS)%>%
  filter(percentage17>3)%>%
  mutate(percentage17=intersection_area17/sum(intersection_area17)*100)%>%
  select(-c(intersection_area17))%>%
  ungroup()

  

###Before combining both datasets, we need to add "proxy" relations between federal
###and voting districts, that didnt exist in 2017 but do in 2021.
Combined_Data17<-Combined_Data17%>%
add_row(ARS="09375",WKR_NR=234,percentage17=0)%>%
add_row(ARS="09575",WKR_NR=242,percentage17=0)%>%
add_row(ARS="09772",WKR_NR=254,percentage17=0)

Combined_Data<-Combined_Data%>%
  right_join(.,Combined_Data17 %>%
              select(ARS, WKR_NR, percentage17), by = c("ARS", "WKR_NR"))





Combined_Data<-Combined_Data%>%
group_by(ARS)%>%
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


###Implement Migration Data

Combined_Data_test<-Combined_Data
Combined_Data<-Combined_Data_test  
  Combined_Data <- Combined_Data %>%
    left_join(migration2022 %>% select(Man, Woman, Total, Number), by = c("ARS" = "Number"))
  Combined_Data<-Combined_Data%>%
    rename(Man2022=`Man`)%>%
    rename(Woman2022=`Woman`)%>%
    rename(Total2022=`Total`)%>%
    mutate(Man2022=as.numeric(Man2022)*percentage21/100,
           Woman2022=as.numeric(Woman2022)*percentage21/100,
           Total2022=as.numeric(Total2022)*percentage21/100)
  
  Combined_Data <- Combined_Data %>%
    left_join(migration2021 %>% select(Man, Woman, Total, Number), by = c("ARS" = "Number"))
  Combined_Data<-Combined_Data%>%
    rename(Man2021=`Man`)%>%
    rename(Woman2021=`Woman`)%>%
    rename(Total2021=`Total`)%>%
    mutate(Man2021=as.numeric(Man2021)*percentage21/100,
           Woman2021=as.numeric(Woman2021)*percentage21/100,
           Total2021=as.numeric(Total2021)*percentage21/100)

  Combined_Data <- Combined_Data %>%
    left_join(migration2020 %>% select(Man, Woman, Total, Number), by = c("ARS" = "Number"))
  Combined_Data<-Combined_Data%>%
    rename(Man2020=`Man`)%>%
    rename(Woman2020=`Woman`)%>%
    rename(Total2020=`Total`)%>%
    mutate(Man2020=as.numeric(Man2020)*percentage21/100,
           Woman2020=as.numeric(Woman2020)*percentage21/100,
           Total2020=as.numeric(Total2020)*percentage21/100)%>%
    mutate(DiffMan2022=Man2022-Man2020,
           DiffMan2021=Man2021-Man2020,
           DiffWoman2022=Woman2022-Woman2020,
           DiffWoman2021=Woman2021-Woman2020,
           DiffTotal2022=Total2022-Total2020,
           DiffTotal2021=Total2021-Total2020)
    

  Combined_Data <- Combined_Data %>%
    left_join(migration2018 %>% select(Man, Woman, Total, Number), by = c("ARS" = "Number"))
  Combined_Data<-Combined_Data%>%
    rename(Man2018=`Man`)%>%
    rename(Woman2018=`Woman`)%>%
    rename(Total2018=`Total`)%>%
    mutate(Man2018=as.numeric(Man2018)*percentage17/100,
           Woman2018=as.numeric(Woman2018)*percentage17/100,
           Total2018=as.numeric(Total2018)*percentage17/100)

  Combined_Data <- Combined_Data %>%
    left_join(migration2017 %>% select(Man, Woman, Total, Number), by = c("ARS" = "Number"))
  Combined_Data<-Combined_Data%>%
    rename(Man2017=`Man`)%>%
    rename(Woman2017=`Woman`)%>%
    rename(Total2017=`Total`)%>%
    mutate(Man2017=as.numeric(Man2017)*percentage17/100,
           Woman2017=as.numeric(Woman2017)*percentage17/100,
           Total2017=as.numeric(Total2017)*percentage17/100)

  Combined_Data <- Combined_Data %>%
    left_join(migration2016 %>% select(Man, Woman, Total, Number), by = c("ARS" = "Number"))
  Combined_Data<-Combined_Data%>%
    rename(Man2016=`Man`)%>%
    rename(Woman2016=`Woman`)%>%
    rename(Total2016=`Total`)%>%
    mutate(Man2016=as.numeric(Man2016)*percentage17/100,
           Woman2016=as.numeric(Woman2016)*percentage17/100,
           Total2016=as.numeric(Total2016)*percentage17/100)%>%
    mutate(DiffMan2018=Man2018-Man2016,
           DiffMan2017=Man2017-Man2016,
           DiffWoman2018=Woman2018-Woman2016,
           DiffWoman2017=Woman2017-Woman2016,
           DiffTotal2018=Total2018-Total2016,
           DiffTotal2017=Total2017-Total2016)
  ###Create Control Variables
  ##Add Unemployment Data and Income Data
  Combined_Data<-Combined_Data%>%
    left_join(UnE_Income, by = c("ARS" = "ARS"))%>%
    group_by(WKR_NR)%>%
    mutate(Unemployment2017=Unemployment2017*percentage17/100,
           Unemployment2018=Unemployment2018*percentage17/100,
           Unemployment2021=Unemployment2021*percentage21/100,
           PurchasePower2017=PurchasePower2017*percentage17/100,
           PurchasePower2018=PurchasePower2018*percentage17/100,
           PurchasePower2021=PurchasePower2021*percentage21/100)%>%
           ungroup()  
  ##15 biggest Cities
  Combined_Data<-Combined_Data%>%
    mutate(Big.City=ifelse(ARS==11000|ARS==02000|ARS==09162|ARS==05315|ARS==06412|ARS==08111|ARS==05111|ARS==14713|ARS==05913|ARS==05113|ARS==04011|ARS==14612|ARS==03241|ARS==09564|ARS==05112,1,0))%>%
  ##EastGermany
    mutate(East.Germany=ifelse(WKR_NR>=12&WKR_NR<=17|WKR_NR>=56&WKR_NR<=74|WKR_NR>=151&WKR_NR<=166|WKR_NR>=189&WKR_NR<=196,1,0))
  
###Add up migration data
  Combined_Data<-Combined_Data%>%
    group_by(WKR_NR)%>%
    summarize(Man2016=sum(Man2016),
              Man2017=sum(Man2017),
              Man2018=sum(Man2018),
              Man2020=sum(Man2020),
              Man2021=sum(Man2021),
              Man2022=sum(Man2022),
              Woman2016=sum(Woman2016),
              Woman2017=sum(Woman2017),
              Woman2018=sum(Woman2018),
              Woman2020=sum(Woman2020),
              Woman2021=sum(Woman2021),
              Woman2022=sum(Woman2022),
              Total2016=sum(Total2016),
              Total2017=sum(Total2017),
              Total2018=sum(Total2018),
              Total2020=sum(Total2020),
              Total2021=sum(Total2021),
              Total2022=sum(Total2022),
              DiffMan2018=sum(DiffMan2018),
              DiffMan2017=sum(DiffMan2017),
              DiffMan2022=sum(DiffMan2022),
              DiffMan2021=sum(DiffMan2021),
              DiffWoman2018=sum(DiffWoman2018),
              DiffWoman2017=sum(DiffWoman2017),
              DiffWoman2022=sum(DiffWoman2022),
              DiffWoman2021=sum(DiffWoman2021),
              DiffTotal2018=sum(DiffTotal2018),
              DiffTotal2017=sum(DiffTotal2017),
              DiffTotal2022=sum(DiffTotal2022),
              DiffTotal2021=sum(DiffTotal2021),
              Unemployment2017=sum(Unemployment2017),
              Unemployment2018=sum(Unemployment2018),
              Unemployment2021=sum(Unemployment2021),
              PurchasePower2017=sum(PurchasePower2017),
              PurchasePower2018=sum(PurchasePower2018),
              PurchasePower2021=sum(PurchasePower2021),
              Big.City=max(Big.City),
              East.Germany=max(East.Germany),
              
              )%>%
    ungroup()
                            
      

###Implement Election Data
  
  Combined_Data <- Combined_Data %>%
    left_join(Election, by = c("WKR_NR" = "Gebietsnummer"))%>%
    mutate(Election2017=VorpProzent,
           Election2021=Prozent)%>%
    select(-c(Prozent,VorpProzent,Anzahl,VorpAnzahl))
  