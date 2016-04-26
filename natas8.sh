#!/bin/bash
if [ $# -eq 0 ]
  then echo "Please pass the password as argument"
  exit
fi
# If we look in the source code, we can see the encoded secret and the encoding scheme
# Just decode the secret because I am too lazy to do it in shell
# Make sure you have php installed
secret=`php -r 'echo base64_decode(strrev(hex2bin("3d3d516343746d4d6d6c315669563362")));'`
curl -s --user natas8:$1 --data "secret=$secret&submit=submit" http://natas8.natas.labs.overthewire.org/ | grep -E -o 'The password for natas9 is [[:alnum:]]{32}'
