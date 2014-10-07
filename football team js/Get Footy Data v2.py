
# coding: utf-8

# In[3]:

import urllib
import requests
import csv
import math
import re
import htmlmin
from bs4 import BeautifulSoup
from datetime import datetime


# In[31]:

###Use this code if you want a csv of the file!


##Get URL output
url = "http://fantasy.premierleague.com/player-list/"
r = requests.get(url)

##Minify html - issues with whitespace
rmin = htmlmin.minify(r.text,remove_empty_space=True)

##Create soup
soup = BeautifulSoup(rmin)

##Pull out Player types and take just first letter from each for ID.
player_type = soup.find_all('h2')

i=0
for type in player_type:
    player_type[i] = type.string[0]
    i=i+1

##Get get all tables as array
player_tables = soup.find_all("table")

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
###Open csv file to write to
csvfile = open('P:/R repositories/Fantasyfootball/footy_data.csv','wb')
play_list = csv.writer(csvfile,delimiter=',')
play_list.writerow(column_name)
i=0
for t in player_tables:
    
    type_num =  int(math.floor(i/2))
    ptype = [u'G',u'D',u'M',u'F']
    
    untable = t.find_all("td")
    
    for p in range (0,len(untable)/4):
        ##Make sure name is in unicode:
        untable[4*p].string = untable[4*p].string.encode('ascii', 'replace')
        rowtowrite = [untable[4*p].string,untable[4*p+1].string,untable[4*p+2].string,untable[4*p+3].string[1:],ptype[type_num],5]
        #print rowtowrite
        play_list.writerow(rowtowrite)
    i=i+1
    
csvfile.close()


##Test csv
with open('P:/R repositories/Fantasyfootball/footy_data.csv', 'rb') as f:
    footy_data = csv.reader(f)
    for row in footy_data:
        print(row)


# In[49]:

##Use this if you want to provide an array of dictionary entries - Use for mongodb

###Find column names
column_name = soup.table.find_all('th')
##pull out string
i=0
for name in column_name:
    column_name[i] = name.string
    i=i+1
##Add position
column_name.append('Position')

print column_name


player_dict = []

ptype = [u'G',u'D',u'M',u'F']

j=0
for t in player_tables:
    #print t
    type_num =  int(math.floor(j/2))
    #print type_num
    j=j+1
    #print ptype[type_num]
    untable = t.find_all("td")
    #print untable
    
    for p in range (0,len(untable)/4):
        untable[4*p].string = untable[4*p].string.encode('ascii', 'replace')
        rowtowrite = [untable[4*p].string,untable[4*p+1].string,untable[4*p+2].string,untable[4*p+3].string[1:],ptype[type_num]]
        #print rowtowrite
        dict_entry = {"Player": untable[4*p].string,
                          "Team": untable[4*p+1].string,
                          "Points": int(untable[4*p+2].string),
                          "Cost": float(untable[4*p+3].string[1:]),
                          "Position": ptype[type_num]
                          }
        #print dict_entry
        player_dict.append(dict_entry)

print player_dict[:5]

