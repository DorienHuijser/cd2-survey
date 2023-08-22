# Vocabularies Survey - Connecting Data in Child Development (CD2)

This repository contains the code to process raw data from the CD2 vocabularies 
survey for each participating cohort study into a much more readable and useful 
format. It also contains the results, but for privacy reasons (email addresses, 
IP addresses and demographic information), the raw survey data is not published 
here. 

Below you will find what this survey is about and how the data are processed.

You can read the script in html-form 
[here](docs/CD2-vocabularies-survey-v1.2.html). The script itself is written in 
Rmd and can be found [here](src/CD2-vocabularies-survey-v1.3.Rmd)

**Table of contents**
  * [About the CD2 project](#about-the-cd2-project)
  * [About the CD2 vocabularies survey](#about-the-cd2-vocabularies-survey)
  * [Structure of the survey](#structure-of-the-survey)
  * [Structure of the datafile](#structure-of-the-datafile)
  * [Functionality of this code](#functionality-of-this-code)
  * [Dependencies](#dependencies)
  * [License](#license)
  * [Contributing and contact](#contributing-and-contact)

## About the CD2 project
Connecting Data in Child Development (CD2) is an infrastructure project funded 
by the Platform Digitale Infrastructuur - Social Sciences and Humanities 
(PDI-SSH). The project aims to harmonize the metadata from 6 Dutch developmental 
child cohort studies within the 
[Consortium on Individual Development (CID)](https://individualdevelopment.nl/). 
The end result of this harmonization is an online portal where one can find, 
among others, what data was collected in these cohort studies and how to get 
access to them (of note, the portal does not contain actual data). 
Additionally, the metadata underlying this web portal should be findable not only 
through the web portal itself, but also through existing infrastructures such as 
ODISSEI and HEALTH-RI. You can read the full
[project description here](https://pdi-ssh.nl/nl/funded-projects-2/gehonoreerde-projecten/connecting-data-in-child-development-cd2/).

## About the CD2 vocabularies survey
As part of making the CID metadata findable, the individual measures are 
labelled with **keywords** and **categories**. Because there is no fully 
suitable controlled vocabulary available that fits the wealth of data in CID, 
existing vocabularies are complemented with our own. To create such a 
vocabulary, input from the entire CID community was needed to help us determine 
the relevant keywords and categories that researchers would use to search for 
all the different types of data within CID. The CD2 vocabularies survey 
therefore asked respondents (researchers) to 1) provide keywords and 2) choose 
relevant categories for a subset of experiments within their own cohort.

## Structure of the survey
The full survey can be found in `CD2_vocabularies_survey_questions.pdf` in the 
`assets` folder of this repository. Importantly, depending on their cohort, 
respondents answered 2 questions which were **repeated for 25 measures of their 
cohort** (e.g., experiments, questionnaires, etc.) using Qualtrics's Loop and 
Merge functionality:

- `Which keywords would you assign to this measure? Please separate your 
keywords with a comma` (open text question)
- `Choose one or multiple categories that you think fit best and rank them 
according to their relevance using numbers (1 = most relevant, 2 = second most 
relevant, etc.).` (ranking question with 3 additional text fields in which 
custom categories could be provided)

## Structure of the datafile
The data file resulting from the Qualtrics survey is an extremely wide datafile, 
because for each of the 6 cohorts, there was a total of around 80-200 measures 
(dependent on the cohort) that could be shown. Although the survey for an 
individual respondent would only show a random selection of 25 of these, the 
resulting datafile contains them all and is > 13000 columns wide. Not exactly 
readable!

The datafile contains 3 main types of variables:

1. Keywords question: `[instrument_number]_[cohort]_Keywords`: Keywords string 
response separated by commas.
2. Category rankings: `[instrument_number]_[cohort]_Cat_[category-number]`: The 
response is a number delineanating the priority given to the category.
3. Category custom categories: `[instrument_number]_[cohort]_Cat_1[2/3/4]_TEXT`: 
A string indicating the custom category that was provided.

## Functionality of this code
The code can be found in the `src` folder and does the following:

1. Set the parameters (e.g., filename, additional intrument numbers files, 
cohort names, etc.).
2. Read in the data.
3. Create mappings: lists of numbers and instrument names.
4. For each cohort, put the data from the Keywords question in a flat, usable 
format.
5. For each cohort, put the data from the Category ranking question in a flat, 
usable format.
6. For each cohort, combine the processed data from the Keywords and Category 
ranking questions into one processed datafile. These can be found in 
`data/processed`.

## Dependencies

The code is located in the `CD2-vocabularies-survey-v1.3.Rmd` file located in 
the `src` folder. You need the following to run the code:

- The raw data (not included in this repository)
- The instrument number files as used during the survey (located in 
`assets/instrumentnrs`)
- R, RStudio and git
- The R packages `rmarkdown`, `data.table`, `tidyverse`, `wordcloud2`, `webshot`,
and `htmlwidgets`

All relevant files are read in by the code. Because the code is R Markdown, you 
can find a lot of explanation about how the code works in there as well.

Feel free to reuse this code by 
[cloning the repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository). 
Warning: you will most likely have to adapt the code tremendously, since the 
code is currently tailored towards this specific use case. 

## License
This project is licensed under the terms of the [MIT License](/LICENSE.md)

## Contributing and contact
This repository is not actively maintained at the moment. However, if you see a 
bug, feel free to open an issue or a pull request in this repository. 
Alternatively, feel free to [email me](https://www.uu.nl/staff/DCHuijser) for 
comments or questions.