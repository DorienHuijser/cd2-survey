#### About this script #####
#
# This script reads in the data from the CD2-vocabularies-survey and
# from the pilot of that survey. It combines the data from the pilot and the
# survey into 1 combined file for each cohort, and then saves those as .csv 
# in a folder data/processed/YYYY-MM-DD_merged
#
# USING THE SCRIPT
# - Provide the dates from the files to be read in under datetoread_pilot and
#   datetoread_survey
# - Run the script
# 
# Last edit 2022-04-26 by Dorien Huijser
# Inspired by merge.R, written by Nathalie Tamayo Martinez

### Prerequisites ###
# install.packages("data.table")
library(data.table)

# install.package("tidyverse")
library(tidyverse)

datetoread_pilot <- "2022-04-21"
datetoread_survey <- "2022-04-07"

### Read in data ####
filepathsurvey <- file.path(paste0("data/processed/",
                                   datetoread_survey,
                                   "_results/"))
filepathpilot <- file.path(paste0("data/processed/",
                                  datetoread_pilot,
                                  "_pilot_results/"))

pilot_all <- fread(file.path(paste0(filepathpilot, "/",
                                    list.files(path = filepathpilot, 
                                               pattern = "results_all"))))
survey_all <- fread(file.path(paste0(filepathsurvey, "/",
                                    list.files(path = filepathsurvey, 
                                               pattern = "results_all"))))

### Prepare cohort datasets ####
# results in a list variable containing results per cohort
pilot_list <- split(pilot_all, pilot_all$Cohort)
survey_list <- split(survey_all, survey_all$Cohort)

# Trim the instrment names and add columns "survey"  or "pilot"
for(item in 1:length(pilot_list)){
  # Trim instrument names
  pilot_list[[item]]$Instrument_name <- str_trim(pilot_list[[item]]$Instrument_name)
  survey_list[[item]]$Instrument_name <- str_trim(survey_list[[item]]$Instrument_name)
  
  # Add to each col except Instrument_name if it is a pilot or survey variable
  pilot_list[[item]] <- pilot_list[[item]] %>%
    rename_at(vars(!contains("Instrument_name")),
              ~ paste0(., "_pilot"))

  survey_list[[item]] <- survey_list[[item]] %>%
    rename_at(vars(!contains("Instrument_name")),
              ~ paste0(., "_survey")) 

  # Add a column "survey" or "pilot"
  pilot_list[[item]]$pilot <- "pilot"
  survey_list[[item]]$survey <- "survey"
}

### Merge the data from each cohort ###
merged_list <- vector(mode = "list", length = length(pilot_list)) 

for(cohort in 1:length(pilot_list)){
  # Code partly copied from: 
  # https://stackoverflow.com/questions/27167151/merge-combine-columns-with-same-name-but-incomplete-data
  merged_list[[cohort]] <- pilot_list[[cohort]] %>%
    # Basic merge:
    full_join(survey_list[[cohort]], 
              pilot_list[[cohort]],
              by = "Instrument_name") %>%
    arrange(Instrument_name) %>%
    # New column Assessed: when was this measure assessed?
    mutate(Assessed = ifelse((!is.na(survey) & !is.na(pilot)), "both",
                              ifelse(!is.na(survey), "survey",
                                      "pilot"))) %>%
    select(-V1_survey, -V1_pilot, -Cohort_pilot , -survey, -pilot) %>%
    rename(Cohort = Cohort_survey) %>%
    mutate(Cohort = unique(Cohort[!is.na(Cohort)])) %>%
    # Reorder columns
    relocate(Cohort,
             Instrument_name,
             Assessed,
             Keywords_survey,
             Keyword_count_survey,
             Keywords_pilot,
             Keyword_count_pilot,
             Categories_survey,
             Priority_scores_survey,
             Times_mentioned_survey,
             Respondents_survey,
             Categories_pilot,
             Priority_scores_pilot,
             Times_mentioned_pilot,
             Respondents_pilot)
}

### Save the merged files in a separate folder ###
todaysdate <- as.character(Sys.Date())
merged_folder <- file.path(paste0("data/processed/",
                                   todaysdate,
                                   "_merged/"))
dir.create(merged_folder)

# Write each dataframe to a .csv file
for(cohort in 1:length(merged_list)){
  write.csv(merged_list[[cohort]], 
            file.path(paste0(merged_folder, 
                             "/", 
                             "merged_",
                             unique(merged_list[[cohort]]$Cohort)[1],
                             ".csv")), 
            row.names = TRUE)
}