#!/bin/bash
if [ $# -eq 0 ]
  then echo "Please pass the password as argument"
else
  curl -s http://natas1:$1@natas1.natas.labs.overthewire.org/ | grep -E -o 'The password for natas2 is .{32}'
fi
