#!/bin/bash
if [ $# -eq 0 ]
  then echo "Please pass the password as argument"
else
  curl -s http://natas2:$1@natas2.natas.labs.overthewire.org/files/users.txt | grep natas3
fi
