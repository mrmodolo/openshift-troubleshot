#!/bin/sh

export TERM=xterm

while [ : ]
do
   clear 2>/dev/null
   date 2>/dev/null
   echo "Hostname : $(hostname)"
   /usr/games/fortune | /usr/games/cowsay
   sleep 1h
done

