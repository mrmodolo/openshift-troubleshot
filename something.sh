#!/bin/sh

while [ : ]
do
   clear
   date
   echo "Hostname : $(hostname)"
   /usr/games/fortune | /usr/games/cowsay
   sleep 1h
done

