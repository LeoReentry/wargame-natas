#!/bin/bash
if [ $# -eq 0 ]
  then echo "Please pass the password as argument"
else
  curl -s http://natas3:$1@natas3.natas.labs.overthewire.org/s3cr3t/users.txt
fi
