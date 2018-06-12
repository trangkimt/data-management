############### Background: In the field, there is a need for Excel files that
############### facilitate data entry. But these files are not often friendly for
############### the data analyst. I've had partners submit 60+ files at a time.
############### This is not manageable manually via Excel.
############### Using R, we can extract the data we need into a data frame.
###############
############### Question: How do I pull in Excel files and extract data
############### from multiple tabs over multiple worksheets?
###############
############### Solution: Generate a list of files to be extracted. Create a
############### loop that goes through the list. For each file, extract the
############### desired cells, filter out any uncessary data, create identifying
############### information, and combine it with the other files.
###############

## Load R libraries
library(tidyverse)
library(readxl)

## Create relative directories
dat_input <- "../.."

## Get the list of filenames
filenames <- list.files(path="../yourfilepath",pattern="*.xlsx")

## Function to combine files
combined_files <- function(filenames) {
    combined_df <- tibble()
    for (i in 1:length(filenames)) {
        cat("Currently working on file:",i,"\n") # Print progress
        df <- excel_sheets(path=paste0(dat_input,'/',filenames[i])) %>% # Read in data set
            purrr::set_names() %>%
            purrr::map_df(~read_excel(path=paste0(dat_input,'/',filenames[i]) # Map over sheets
                                    ,sheet=.x,
                                    range="B5:C67", # Input the cell ranges to extract
                                    col_names=c('FidItem','Rating'), # Input column names
                                    col_types = c("text","text")), # Column types
                                    .id="Session") %>% # Name of tabs
            filter(Session!='SUMMARY'&Session!='Summary REPORT' # Filter out types of data
                   &Session!='Codes'&!is.na(FidItem)&Rating!='Rating'&FidItem!='Overall')
        schoolname <- str_split(filenames[i],'-') # Create a school name by splitting filename
        df$SCHOOLN <- paste0(schoolname[[1]][2],schoolname[[1]][3]) # Create a school variable
        combined_df <- bind_rows(combined_df,df) # Combine data sets together
    }
    combined_df
}


## Combine files
df_original <- combined_files(filenames)

df <- df_original # Create a new data frame

## List of files that were combined
print(filenames)
