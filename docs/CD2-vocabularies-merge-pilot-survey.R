#### About this script #####
#
# This script reads in the data from the CD2-vocabularies-survey and
# from the pilot of that survey. It then combines the data into 1
# file for each cohort and 1 file in which all cohort data is combined
# and saves those as .csv in a folder in 
# data/raw/processed/YYYY-MM-DD_results_combined
#
# Last edit 2022-04-21 by Dorien Huijser

### Prerequisites ###
# install.packages("data.table")
library(data.table)

# install.package("tidyverse")
library(tidyverse)

datetoread_pilot <- "2022-04-21"
datetoread_survey <- "2022-04-07"

cohorts <- c("TRAILS", "GenR", "RADAR", "LCID", "YOUth", "NTR", "all")

### Read in data ####
filepathsurvey <- file.path(paste0("data/processed/",
                                   datetoread_survey,
                                   "_results/"))
filepathpilot <- file.path(paste0("data/processed/",
                                  datetoread_pilot,
                                  "_pilot_results/"))

listfilessurvey <- list.files(path = filepathsurvey, pattern = "*.csv")
listfilespilot <- list.files(path = filepathpilot, pattern = "*.csv")

# Read in all data files as separate R objects
for (filenr in 1:length(listfilessurvey)){
  assign(gsub("^[0-9]+-[0-9]+-[0-9]+_|*.csv", 
              "", 
              listfilessurvey[filenr]), 
         fread(file.path(filepathsurvey, 
                         listfilessurvey[filenr])))
  
  assign(gsub("^[0-9]+-[0-9]+-[0-9]+_|*.csv", 
              "", 
              listfilespilot[filenr]), 
         fread(file.path(filepathpilot, 
                         listfilespilot[filenr])))
}

# Put names of files in a character vector
objectspilot <- character(0)
objectssurvey <- character(0)

for(cohort in 1:length(cohorts)) { 
  objectspilot[cohort] <- paste0("pilotresults_", cohorts[cohort])
  objectssurvey[cohort] <- paste0("surveyresults_",cohorts[cohort])
}

### Merge the data from each cohort ###
# Delete numbers from start of instrument_name



# Probeersels
objectspilot %>%
  apply(mutate(Instrument_name = 
                 str_replace_all(as.character(Instrument_name), 
                                 "^[0-9]+_", 
                                 "")))
      
# werkt niet
for(file in objectspilot){
  file %>%
    mutate(Instrument_name = str_replace_all(as.character(Instrument_name), 
                                          "^[0-9]+_", ""))
}

results_all$Instrument_name <- str_replace_all(as.character(results_all$Instrument_name), 
                                               "^[0-9]+_", "")


### Save the merged files in a separate folder ###
todaysdate <- as.character(Sys.Date())
results_folder <- file.path(paste0("data/processed/",
                                   todaysdate,
                                   "_merged_results/"))
dir.create(results_folder)

# Write each dataframe to a .csv file
for(cohort in cohorts){
  write.csv(get(paste0("results_",cohort)), 
            file.path(paste0(results_folder, 
                             "/", 
                             todaysdate,
                             "_mergedresults_",cohort,".csv")), row.names = TRUE)
}


# OLD
write.csv(results_TRAILS, file.path(paste0(results_folder, "/", todaysdate, 
                                           "_mergedresults_TRAILS.csv")), row.names = TRUE)
write.csv(results_GenR, file.path(paste0(results_folder, "/", todaysdate,
                                         "_pilotresults_GenR.csv")), row.names = TRUE)
write.csv(results_RADAR, file.path(paste0(results_folder, "/", todaysdate, 
                                          "_pilotresults_RADAR.csv")), row.names = TRUE)
write.csv(results_LCID,file.path(paste0(results_folder, "/", todaysdate,
                                        "_pilotresults_LCID.csv")), row.names = TRUE)
write.csv(results_YOUth,file.path(paste0(results_folder, "/", todaysdate,
                                         "_pilotresults_YOUth.csv")), row.names = TRUE)
write.csv(results_NTR,file.path(paste0(results_folder, "/", todaysdate, 
                                       "_pilotresults_NTR.csv")), row.names = TRUE)

# Combine all cohorts in 1 file (delete instrument nrs for easier analysis)
results_all <- rbind(results_TRAILS,results_GenR, results_RADAR, 
                     results_LCID, results_YOUth, results_NTR)

results_all$Instrument_name <- str_replace_all(as.character(results_all$Instrument_name), 
                                               "^[0-9]+_", "")

write.csv(results_all, file.path(paste0(results_folder, "/", todaysdate, 
                                        "_pilotresults_all.csv")),row.names = TRUE)