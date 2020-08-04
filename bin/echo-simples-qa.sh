#!/bin/sh

gelf_message="{\"version\":\"1.1\",\"host\":\"logging.tester.local\",\"short_message\":\"A short message testing PLAIN TEXT messages\",\"timestamp\":$(
date +'%s.%N'),\"_tags\":\"OPENSHIFT,POD\",\"level\":1,\"_user_id\":13,\"_app\":\"app-local-teste-logging\"}"

echo ${gelf_message}

echo ${gelf_message} | ./ncat -w 1 -u 10.143.243.23 12201

