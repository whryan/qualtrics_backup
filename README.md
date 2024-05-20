# Qualtrics Backup Script
A very simple script for backing up all your data and .qsf files from Qualtrics.


## 1. Get your Datacenter ID and API key for Qualtrics
Go to user settings:
![image](https://github.com/whryan/qualtrics_backup/assets/8107009/eadd37bb-ad18-44f1-a617-00481149123d)

Get your datacenter ID (it will be something like ca1, yul1, etc) and your API key (it will be a long string). If you don't have an API key, hit Generate Token to get one.
![image](https://github.com/whryan/qualtrics_backup/assets/8107009/6475fa1d-bfcc-4388-aa34-1e7be8fabf6d)

## 2. Set up the script
Download the script in this repo, and put it into a new folder. Use RStudio to make that folder a new R project. 

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

