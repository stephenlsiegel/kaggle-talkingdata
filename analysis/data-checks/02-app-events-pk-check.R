########## Check whether all event_id + app_id is unique across all app_events ##########

# Set up
rm(list=ls())
setwd("C:/Users/Stephen/kaggle-talkingdata/data/extract")
library(dplyr)
library(data.table)

# Load data
app_events <- fread("app_events.csv", colClasses="character")

# Check whether "app_id" + "event_id" is unique
app_events <- app_events %>%
  mutate(pk = paste(event_id, "_", app_id, sep=""))

pk <- app_events$pk
rm(app_events)
pkUnique <- unique(pk)

length(pk)
length(pkUnique)
