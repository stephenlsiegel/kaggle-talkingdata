########## Check whether all app_id + label_id is unique across all app_labels ##########

# Set up
rm(list=ls())
setwd("C:/Users/Stephen/kaggle-talkingdata/data/extract")
library(dplyr)
library(data.table)

# Load data
app_labels <- fread("app_labels.csv", colClasses="character")

# Check whether "app_id" + "event_id" is unique
app_labels <- app_labels %>%
  mutate(pk = paste(app_id, "_", label_id, sep=""))

pk <- app_labels$pk
pkUnique <- unique(pk)

length(pk)
length(pkUnique)

View(app_labels %>% group_by(pk) %>%
  summarise(count1=n()) %>%
  arrange(desc(count1)) %>%
  filter(count1>=2))
