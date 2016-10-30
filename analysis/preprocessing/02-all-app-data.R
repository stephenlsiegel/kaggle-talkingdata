# Set up
rm(list=ls())
setwd("C:/Users/Stephen/kaggle-talkingdata/data/")
library(dplyr)
library(data.table)


### Read in data from final-data-files

events_f <- fread("./final-data-files/events_final.csv", colClasses="character")
app_events_f <- fread("./final-data-files/app_events_final.csv", colClasses="character")
app_labels_f <- fread("./final-data-files/app_labels_final.csv", colClasses="character")
label_categories_f <- fread("./final-data-files/label_categories_final.csv", colClasses="character")

### Make master data frame of device ID, app ID, is_active, label ID, category

start <- Sys.time() # Start a timer

all_app_data <- app_events_f %>%
  inner_join(events_f, by="event_id") %>%
  distinct(event_id, app_id_enc, is_installed, is_active, device_id_enc) %>%
  select(device_id_enc, app_id_enc, is_installed, is_active) %>%
  left_join(app_labels_f, by="app_id_enc") %>%
  distinct(device_id_enc, app_id_enc, is_installed, is_active, label_id_enc) %>% 
  left_join(label_categories_f, by="label_id_enc") %>%
  distinct(device_id_enc, app_id_enc, is_installed, is_active, label_id_enc, category_enc)

end <- Sys.time() # End the timer

end-start # Print out time difference, last run was 1.85508 mins

# Write to csv
write.csv(all_app_data, file="./processed/all_app_data.csv", row.names=FALSE)
save(all_app_data, file="./processed/all_app_data.rda")


# Clear up some memory for more manipulations
rm(app_events_f, app_labels_f, events_f, label_categories_f, start, end)


### Create data frame for app_id sparse matrix (columns: device_id_enc, app_id_enc)

app_id_sparse <- all_app_data %>%
  select(device_id_enc, app_id_enc) %>%
  distinct(device_id_enc, app_id_enc)

write.csv(app_id_sparse, file="./processed/app-data-sparse/app_id_sparse.csv", row.names=FALSE)

### Create data frame for app_id_active sparse matrix (columns: device_id_enc, app_id_enc. filter: is_active==1)

app_id_active_sparse <- all_app_data %>%
  filter(is_active==1) %>%
  select(device_id_enc, app_id_enc) %>%
  distinct(device_id_enc, app_id_enc)

write.csv(app_id_active_sparse, file="./processed/app-data-sparse/app_id_active_sparse.csv", row.names=FALSE)

### Create data frame for category (columns: device_id_enc, category_enc)

category_sparse <- all_app_data %>%
  select(device_id_enc, category_enc) %>%
  distinct(device_id_enc, category_enc)

write.csv(category_sparse, file="./processed/app-data-sparse/category_sparse.csv", row.names=FALSE)

### Create data frame for category active (columns: device_id_enc, category_enc. filter: is_active==1)

category_active_sparse <- all_app_data %>%
  filter(is_active==1) %>%
  select(device_id_enc, category_enc) %>%
  distinct(device_id_enc, category_enc)

write.csv(category_active_sparse, file="./processed/app-data-sparse/category_active_sparse.csv", row.names=FALSE)
