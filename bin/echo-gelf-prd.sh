#!/bin/sh

NC="nc"
LOGGING_UDP_GLOBOI_COM="10.143.243.20"
GELF_UDP="12201"

echo ""

printf '{"version": "1.1","host": "debug-tools","short_message": "teste OpenShift","timestamp": %s,"_tags":"OPENSHIFT,POD","level": "5","_user_id": 42,
"_app": "debug-tools" }\n' $(date +'%s.%N') 

echo ""

printf '{"version": "1.1","host": "debug-tools","short_message": "teste OpenShift","timestamp": %s,"_tags":"OPENSHIFT,POD","level": "5","_user_id": 42,
"_app": "debug-tools" }\n' $(date +'%s.%N') | $NC -v -w2 -u  $LOGGING_UDP_GLOBOI_COM $GELF_UDP

echo ""

