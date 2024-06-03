#
# Load packages
#

if (!require("pacman")) {
  install.packages("pacman")
  library(pacman)
}

pacman::p_load(tidyverse, httr, jsonlite, fs, here, qualtRics, rlist)

#
# Functions
#

# Function to check if a folder exists, and create it if it doesn't
create_folder_if_not_exists <- function(folder_name) {
  if (!dir.exists(folder_name)) {
    dir.create(folder_name)
    message(paste("Folder", folder_name, "created."))
  } else {
    message(paste("Folder", folder_name, "already exists."))
  }
}


# Function to download a .qsf file for a given survey ID
download_qsf <- function(survey_id, survey_name) {
  url <- paste0(base_url, "/API/v3/survey-definitions/", survey_id)
  response <- GET(url, add_headers(.headers = headers), accept("application/vnd.qualtrics.survey.qsf"))
  
  # Check if the request was successful
  if (response$status_code == 200) {
    qsf_file <- paste0("qsf/", survey_name, ".qsf")
    writeBin(content(response, "raw"), qsf_file)
    message(paste("Downloaded .qsf:", survey_name))
  } else {
    message(paste("Failed to download .qsf:", survey_name))
  }
}

#Process a survey - save its data to the data folder, 
#metadata to the metadata folder
#Input the survey_id
process_survey = function(survey_id){
  
  survey1 = fetch_survey(surveyID = survey_id, 
                         save_dir = here("data"), 
                         verbose = TRUE, 
                         force_request = TRUE,
                         include_display_order = T)
  #Save the data for the survey
  s1_mdata = metadata(survey_id)
  s1_qdata = survey_questions(survey_id)
  s1_rdata = survey1

  #Set the filenames for the surveys
  metadata_filename = paste0(here("metadata//"), "metadata-", survey_id, '.yaml')
  qdata_filename = paste0(here("question_data//"), "question_data-", survey_id, '.Rds')
  responsedata_filename = paste0(here("data//"), "response_data-", survey_id, '.Rds')

  #Save all of the data into the appropriate folders
  list.save(s1_mdata, metadata_filename)
  saveRDS(s1_qdata, qdata_filename)
  saveRDS(s1_rdata, responsedata_filename)
  
}

#
# Input needed data
#


# Set up your Qualtrics API credentials
api_token <- "[YOUR API TOKEN HERE]" #Put your api token here, replace the bracketed text
base_url <- "https://[yourdatacenter].qualtrics.com" #Put your datacenter here in the bracketed text -- e.g. for me it is ca1.qualtrics.com



#
# Run below here to download surveys
#


#Create folders we need if they do not already exist
needed_folders = c("data", "metadata", "question_data", "qsf")
lapply(needed_folders, create_folder_if_not_exists)

#Save the API credentials for use with qualtRics
qualtrics_api_credentials(api_key = api_token, 
                          base_url = base_url,
                          install = TRUE)


# Set up headers for the API requests
headers = c(
  "X-API-TOKEN" = api_token,
  "Content-Type" = "application/json"
)

#Helped some people avoid 504 errors
options(qualtrics_timeout = 1200)

# Main script to download all survey qsfs
surveys = all_surveys()

#Save a file with the surveys for mapping ID to name later
backup_name = paste(Sys.time(), "_surveybackups")
backup_name = gsub("[^A-Za-z0-9]", "_", backup_name)
backup_name = paste0(backup_name, ".Rds")
saveRDS(surveys, backup_name)


#Get all the QSFs
for (i in 1:nrow(surveys)) {
  survey_id = surveys$id[i] #Get ID
  survey_name = gsub("[^A-Za-z0-9]", "_", surveys$name[i]) # Clean up survey
  download_qsf(survey_id, survey_name) #Download the qsf
  Sys.sleep(5) #Sleep to avoid getting throttled
}



# Get all the data and metadata

#Save if each survey succeeded or failed
survey_status = rep(NA, nrow(surveys))

#Loop and try to get all surveys
for(i in 1:nrow(surveys)){
  #Print every 5th survey
  ifelse(i%%5==0,print(paste("Processing survey ", i, " of ", nrow(surveys))),"")
  #Set attempts counter and max attempts
  attempts = 0
  max_attempts = 3
  success = FALSE
  #While we have not succeeded and attempts is less than max attempts,
  #run the function
  while(attempts < max_attempts & !success){
    attempts = attempts + 1 #increment attempt counter
    tryCatch({ #try to process the survey
      process_survey(surveys$id[i])
      success = TRUE #if it does process, set success to true
      survey_status[i] = "Complete"
    }, error = function(e) { #otherwise...
      #Print that you got an error
      print(paste("Error on ",i))
      if(attempts < max_attempts){
        print("Retrying...")
      } else {
        print("Failed")
        survey_status[i] = "Failed"
      }
    }
    )
  }
}

#Check if any failed?
sum(survey_status=="Failed")
#Print which failed
print(surveys$id[survey_status=="Failed"])
