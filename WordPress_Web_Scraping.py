
# coding: utf-8

# # Web Scraping from Wordpress

# I was testing out some Python code to do webscraping, so I compiled the code here for web scrapping or grabbing content from the internet. 

# In[1]:


## Import libraries
import urllib.request
from bs4 import BeautifulSoup as bs
import os
import requests

from pandas import Series, DataFrame
import pandas as pd
import numpy as np 

import codecs


# In[3]:


## Start of the process to grab all content from a website. 

# First: get all main pages from the website. This website has 11 pages. 
webpages = []
for i in range(1,12):
    site = urllib.request.urlopen('http://www.example.org/page/' + str(i)).read()
    print(i)
    webpages.append(site) 


# In[4]:


# For each page in the webpage list, find all the page content in the div class="post_text_inner".  
all_content = []
for page in webpages:
    page_soup = bs(page,'lxml')
    page_content = page_soup.find_all("div",attrs={"post_text_inner"})
    all_content.append(page_content)

# Flatten the list 
all_content = [post for group in all_content for post in group]   

# Loop over the content and group all the links and titles. The outcome is a list of all urls and titles of posts.  
all_url = []
all_title = []
for post in all_content:
    links = post.findAll("a")
    link = links[0]
    url = link['href']
    title = link['title']
    all_url.append(url)
    all_title.append(title)
print(all_url)
print(all_title)


# In[5]:


# Create a dataframe with Titles and Post links
url_dat = pd.DataFrame(all_url)
title_dat = pd.DataFrame(all_title)

website_dat = pd.concat([title_dat,url_dat],axis=1,join_axes=[title_dat.index])

website_dat.columns = ['Post Title','Hyperlink']

# Export as csv file for reference 
website_dat.to_csv('../Data/website_data.csv')


# In[6]:


# The big loop that generate post content from the entire website. Loop over pages, grab content, and save each post content as text files.
relativepath = "../Data"

for url in all_url:
    post = urllib.request.urlopen(url).read()
    print('Grabbing content from: '+ url)
    soup = bs(post,'lxml')
    title = soup.find("title").text
    body = soup.find("div",class_="post_content").text
    postcontent = title + body
    index = str(all_url.index(url))
    pastename = 'postcontent' + index + '.txt'
    filename = os.path.join(relativepath,pastename)
    with codecs.open(filename,'w','utf-8') as f:
        f.write(postcontent)
        f.close()
    print("Saving content as: postcontent" + index)

