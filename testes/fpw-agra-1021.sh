#!/bin/sh

# Testes FPW & AGRA

log () {
  echo ""
  echo "[$(date +'%D %H:%M:%S')] $1"
}

test_host_clhachosr006() {
  log "Host clhachosr006"
  nc -zv -w3 clhachosr006.corp.tvglobo.com.br 8090
  nc -zv -w3 clhachosr006.corp.tvglobo.com.br 443
  curl -I --connect-timeout 3 http://clhachosr006.corp.tvglobo.com.br:8090
  curl -Ik --connect-timeout 3 https://clhachosr006.corp.tvglobo.com.br:443
}

test_host_clhachosr007() {
  log "Host clhachosr007"
  nc -zv -w3 clhachosr007.corp.tvglobo.com.br 8090
  nc -zv -w3 clhachosr007.corp.tvglobo.com.br 443
  curl -I --connect-timeout 3 http://clhachosr007.corp.tvglobo.com.br:8090
  curl -Ik --connect-timeout 3 https://clhachosr007.corp.tvglobo.com.br:443
}

test_host_clhaorasr002() {
  log "Oracle clhaorasr002"
  nc -zv -w3 clhaorasr002.corp.tvglobo.com.br 1521
}

echo ""
echo "################################### FPW e AGRA #################################"
echo ""
test_host_clhachosr006
test_host_clhachosr007
test_host_clhaorasr002
echo ""
echo "################################### FPW e AGRA #################################"
echo ""
