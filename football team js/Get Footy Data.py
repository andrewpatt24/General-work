
# coding: utf-8

# In[1]:

import urllib
import requests
import csv
import math
import re
import htmlmin
from bs4 import BeautifulSoup
from datetime import datetime


# In[2]:

##Get URL output
url = "http://fantasy.premierleague.com/player-list/"
r = requests.get(url)

##Minify html - issues with whitespace
rmin = htmlmin.minify(r.text,remove_empty_space=True)

##Create soup
soup = BeautifulSoup(rmin)



# In[3]:

##Pull out Player types and take just first letter from each for ID.
player_type = soup.find_all('h2')

i=0
for type in player_type:
    player_type[i] = type.string[0]
    i=i+1

print player_type


# In[4]:

##Get get all tables as array
player_tables = soup.find_all("table")

##Make sure we have pulled all 8 tables out
print len(player_tables)


# In[5]:

##Pull out column names, turn to string and add Position
column_name = soup.table.find_all('th')
##pull out string
i=0
for name in column_name:
    column_name[i] = name.string
    i=i+1
##Add position
column_name.append('Position')
print column_name



# In[6]:

###Open csv file to write to
csvfile = open('P:/R repositories/Fantasyfootball/footy_data.csv','wb')
play_list = csv.writer(csvfile,delimiter=',', lineterminator='\n')
play_list.writerow(column_name)
i=0
for t in player_tables:
    
    type_num =  int(math.floor(i/2))
    ptype = [u'G',u'D',u'M',u'F']
    
    untable = t.find_all("td")
    
    for p in range (0,len(untable)/4):
        ##Make sure name is in unicode:
        untable[4*p].string = untable[4*p].string.encode('ascii', 'replace')
        rowtowrite = [untable[4*p].string,untable[4*p+1].string,untable[4*p+2].string,untable[4*p+3].string[1:],ptype[type_num]]
        #print rowtowrite
        play_list.writerow(rowtowrite)
    i=i+1
    
csvfile.close()


# In[8]:

f = open('P:/R repositories/Fantasyfootball/footy_data.csv', 'rb');
for line in f:
        print line;
f.close();


# In[9]:

print player_tables[0].tbody.find_all('tr')[0].find_all('td')


# In[ ]:



