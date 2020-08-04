#!/bin/sh

NC="nc"
HOST="10.143.243.23"
PORT="12201"

word0=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
word1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 1)

host=$(hostname)
short_message="$word0 $word1"
timestamp=$(date +'%s.%N')
tags="OPENSHIFT,POD,QA"
level="5"
user_id=$(id -u)
app="words"

message='{"version":"1.0","host":"%s","short_message":"%s","timestamp":%s,"_tags":"%s","level":"%s","_user_id":%s,"_app":"%s"}'
printf "\n$message\n\n" "$host" "$short_message" "$timestamp" "$tags" "$level" "$user_id" "$app"

printf "$message" "$host" "$short_message" "$timestamp" "$tags" "$level" "$user_id" "$app" | $NC -v -w2 -u $HOST $PORT

printf "\n- FIM -.-\n"

