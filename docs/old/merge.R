#### About this script #####
#
# This script reads in the data from the CD2-vocabularies-survey and
# from the pilot of that survey. It then combines the data into 1
# file for each cohort and 1 file in which all cohort data is combined
# and saves those as .csv in a folder in 
# data/raw/processed/merged
#
# Script written by Nathalie Tamayo Martinez,
# With edits from Dorien Huijser
# Date: 2022-04-26

### Prerequisites ####
# install.packages("data.table")
library(data.table)

# install.package("tidyverse")
library(tidyverse)

datetoread_pilot <- "2022-04-21"
datetoread_survey <- "2022-04-07"

cohort.names<-c("GenR", "LCID", "NTR", "RADAR", "TRAILS", "YOUth")

# Convert scientific notation (-e) to float in R
options(scipen=999)

###### loop for all cohorts

# in svy dataset
cohort.df<-cohort.names
for (i in 1:length(cohort.df)){
  cohort.df[i]<-paste0("data/processed/2022-04-07_results/2022-04-07_results_", cohort.df[i],".csv") 
}

svylist<- lapply(cohort.df, 
                 function(data){read.table(data, 
                                           header=T, 
                                           sep = ",") })

names(svylist)<-cohort.names

svylist.names<-names(svylist[[1]])[-2]

# paste svy to survey df names
for (j in 1:length(svylist.names)){
  svylist.names[j] <- paste0(svylist.names[j], ".svy")
}

for (i in 1:length(svylist)){
  # Remove spaces before and at the end of the name to match with datataxonomie 
  svylist[[i]]$Instrument_name<-trimws(svylist[[i]]$Instrument_name, which = "both") 
  
  # Remove "number_" 
  for(j in 1:length(svylist[[i]]$Instrument_name)){
    svylist[[i]][j,"Instrument_name"] <- str_split(svylist[[i]][j, "Instrument_name"], 
                                                   "_")[[1]][2] 
  }
  
  svylist[[i]]$svy <- "svy"
}

# in pilot datasets
cohort.df <- cohort.names

for (i in 1:length(cohort.df)){
  cohort.df[i]<-paste0("data/processed/2022-04-21_pilot_results/2022-04-21_pilotresults_", 
                       cohort.df[i],".csv") 
}

pilotlist<- lapply(cohort.df, 
                   function(data){read.table(data, 
                                             header=T, 
                                             sep = ",") })
names(pilotlist) <- cohort.names

pilotlist.names <- names(pilotlist[[1]])[-2]

for (j in 1:length(pilotlist.names)){
  pilotlist.names[j]<-paste0(pilotlist.names[j],".pilot") 
}

for (i in 1:length(pilotlist)){
  #removes spaces before and at the end of the name to match with datataxonomie
  pilotlist[[i]]$Instrument_name<-trimws(pilotlist[[i]]$Instrument_name, which = "both") 
  
  # removes "number_"
  for(j in 1:length(pilotlist[[i]]$Instrument_name)){
    pilotlist[[i]][j,"Instrument_name"] <- str_split(pilotlist[[i]][j,"Instrument_name"], "_")[[1]][2] }
  pilotlist[[i]]$pilot <- "pilot"
}

# merge datasets
for (i in 1:length(svylist)){
  svylist[[i]] <- Reduce(function(x, y) merge(x, y, by="Instrument_name", all=TRUE), 
                         list(svylist[[i]], pilotlist[[i]])) 
  names(svylist[[i]])<-c(names(svylist[[i]])[1], 
                         svylist.names, 
                         names(svylist[[i]])[11], 
                         pilotlist.names, 
                         tail(names(svylist[[i]]),1))
  
  svylist[[i]]$assessed <-"both"
  svylist[[i]][which(svylist[[i]]$svy=="svy" & 
                       is.na(svylist[[i]]$pilot)),  ]$assessed <- "svy only"
  svylist[[i]][which(is.na(svylist[[i]]$svy) & 
                       svylist[[i]]$pilot=="pilot"),]$assessed <- "pilot only"
}

cohort.df<-cohort.names
for (i in 1:length(cohort.df)){
  cohort.df[i]<-paste0("merged_", 
                       cohort.df[i], 
                       ".csv") }

for (i in 1:length(svylist)){
  write.csv(svylist[i], 
            cohort.df[i], 
            row.names=FALSE)
} 

View(svylist[[1]])

### END MERGE ####
# example with one dataset
genrsvy<-read.table("2022-04-07_results/2022-04-07_results_GenR.csv", header=T, sep = ",")

genrsvy.names<-names(genrsvy)[-2]
for (i in 1:length(genrsvy.names)){
  genrsvy.names[i]<-paste0(genrsvy.names[i],".svy") }

genrsvy$Instrument_name<-trimws(genrsvy$Instrument_name, which = "both") #removes spaces before and at the end of the name
for(i in 1:length(genrsvy$Instrument_name)){
  genrsvy[i,"Instrument_name"]<-str_split(genrsvy[i,"Instrument_name"], "_")[[1]][2] }# removes "number_"
genrsvy$svy<-"svy"


genrpilot<-read.table("2022-04-21_pilot_results/2022-04-21_pilotresults_GenR.csv", header=T, sep = ",")

genrpilot.names<-names(genrpilot)[-2]
for (i in 1:length(genrpilot.names)){
  genrpilot.names[i]<-paste0(genrpilot.names[i],".pilot") }
genrpilot$pilot<-"pilot"

genrpilot$Instrument_name<-trimws(genrpilot$Instrument_name, which = "both") #removes spaces before and at the end of the name
for(i in 1:length(genrpilot$Instrument_name)){
  genrpilot[i,"Instrument_name"]<-str_split(genrpilot[i,"Instrument_name"], "_")[[1]][2] }# removes "number_"



genrsvy <- Reduce(function(x, y) merge(x, y, by="Instrument_name", all=TRUE), 
                  list(genrsvy, genrpilot)) 
names(genrsvy)<-c(names(genrsvy)[1], genrsvy.names, names(genrsvy)[11], genrpilot.names, tail(names(genrsvy),1))
rm(genrsvy.names, genrpilot.names)

genrsvy$assessed <-"both"
genrsvy[which(genrsvy$svy=="svy" & is.na(genrsvy$pilot)),  ]$assessed<-"svy only"
genrsvy[which(is.na(genrsvy$svy) & genrsvy$pilot=="pilot"),]$assessed<-"pilot only"
table(is.na(genrsvy$svy), is.na(genrsvy$pilot))  
table(genrsvy$assessed)

# need to check "pilot only", copy them to the "svy", I think the easiest way is manually in the csv file. 
genrsvy[which(genrsvy$assessed=="pilot only"), "Instrument_name"]

write.csv(genrsvy, "GenR_merged.csv", row.names=FALSE, quote=FALSE)