#####################STEP 1#########################
##########Load libraries############################
#########Install packages if not already############
install.packages("dplyr", type="source")
install.packages("readxl")
library(dplyr)
library(readxl)

#######Assign local variables#######################
#######Useful for when a variable needs#############
#######to change every run, like date###############
date <- "092121"
desktop <- "C:/Users/Desktop" #provide location of file

#########STEP 2: Read in files#######################
dat <- read_xlsx(paste0(desktop,"excel_file_name.xlsx"))

dat2 <- filter(dat,var>=1) ###filter out by any variable 

#########STEP 3: clean the file in various ways####
########De-duplicate the file by ##################
########using a unique identifier#################
dat2$DUP <- duplicated(dat2$id)

dat3 <-  filter(dat2,DUP==FALSE) #filter out dup

##summarize the data based on a grouping variable
dat4 <- group_by(dat3,id) %>% 
  summarise(s_var=min(var),
            s_var2=max(var2))

###join existing file with another file 
comp <- left_join(dat4,file,by=c("var")) 

comp <- select(comp,var,var2,var3) #select variables of interest

###Recode data and add columns
tab <- table(comp$var) #view what's available for the variable
tab

##create a new variable and recode existing data into new variable
comp$r_var <- "Unknown"
comp$r_var[which(comp$var=="MO")] <- "Missouri"

comp$r_ag <- "Unknown"
comp$r_ag[comp$ag<=11] <- "Less than 12"

########STEP 4: Export file######
colnames(comp)
final <- select(comp,r_var,r_ag,var3,var4)

#write out file
write_xlsx(comp,paste0("folder/filename",date,".xlsx"))






