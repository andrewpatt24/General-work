
# coding: utf-8

# In[1]:

import webbrowser
import urllib2
import urlparse
import json
import urllib
import requests
from requests_oauthlib import OAuth2Session

client_id="jfZVZP40zF0"
client_secret="ab60dea0d6ccff8bbc0579e149f02000e2c7fae7"
scope=["basic_read","extended_read"]
redirect_uri="http://www.dinnerwithdata.com"

oauth = OAuth2Session(client_id,
                      redirect_uri=redirect_uri,
                      scope=scope)


# In[2]:

authorization_url, state = oauth.authorization_url(
        'https://jawbone.com/auth/oauth2/auth',
        )

print 'Please go to %s and authorize access.' % authorization_url
authorization_response = raw_input('Enter the full callback URL ')


# In[3]:

query_set = urlparse.parse_qs(urlparse.urlparse(authorization_response).query)

print query_set


# In[4]:

token = oauth.fetch_token(
        'https://jawbone.com/auth/oauth2/token',
        code=query_set['code'],
        client_secret=client_secret
        )

print token
#r = oauth.get('https://jawbone.com/nudge/api/v.1.1/users/@me/bandevents')


# In[5]:

r = oauth.get('https://jawbone.com/nudge/api/v.1.1/users/@me/bandevents')


# In[6]:

print r


# In[ ]:



