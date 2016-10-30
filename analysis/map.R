########## Plot the latitude and longitude from app_events ##########
setwd("C:/Users/Stephen/kaggle-talkingdata/data/extract")
rm(list=ls())
gc(reset=TRUE)
library(dplyr)
library(data.table)

events <- fread("events.csv", colClasses=c("numeric", "numeric", "character", "numeric", "numeric"))
smpl <- sample(1:nrow(events), size=2000, replace=FALSE)
events_smpl <- events[smpl,]
events_smpl <- events_smpl %>%
  mutate(long2 = ifelse(longitude<50,NA,longitude),
         lat2 = ifelse(latitude<20,NA,latitude)) %>%
  filter(!is.na(long2) & !is.na(lat2))

library(maps)
library(mapproj)
map(database="world", ylim=c(30,40), xlim=c(100,115), col="grey80", fill=TRUE, projection="gilbert")
longs <- events_smpl$long2
lats <- events_smpl$lat2
coord <- mapproject(events_smpl$long2, events_smpl$lat2, proj="gilbert")
points(coord, col="red")

png(file="../../analysis/images/exploratorymap.png")
dev.off()