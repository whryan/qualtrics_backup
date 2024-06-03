# Qualtrics Backup Script
A very simple script for backing up all your data and .qsf files from Qualtrics. It will download all of the .qsf files and data for every survey in your account. It should be reasonably easy to use if you can use R. It works for me, but I definitely have not tested it with any other setup than my own. Please be careful whenever you are using an API- this script has no way to do anything but download your own data, but in theory you could mess things up. 

This code uses the package `qualtRics` for downloading the data, and then uses `httr` for downloading the .qsf files, since that functionality wasn't in `qualtRics`. I wrote it pretty quickly, and it could definitely be improved on a lot of fronts (e.g. right now there is no code which accounts for a failure to download a .qsf file initially), but it works well enough that I figured it might be useful for someone else. 

There are two versions of the script: `qualtrics_backup.R`, which I would recommend using first, and `qualtrics_backup_compatibiltity_version.R`, which you can use if you are having issues with your versions of packages not lining up with the ones used to write this code. They are identical, except that the compatibilty_version script loads the libraries differently using the [`groundhog`](https://groundhogr.com/) package.


## 1. Get your Datacenter ID and API key for Qualtrics
Go to user settings:

![image](https://github.com/whryan/qualtrics_backup/assets/8107009/eadd37bb-ad18-44f1-a617-00481149123d)

Get your datacenter ID (it will be something like ca1, yul1, etc) and your API key (it will be a long string). If you don't have an API key, hit Generate Token to get one.

![image](https://github.com/whryan/qualtrics_backup/assets/8107009/6475fa1d-bfcc-4388-aa34-1e7be8fabf6d)

## 2. Set up the script
Download the script in this repo, and put it into a new folder. Use RStudio to make that folder a new R project. At this point, this folder should look something like this example folder:

![image](https://github.com/whryan/qualtrics_backup/assets/8107009/366a5716-bf0f-44b0-803a-7f27ebcdef93)


Then, go into the script and enter in your individual API key and datacenter URL on these two lines:

![image](https://github.com/whryan/qualtrics_backup/assets/8107009/92e7812e-a384-42c2-9baf-5bc5679e6976)

## 3. Run the script
Then, run the whole script. It will first make subfolders to store your survey's data, metadata, question information, and .qsf files. Then it will go through and download all the qsf files, response data, and metadata/question info for each of your surveys. 

## 4. Using/exploring your data
Once you have run it, your folder will look like this:

![image](https://github.com/whryan/qualtrics_backup/assets/8107009/72d787a2-747f-41e6-b639-956c4fe69b47)

If you look at the "qsf" folder, it is a bunch of .qsf files for your surveys, named using the survey name:

![image](https://github.com/whryan/qualtrics_backup/assets/8107009/a813d8bd-2885-42cc-9354-fb890fe6b2f2)

If you look at the "data" folder, it is the data for a bunch of your surveys, saved as .Rds files (R dataframes). They are named using the survey ID of each survey instead of the actual survey name:

![image](https://github.com/whryan/qualtrics_backup/assets/8107009/7bbba1df-7238-4fb8-a8cf-8cb378c45fa5)

To convert between the survey ID and the survey's name, there will be a .Rds file saved in your folder called "[DATE OF BACKUP]_surveybackup". It looks like this, and lets you convert between the name and ID. 

![image](https://github.com/whryan/qualtrics_backup/assets/8107009/eaa83991-8ca1-4868-9e6d-0808ddd5850f)


The metadata folder has a bunch of .yaml files named by survey ID which have all the information about each question in them, though they are missing information about stuff like the survey flow which you can only get from the .qsf files. 

The question_data folder has a bunch of essentially data dictionaries -- they are also named by survey ID, and list the name of Qualtrics questions as well as the question text itself. 


## 5. What if you get errors? 
One thing to check is that you are using a version of the packages consistent with the version that I used to write the script. The output of sessionInfo() for my version of each package is below. If your version of the package does not match, that could be what is causing the error. If you use the version of the R script `qualtrics_backup_compatibility_version.R`, that will use the package [`groundhog`](https://groundhogr.com/) to ensure that your versions of the packages line up with the ones used when writing these scripts.


### sessionInfo() output
```
R version 4.4.0 (2024-04-24 ucrt)
Platform: x86_64-w64-mingw32/x64
Running under: Windows 11 x64 (build 22631)

Matrix products: default


locale:
[1] LC_COLLATE=English_United States.utf8  LC_CTYPE=English_United States.utf8    LC_MONETARY=English_United States.utf8
[4] LC_NUMERIC=C                           LC_TIME=English_United States.utf8    

time zone: America/Los_Angeles
tzcode source: internal

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] rlist_0.4.6.2   qualtRics_3.2.0 here_1.0.1      fs_1.6.4        jsonlite_1.8.8  httr_1.4.7      lubridate_1.9.3
 [8] forcats_1.0.0   stringr_1.5.1   dplyr_1.1.4     purrr_1.0.2     readr_2.1.5     tidyr_1.3.1     tibble_3.2.1   
[15] ggplot2_3.5.1   tidyverse_2.0.0 pacman_0.5.1   

loaded via a namespace (and not attached):
 [1] gtable_0.3.5      compiler_4.4.0    tidyselect_1.2.1  scales_1.3.0      R6_2.5.1          generics_0.1.3   
 [7] curl_5.2.1        sjlabelled_1.2.0  insight_0.19.11   rprojroot_2.0.4   munsell_0.5.1     pillar_1.9.0     
[13] tzdb_0.4.0        rlang_1.1.3       utf8_1.2.4        stringi_1.8.4     timechange_0.3.0  cli_3.6.2        
[19] withr_3.0.0       magrittr_2.0.3    grid_4.4.0        rstudioapi_0.16.0 hms_1.1.3         lifecycle_1.0.4  
[25] vctrs_0.6.5       data.table_1.15.4 glue_1.7.0        rsconnect_1.3.0   fansi_1.0.6       colorspace_2.1-0 
[31] tools_4.4.0       pkgconfig_2.0.3

```
