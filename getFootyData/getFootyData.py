import requests
import htmlmin
import json
from bs4 import BeautifulSoup

from datetime import datetime, date, timedelta ##Basic Python

##define unique function
def uniq(seq): 
   # order preserving
   noDupes = []
   [noDupes.append(i) for i in seq if not noDupes.count(i)]
   return noDupes

##define function to scrape fantasy points
def getFootyPointsData(gameweek):
    ##Use this if you want to provide an array of dictionary entries - Use for mongodb
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

    ###Find column names
    column_name = soup.table.find_all('th')
    ##pull out string
    i=0
    for name in column_name:
        column_name[i] = name.string
        i=i+1
    ##Add position
    column_name.append('Position')

    #print column_name


    player_dict = []

    ptype = [u'G',u'D',u'M',u'F']

    j=0
    for t in player_tables:
        #print t
        type_num =  int(j/2)
        #print type_num
        j=j+1
        #print ptype[type_num]
        untable = t.find_all("td")
        #print untable
    
        for p in range (0,len(untable)/4):
            untable[4*p].string = untable[4*p].string.encode('ascii', 'replace')
            rowtowrite = [untable[4*p].string,untable[4*p+1].string,untable[4*p+2].string,untable[4*p+3].string[1:],ptype[type_num]]
            #print rowtowrite
            dict_entry = {"extractdate":str(datetime.today()),
                          "gameweek":int(gameweek),
                          "player": untable[4*p].string,
                          "team": untable[4*p+1].string,
                          "rawpoints": int(untable[4*p+2].string),
                          "cost": float(untable[4*p+3].string[1:]),
                          "position": ptype[type_num]
                          }
            #print dict_entry
            player_dict.append(dict_entry)

    return player_dict
	
api = {"apiKey": "VtFfuf2aI5re-aadY6hN3WNUREmIvnob"}
http_start = "https://api.mongolab.com/api/1/"
http_type = "databases/database1/collections/fantasydata"
headers = {"Content-Type": "application/json"}

## Open up the game weeks - we want to collect the data THE DAY BEFORE each scheduled gameweek start date
gameweek = []
gamedate = []
extractdate = []
#with open("/Users/Andrew/Documents/general-work/football team js/barclays-premier-league.txt","r") as f:
with open("gameweek-dates.txt","r") as f:
    for line in f:
        dat = line.split('\t')
        dat[1] = dat[1].strip('\r\n')
        gameweek.append(dat[0])
        gamedate.append(dat[1])

gameweek.pop(0)
gamedate.pop(0)

for date in gamedate:
    extractdate.append(datetime.strptime(date,'%d/%m/%Y').date()-timedelta(days=1))
    print extractdate


##Get Todays date
tday = datetime.today().date()

##print tday

if tday in extractdate:
    gameweek = extractdate.index(tday)
    print gameweek
    player_dict = getFootyPointsData(gameweek)
    r = requests.post(http_start+http_type, params=api, headers=headers,data = json.dumps(player_dict))

