#### About this script #####
#
# This script reads in the data from the CD2-vocabularies-survey and
# from the pilot of that survey. It then combines the data into 1
# file for each cohort and 1 file in which all cohort data is combined
# and saves those as .csv in a folder in 
# data/raw/processed/YYYY-MM-DD_results_combined
#
# Last edit 2022-04-22 by Dorien Huijser

### Prerequisites ###
# install.packages("data.table")
library(data.table)

# install.package("tidyverse")
library(tidyverse)

datetoread_pilot <- "2022-04-21"
datetoread_survey <- "2022-04-07"

#cohorts <- c("TRAILS", "GenR", "RADAR", "LCID", "YOUth", "NTR")

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

### Separate cohorts ####
# results in a list variable containing results per cohort
pilot_list <- split(pilot_all, pilot_all$Cohort)
survey_list <- split(survey_all, survey_all$Cohort)



### Merge the data from each cohort ###
merged_list <- vector(mode = "list", length = length(pilot_list)) 

for(cohort in 1:length(pilot_list)){
  # Code copied from: https://stackoverflow.com/questions/27167151/merge-combine-columns-with-same-name-but-incomplete-data
  merged_list[[cohort]] <- pilot_list[[cohort]] %>%
    full_join(survey_list[[cohort]], 
              by = intersect(colnames(pilot_list[[cohort]]), 
                             colnames(survey_list[[cohort]]))) %>%
    group_by(Instrument_name) %>%
    #summarize_all(na.omit) %>%
    filter(!(Keywords == "") & !is.na(Categories)) %>%
    arrange(Instrument_name)
}

# ^ This adds a row for each measure that is scored in both the survey and the
# pilot and does not distinguish yet between the pilot and survey data -->
# such distinction should be made, preferably so that each (matching) measure
# takes up only 1 row instead of sometimes 2.


## TO DO FROM HERE ONWARDS ###
### Save the merged files in a separate folder ###
todaysdate <- as.character(Sys.Date())
results_folder <- file.path(paste0("data/processed/",
                                   todaysdate,
                                   "_merged_results/"))
dir.create(results_folder)

# Write each dataframe to a .csv file
for(cohort in merged_list){
  write.csv(get(paste0("results_",cohort)), 
            file.path(paste0(results_folder, 
                             "/", 
                             todaysdate,
                             "_mergedresults_",cohort,".csv")), row.names = TRUE)
}
