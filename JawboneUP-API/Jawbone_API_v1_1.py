
# coding: utf-8

# In[47]:

###From python-jawbone-up repository
import urllib
import requests
import webbrowser
import json
import string


###nested Endpoints dictionary for lookup
##Starts with 
##https://jawbone.com/nudge/api/v.1.1/ 
##and ends with below endpoint

endpoints = {
	'bandevents':{
		'get': 'users/@me/bandevents'
		},
	'body':{
		'get': 'users/@me/body_events',
		'idget': 'body_events/{xid}',
		'post': 'users/@me/body_events',
		'delete': 'body_events/{xid}'
		},
	'customevents':{
		'get': 'users/@me/generic_events',
		'post': 'users/@me/generic_events',
		'idpost': 'generic_events/{xid}/partialUpdate',
		'delete': 'generic_events/{xid}'
		},
	'goals': {
		'get': 'users/@me/goals',
		'post': 'users/@me/goals'
		},
	'meals': {
		'get': 'users/@me/meals',
		'idget': 'meals/{xid}',
		'post':	'users/@me/meals',
		'idpost':	'meals/{xid}/partialUpdate',
		'delete': 'meals/{xid}'
		},
	'mood': {
		'get': 'users/@me/mood',
		'idget': 'mood/{xid}',
		'post': 'users/@me/mood',
		'delete': 'mood/{xid}'
		},
	'moves': {	
		'get': 'users/@me/moves',
		'idget': 'moves/{xid}',
		'getgraph': 'moves/{xid}/image',
		'getticks': 'moves/{xid}/ticks'
		},
	'refreshtoken': {	
		'get': 'users/@me/refreshToken'
		},
	'usersettings': {	
		'get': 'users/@me/settings'
		},
	'sleeps':{	
		'get': 'users/@me/sleeps',
		'idget': 'sleeps/{xid}',
		'getgraph': 'sleeps/{xid}/image',
		'getticks': 'sleeps/{xid}/ticks',
		'post': 'users/@me/sleeps',
		'delete': 'sleeps/{xid}'
		},
	'timezone': {	
		'get': 'users/@me/timezone'
		},
	'trends': {	
		'get': 'users/@me/trends'
		},
	'userinformation': {
		'get': 'users/@me',
		'getfriends': 'users/@me/friends'
		},
	'workouts': {	
		'get': 'users/@me/workouts',
		'idget': 'workouts/{xid}',
		'getgraph': 'workouts/{xid}/image',
		'getticks': 'workouts/{xid}/ticks',
		'post': 'users/@me/workouts',
		'idpost': 'workouts/{xid}/partialUpdate',
		'delete': 'workouts/{xid}'
		}
	}


class Jawbone(object):
    """
    The Jawbone  API python wrapper - edited for v1.1.
    """

    def __init__(self, client_id, client_secret, redirect_uri, scope = ''):

        self.client_id = client_id
        self.client_secret = client_secret
        self.redirect_uri = redirect_uri
        self.scope = scope or 'basic_read'
        self.base_url = "https://jawbone.com/"


    def auth(self, scope=None): 
        '''
        Initial authentication for Jawbone
        '''
        scope = "basic_read extended_read all_write"

        scope_access= {
            'all_read' : "basic_read extended_read location_read friends_read mood_read move_read sleep_read meal_read weight_read generic_event_read",
            'all_write' : "mood_write move_write sleep_write meal_write weight_write generic_event_write"
            }
  

        if (scope!=None):
            splitscope =  string.split(scope," ")
            
            i=0
            for sc in splitscope:
                if (sc == "all_read"):
                    splitscope[i] = scope_access['all_read']
                if (sc == "all_write"):
                    splitscope[i] = scope_access['all_write']
                i += 1
            scope = string.join(splitscope," ")
        
        params = { 
            'scope'         : scope or self.scope,
            'client_id'     : self.client_id,
            'redirect_uri'  : self.redirect_uri,
            'response_type' : 'code'  
        }

        context = {
            'base_url': self.base_url,
            'params'  : urllib.urlencode(params)
        }

        # A hard redirect to the authorize page. 
        # User would see either the login to jawbone page, 
        # opens browser to authenticate - Still need a way to capture the redirect url
        webbrowser.open('{base_url}auth/oauth2/auth/?{params}'.format(**context), new=2, autoraise=True)

    def access_token(self, code, grant_type='authorization_code'):
        '''
        Get the access code for a user with a auth code.
        '''

        params = {
            'code'          : code,
            'client_id'     : self.client_id,
            'client_secret' : self.client_secret,
            'grant_type'    : grant_type
        }

        context = {
            'base_url': self.base_url,
            'params'  : urllib.urlencode(params)
        }
 
        token_url = '{base_url}auth/oauth2/token/?{params}'.format(**context)

        res = requests.get(token_url)
        return res.json()


    def api_call(self, access_token, endpoint, **kwargs):
        '''
        Documentation URL: https://jawbone.com/up/developer/endpoints
        Example 
        endpoint: nudge/api/v.1.0/users/@me/sleep
        '''

        context = {
            'base_url': self.base_url,
            'endpoint': endpoint
        }
        
        api_call = '{base_url}{endpoint}'.format(**context)
        
        headers = {
            'Authorization': 'Bearer '+access_token,
            'Host': 'jawbone.com',
            'X-Target-URI': 'https://jawbone.com',
            'Accept': 'application/json',
            'Connection': 'Keep-Alive'
        }
        res = requests.get(api_call, headers=headers)
        
        if res.status_code == 200:
            return res.json()

        return {
            'error': res.reason, 
            'status_code': res.status_code  
        }
    
    def refresh_token_call(self, refresh_code):
        '''
        Get the new access code for a refresh token

        Parse the response, and update your database entries
        with the new auth credentials.
        '''

        return self.access_token(self, refresh_code, 'refresh_token')


# In[48]:


client_id = 'jfZVZP40zF0'
client_secret = 'ab60dea0d6ccff8bbc0579e149f02000e2c7fae7'
redirect_uri = 'http://www.dinnerwithdata.com'
scope = 'all_read'


jb = Jawbone(client_id, client_secret, redirect_uri, scope=scope)


# In[49]:

jb.auth()
##http://www.dinnerwithdata.com/?code=aV1SI82xvTrcN2maf9EF5Gna6cgo2_v-VUUjAsDSfhg__f2BSTRUWvj10-ItJz4R9WnvKI-GaClbU4JadEd7yCHvFlpwU6ifgf1sDnoQ8zQXdB24evV0_J9g7lSkKu4wpmp8xnxzsxVNPYd6a9KjczCyNor6N56xY9oIzrJaLtQBSk6FEqAfvuTyU0ebYSFdBNUxhOnTZhw


# In[30]:

code = 'aV1SI82xvTrcN2maf9EF5Gna6cgo2_v-VUUjAsDSfhg__f2BSTRUWvj10-ItJz4R9WnvKI-GaClbU4JadEd7yCHvFlpwU6ifgf1sDnoQ8zQXdB24evV0_J9g7lSkKu4wpmp8xnxzsxVNPYd6a9KjczCyNor6N56xY9oIzrJaLtQBSk6FEqAfvuTyU0ebYSFdBNUxhOnTZhw'

print code

token = jb.access_token(code)

print token
##Add token to mongolab database
api = {"apiKey": "VtFfuf2aI5re-aadY6hN3WNUREmIvnob"}
http_start = "https://api.mongolab.com/api/1/"
http_type = "databases/database1/collections/jawbone_meta"
headers = {"Content-Type": "application/json"}

r = requests.post(http_start+http_type, params=api, headers=headers,data = json.dumps(token))
r.text


# In[31]:

####Pull access token from jawbone_meta
api = {"apiKey": "VtFfuf2aI5re-aadY6hN3WNUREmIvnob"}
http_start = "https://api.mongolab.com/api/1/"
http_type = "databases/database1/collections/jawbone_meta"
jb_meta = requests.get(http_start+http_type, params=api)
print jb_meta.text


# In[32]:

access_token = eval(jb_meta.text)[0]['access_token']

print 'Bearer '+access_token


# In[36]:

endpoint = 'nudge/api/v.1.1/users/@me/sleeps'
response = jb.api_call(access_token, endpoint)

print response


# In[49]:




# In[ ]:




# In[19]:

endpoints = {
	'bandevents':{
		'get': 'users/@me/bandevents'
		},
	'body':{
		'get': 'users/@me/body_events',
		'idget': 'body_events/{xid}',
		'post': 'users/@me/body_events',
		'delete': 'body_events/{xid}'
		},
	'customevents':{
		'get': 'users/@me/generic_events',
		'post': 'users/@me/generic_events',
		'idpost': 'generic_events/{xid}/partialUpdate',
		'delete': 'generic_events/{xid}'
		},
	'goals': {
		'get': 'users/@me/goals',
		'post': 'users/@me/goals'
		},
	'meals': {
		'get': 'users/@me/meals',
		'idget': 'meals/{xid}',
		'post':	'users/@me/meals',
		'idpost':	'meals/{xid}/partialUpdate',
		'delete': 'meals/{xid}'
		},
	'mood': {
		'get': 'users/@me/mood',
		'idget': 'mood/{xid}',
		'post': 'users/@me/mood',
		'delete': 'mood/{xid}'
		},
	'moves': {	
		'get': 'users/@me/moves',
		'idget': 'moves/{xid}',
		'getgraph': 'moves/{xid}/image',
		'getticks': 'moves/{xid}/ticks'
		},
	'refreshtoken': {	
		'get': 'users/@me/refreshToken'
		},
	'usersettings': {	
		'get': 'users/@me/settings'
		},
	'sleeps':{	
		'get': 'users/@me/sleeps',
		'idget': 'sleeps/{xid}',
		'getgraph': 'sleeps/{xid}/image',
		'getticks': 'sleeps/{xid}/ticks',
		'post': 'users/@me/sleeps',
		'delete': 'sleeps/{xid}'
		},
	'timezone': {	
		'get': 'users/@me/timezone'
		},
	'trends': {	
		'get': 'users/@me/trends'
		},
	'userinformation': {
		'get': 'users/@me',
		'getfriends': 'users/@me/friends'
		},
	'workouts': {	
		'get': 'users/@me/workouts',
		'idget': 'workouts/{xid}',
		'getgraph': 'workouts/{xid}/image',
		'getticks': 'workouts/{xid}/ticks',
		'post': 'users/@me/workouts',
		'idpost': 'workouts/{xid}/partialUpdate',
		'delete': 'workouts/{xid}'
		}
	}

xidd = {'xid':'123'}
print xidd
print endpoints['moves']['idget']
print endpoints['moves']['idget'].format(**xidd)


# In[ ]:




# In[20]:

#####UNDER CONSTRUCTION


endpoints = {
    'bandevents':{
        'get': 'users/@me/bandevents'
        },
    'body':{
        'get': 'users/@me/body_events',
        'idget': 'body_events/{xid}',
        'post': 'users/@me/body_events',
        'delete': 'body_events/{xid}'
        },
    'workouts': {
        'get': 'users/@me/workouts',
        'idget': 'workouts/{xid}',
        'getgraph': 'workouts/{xid}/image',
        'getticks': 'workouts/{xid}/ticks',
        'post': 'users/@me/workouts',
        'idpost': 'workouts/{xid}/partialUpdate',
        'delete': 'workouts/{xid}'
        }
    }

def api_call(self, access_token, endpoint,request_type,xid="", **kwargs):
        '''
        Documentation URL: https://jawbone.com/up/developer/endpoints
        Example 
        endpoint: nudge/api/v.1.0/users/@me/sleep
        '''
        
        if xid != "":
            xidd = {'xid':xid}
            full_endpoint = 'nudge/api/v.1.1/'+endpoints[endpoint][request_type].format(**xidd)
        else:
            full_endpoint = 'nudge/api/v.1.1/'+endpoints[endpoint][request_type]
        
        context = {
            'base_url': self.base_url,
            'endpoint': 'nudge/api/v.1.1/'+endpoints[endpoint][request_type]
        }
        
        api_call = '{base_url}{endpoint}'.format(**context)
        
        headers = {
            'Authorization': 'Bearer '+access_token,
            'Host': 'jawbone.com',
            'X-Target-URI': 'https://jawbone.com',
            'Accept': 'application/json',
            'Connection': 'Keep-Alive'
        }
        res = requests.get(api_call, headers=headers)
        
        if res.status_code == 200:
            return res.json()

        return {
            'error': res.reason, 
            'status_code': res.status_code  
        }


# In[ ]:



