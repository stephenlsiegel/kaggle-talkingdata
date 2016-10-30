# Set up
rm(list=ls())
setwd("C:/Users/Stephen/kaggle-talkingdata/data/extract")
library(dplyr)
library(data.table)

### Encode app_id using app_events

# Read in app_events and app_labels and label_categories
app_events <- fread("app_events.csv", colClasses="character")
app_labels <- fread("app_labels.csv", colClasses="character")
label_categories <- fread("label_categories.csv", colClasses="character")

# Create vector of unique appIds from app_events
appIds <- unique(app_events$app_id)

# Create app ID encoder
app_id_encoder = data.table(data.frame(app_id = appIds, app_id_enc = 1:length(appIds), stringsAsFactors = FALSE))

# Write app ID encoder to csv
write.csv(app_id_encoder, file="../processed/app_id_encoder.csv", row.names=FALSE)

# Create encoded app_events
app_events_final <- app_events %>%
  left_join(app_id_encoder, by="app_id") %>%
  select(event_id, app_id_enc, is_installed, is_active)

# Write app_events_final to csv
write.csv(app_events_final, file="../final-data-files/app_events_final.csv", row.names=FALSE)


### Encode label_id using app_labels

# First filter out app IDs not in app events
app_labels_final <- app_labels %>%
  filter(app_id %in% appIds) %>%
  left_join(app_id_encoder, by="app_id") # join app_id_encoder to get app_id_enc

# Create label ID encoder
labelIds <- unique(app_labels_final$label_id)
label_id_encoder <- data.table(data.frame(label_id = labelIds, label_id_enc=1:length(labelIds), stringsAsFactors = FALSE))

# Write label ID encoder to csv
write.csv(label_id_encoder, file="../processed/label_id_encoder.csv", row.names=FALSE)

# Create encoded app_labels_final
app_labels_final <- app_labels_final %>%
  left_join(label_id_encoder, by="label_id") %>%
  select(app_id_enc, label_id_enc) %>%
  distinct()

# Write app_labels_final to csv
write.csv(app_labels_final, file="../final-data-files/app_labels_final.csv", row.names = FALSE)


### Create label_categories_final using label ID encoder, and create category_enc

# First filter out labels not in app_labels_final
label_categories_final <- label_categories %>%
  inner_join(label_id_encoder, by="label_id")

# Create label category encoder
categories <- unique(label_categories_final$category)
category_encoder <- data.table(data.frame(category=categories, category_enc=1:length(categories), stringsAsFactors = FALSE))

# Write category encoder to csv
write.csv(category_encoder, file="../processed/category_encoder.csv", row.names=FALSE)

# Create encoded label_categories_final
label_categories_final <- label_categories_final %>%
  left_join(category_encoder, by="category") %>%
  select(label_id_enc, category_enc) %>%
  distinct()

# Write label_categories_final to csv
write.csv(label_categories_final, file="../final-data-files/label_categories_final.csv", row.names=FALSE)
