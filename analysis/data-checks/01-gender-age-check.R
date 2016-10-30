########## Check whether all device IDs across gender_age_train and gender_age_test are unique ##########

# Set up
rm(list=ls())
setwd("C:/Users/Stephen/kaggle-talkingdata/data/extract")
library(dplyr)
library(data.table)

# Load data
ga_train <- fread("gender_age_train.csv", colClasses="character")
ga_test <- fread("gender_age_test.csv", colClasses="character")

# Train IDs
train_ids <- ga_train$device_id
train_ids_unique <- unique(train_ids)

length(train_ids)
length(train_ids_unique)

# Test IDs
test_ids <- ga_test$device_id
test_ids_unique <- unique(test_ids)

length(test_ids)
length(test_ids_unique)

# Combined IDs
all_ids <- c(train_ids_unique, test_ids_unique)
all_ids_unique <- unique(all_ids)
