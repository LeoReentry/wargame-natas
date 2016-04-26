#!/bin/bash
if [ $# -eq 0 ]
  then echo "Please pass the password as argument"
  exit
fi
# Ok, this is a little different already
# If we look in the source code the page provides us, we can see an include
# In this include, we will find the secret
# Here, we just submit the secret using POST
curl -s --data "secret=FOEIUWGHFEEUHOFUOIU&submit=submit" http://natas6:$1@natas6.natas.labs.overthewire.org/ | grep -E -o 'The password for natas7 is .{32}'
