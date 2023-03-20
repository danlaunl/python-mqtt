#!/bin/bash

curl -X POST \
  "https://api.poc.kpn-dsh.com/auth/v0/token" \
  -H "apikey: $APIKEY" \
  -d '{"tenant": "'$TENANT'"}' > rest-token.txt



curl -X POST \
"https://api.poc.kpn-dsh.com/datastreams/v0/mqtt/token" \
-H "Authorization: Bearer `cat rest-token.txt`" \
-d '{"id":"'$THING_ID'"}' > mqtt-token.txt

curl -X POST \
"https://api.poc.kpn-dsh.com/datastreams/v0/mqtt/token" \
-H "Authorization: Bearer `cat rest-token.txt`" \
-d '{"id":"'$THING_ID'"}' > mqtt-token.txt

mosquitto_pub -h mqtt.$PLATFORM.kpn-dsh.com \
-p 8883 \
 -t "/tt/hello-things/'$THING_ID'i" \
--capath /etc/ssl/certs/ \
-d -P "`cat mqtt-token.txt`" \
-u $THING_ID -m from-dsh-message-buster



for i in {1..3}; \
do for j in {1..99}; \
do \
mosquitto_pub -h mqtt.$PLATFORM.kpn-dsh.com \
-p 8883 \
 -t "/tt/hello-things/'$THING_ID'$i" \
--capath /etc/ssl/certs/ \
-d -P "`cat mqtt-token.txt`" \
-u $THING_ID -m $THING_ID; \
done; \
   echo "Welcome $i times"; \
done;

sleep 7d
