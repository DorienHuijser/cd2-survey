# Vocabularies Survey Connecting Data in Child Development (CD2)

Hello! This repository contains the code to process raw data from the CD2 vocabularies survey for each participating cohort study into a much more readable and useful format. It also contains these results, but for privacy reasons (email addresses, IP addresses and demographic information), the raw survey data is not published here. 

Below you will find what this survey is about and how the data are processed.

## About the CD2 project
Connecting Data in Child Development (CD2) is an infrastructure project funded by the Platform Digitale Infrastructuur - Social Sciences and Humanities. The project aims to harmonize the metadata from 6 Dutch developmental child cohort studies within the <a href="https://individualdevelopment.nl/" target="_blank">Consortium on Individual Development (CID)</a>. The end result of this harmonization will consist of an online portal where one can find, among others, what data was collected in these cohort studies and how to get access to them (of note, the portal will not contain actual data). Additionally, the metadata underlying this web portal will be findable not only through the web portal itself, but also through existing infrastructures such as ODISSEI (for the social scientific metadata) and HEALTH-RI (for the biomedical metadata). You can read the <a href="https://pdi-ssh.nl/nl/funded-projects-2/gehonoreerde-projecten/connecting-data-in-child-development-cd2/" target="_blank">project description here</a>.

## About the CD2 vocabularies survey
As part of making the CID metadata findable, data will be labeled with **keywords** and **categories**. Because there is no fully suitable controlled vocabulary available that fits the wealth of data in CID, we plan to complement existing vocabularies with our own. To create such a vocabulary, input from the entire CID community is needed to help us determine the relevant keywords and categories that researchers use to search for all the different types of data within CID. The CD2 vocabularies survey therefore asks the respondent (CID researcher) to 1) provide keywords and 2) choose relevant categories for a subset of experiments within their own cohort.

## Structure of the survey
The full survey can be found in `CD2_vocabularies_survey_qusetions.pdf` in the `docs` folder. Importantly, depending on their cohort, respondents answer 2 questions which are **repeated for 25 measures/instruments of their cohort** (e.g., experiments, questionnaires, etc.) using Qualtrics's Loop and Merge functionality:
- `Which keywords would you assign to this measure? Please separate your keywords with a comma` (open text question)
- `Choose one or multiple categories that you think fit best and rank them according to their relevance using numbers (1 = most relevant, 2 = second most relevant, etc.).` (ranking question with 3 additional custom fields)

## Structure of the datafile
The data file is an extremly wide datafile, because for each of the 6 cohorts, there is a total of around 80-200 measures/instruments (differs per cohort) that could be shown. Although the survey for an individual respondent will only show a random selection of 25 of these, the resulting datafile contains them all and is > 13000 columns wide. Not exactly readable!

The datafile contains 3 main types of variables:
1. Keywords question: `[instrument_number]_[cohort]_Keywords`: Keywords string response separated by commas.
2. Category rankings: `[instrument_number]_[cohort]_Cat_[category-number]`: The response is a number delineanating the priority given to the category.
3. Category custom categories: `[instrument_number]_[cohort]_Cat_1[2/3/4]_TEXT`: A string indicating the custom category that was provided.

## Functionality of this code
The code can be found in `docs` and does the following:
1. Set the parameters (e.g., filename, additional intrument numbers files, cohort names, etc.).
2. Read in the data.
3. Create mappings: lists of numbers and instrument names.
4. For each cohort, put the data from the Keywords question in a flat, usable format.
5. For each cohort, put the data from the Category rankinkg question in a flat, usable format.
6. For each cohort, combine the procesed data from the Keywords and Category ranking questions into one processed datafile. These can be found in `data/processed`

## Dependencies
Dependencies used can be found in the `renv.lock` file.

## Installation
Feel free to reuse this code by <a href="https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository" target="_blank">cloning the repository</a>. Warning: you will most likely have to adapt the code tremendously, since the code is currently tailored towards this specific use case. 

## Usage
The code is located in the `CD2-vocabularies-survey-v1.1.Rmd` file located in the `docs` folder. You need the following to run the code:
- R or R Studio
- The raw datafile (not included in this public repository)
- The instrument number files as used during the survey (located in `docs/instrumentnrs`)

All relevant files are read in by the code. Because the code is R Markdown, you can find a lot of explanation about how the code works in there as well.

## License
This project is licensed under the terms of the [MIT License](/LICENSE.md)

## Contributing and contact
To contribute, feel free to open an issue or a pull request in this repository. Alternatively, you can email <a href="https://www.uu.nl/staff/DCHuijser" target="_blank">Dorien Huijser</a> for comments or questions.
