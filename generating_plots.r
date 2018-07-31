######################### Background: Creating individual reports can be helpful
######################### for direct service providers in the field to help
######################### improve their program. Individual reports, however,
######################### can be a lot of work and a burden to create in large
######################### amounts. We can create a loop that generates as many
######################### plots as we need.
#########################
######################### Question: How do I generate multiple plots?
#########################
######################### Solution: Get the data set you need for generating
######################### plots. I would recommend testing out the loop on one
######################### case before running the loop.
#########################

## Load R libraries
library(ggplot2)
library(tidyverse)

## Create relative directories
dat_input <- "../../" # Your path name for input files
dat_output <- "../"  # Where your graphs will be placed

## Load your file
dat <- read_csv(file.path(dat_input,'filename.csv'))

## Loop to generate graphs
for (id in sort(unique(dat$ID))) {
    cat(id,'\n') # Prints out the ID number as the loop generates
    graphpath <- file.path(dat_output,paste0('name',id,'graph.png')) # File path and name of plot
    png(file=graphpath,width=840,height=600) # Type of image file and size
    graph <- dat %>% filter(ID == id) %>% # The case ID will be used as the loop id
    ggplot(aes(x=VAR,y=VAR,fill=VAR),ymax=100) + # Choose the X, Y, and if applicable fill variables
        geom_bar(stat="identity",position="stack") + # Select type to represent data points
        scale_fill_manual(values=c("#96b53c","#ffcb35","#e85c3f"), name="ABC") + # Select colors of blocks
        ylim(0,101) + # Set limits of axes
        facet_grid(.~VAR,scales="free") + # Divide plot into subplots based on a grouping variable
        geom_text(aes(label=VAR),stat="identity", # Labels of data points
                  position="stack",color="gray20",size=6,hjust = 0.5, vjust = 1.5)
        ggtitle(paste0(id,'-',unique(dat[which(dat$ID==id),'NAME']),' - TITLE')) + # Title of plot that includes id number
        theme_minimal() + # Type of plot theme
        theme(axis.title.x=element_blank(), # Theme elements
              axis.text.x=element_blank(),
              axis.ticks.x=element_blank(),
              axis.title.y=element_blank(),
              axis.text.y=element_blank(),
              legend.position = "none",
              strip.text.x = element_blank(),
              plot.title = element_blank()) +
    plot(graph) # Plot graphs
    dev.off() # Turns off process
}

## Plots should print to where you had the dat_output value
