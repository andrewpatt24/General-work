install.packages("ROAuth")
library("ROAuth")
install.packages("rjson")
library(rjson)

Name="AndrewPattersonData"
Vendor="AndrewPatterson"
Client_Id="jfZVZP40zF0"
App_Secret="ab60dea0d6ccff8bbc0579e149f02000e2c7fae7"
scope="basic_read,extended_read,location_read,friends_read,mood_read,mood_write,move_read,move_write,sleep_read,sleep_write,meal_read,meal_write,weight_read,weight_write,generic_event_read,generic_event_write"
redirect="http://www.dinnerwithdata.com"


browseURL(
  paste0("https://jawbone.com/auth/oauth2/auth?",
         "response_type=code&",
         "client_id=",Client_Id,"&",
         "scope=",scope,"&",
         "redirect_uri=",redirect
  ))


##Output http://www.dinnerwithdata.com/?code=mGKV_178jYyrf7a3nC7n6WWydLzFIBxkUYEjmTxpcArHZLrWubRl2vVp7yiPhmgpW1OCWnRHe8gh7xZacFOon4H9bA56EPM0F3QduHr1dPyfYO5UpCruMPDuPBm647UeTT2HemvSo3MwsjaK-jeesWPaCM6yWi7UAUpOhRKgH77k8lNHm2EhXQTVMYTp02Yc
code="mGKV_178jYyrf7a3nC7n6WWydLzFIBxkNDXFKo7BOcfHZLrWubRl2vVp7yiPhmgpW1OCWnRHe8gh7xZacFOon4H9bA56EPM0F3QduHr1dPyfYO5UpCruMPDuPBm647UeTT2HemvSo3MwsjaK-jeesWPaCM6yWi7UAUpOhRKgH77k8lNHm2EhXQTVMYTp02Yc"

output<-readLines(
paste0("https://jawbone.com/auth/oauth2/token?",
       "client_id=",Client_Id,"&",
       "client_secret=",App_Secret,"&",
       "grant_type=authorization_code&",
       "code=",code
))

output.text<-fromJSON(output)
##Output
##{"access_token": "r5ZHAAV8pCXPRAGQvtz41_H6xYJXyvY5aKcPLbGRGBVnkErKI_jBpqozw-27j0YkkKMwPvEBJ55RAnYEZaPxlCzIBmUtBLpsaym2RYjpp5gDwoQTw2eSTw", "token_type": "Bearer", "expires_in": 31536000, "refresh_token": "Mlppw2R1KFaR0MjTW8w76AxVWveHwTMLyxT4BiSWr7bdL2WxNgQvKekaCy5aBtavNNWfJhnfRQwlAN2iCODyqw"}

readLines(
paste0("https://jawbone.com/nudge/api/v.1.1/users/@me/bandevents")
)

https://jawbone.com/nudge/api/v.1.1/users/r5ZHAAV8pCXPRAGQvtz41_H6xYJXyvY5aKcPLbGRGBVnkErKI_jBpgXydKOeJiLjkKMwPvEBJ55RAnYEZaPxlCzIBmUtBLpsaym2RYjpp5gDwoQTw2eSTw/bandevents


https://jawbone.com/nudge/api/v.1.1/users/r5ZHAAV8pCXPRAGQvtz41_H6xYJXyvY5aKcPLbGRGBVnkErKI_jBpgXydKOeJiLjkKMwPvEBJ55RAnYEZaPxlCzIBmUtBLpsaym2RYjpp5gDwoQTw2eSTw


type="body_events"
output<-readLines(
  paste0("https://jawbone.com/nudge/api/users/@me/",
         type,
         "?Authorization=Bearer%r5ZHAAV8pCXPRAGQvtz41_H6xYJXyvY5aKcPLbGRGBWIVMqfsx23c066jP6ABQffkKMwPvEBJ55RAnYEZaPxlCzIBmUtBLpsaym2RYjpp5gDwoQTw2eSTw"
         )
  )


readLines(
  url(
    "https://jawbone.com/nudge/api/users/@me/body_events?Authorization=Bearer r5ZHAAV8pCXPRAGQvtz41_H6xYJXyvY5aKcPLbGRGBWIVMqfsx23c066jP6ABQffkKMwPvEBJ55RAnYEZaPxlCzIBmUtBLpsaym2RYjpp5gDwoQTw2eSTw%22CXPRAGQvtz41_H6xYJXyvY5aKcPLbGRGBWIVMqfsx23c066jP6ABQffkKMwPvEBJ55RAnYEZaPxlCzIBmUtBLpsaym2RYjpp5gDwoQTw2eSTw"
    ,open=TRUE)
  )
