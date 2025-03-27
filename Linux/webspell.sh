#!/bin/sh


okaywords="$HOME/.okaywords"
tempout="/tmp/webspell.$$"
trap "/bin/rm -f $tempout" 0

if [ $# -eq 0 ] ; then
  echo "Usage: webspell file|URL" >&2; exit 1
fi

for filename
do
  if [ ! -f "$filename" -a "$(echo $filename|cut -c1-7)" != "http://" ] ; then
     continue;      # picked up directory in '*' listing
  fi

  lynx -dump $filename | tr ' ' '\n' | sort -u | \
    grep -vE "(^[^a-z]|')" | \
    # adjust the following line to produce just a list of misspelled words
    ispell -a | awk '/^\&/ { print $2 }' | \
    sort -u > $tempout 

  if [ -r $okaywords ] ; then
    # if you have an okaywords file, screen okay words out
    grep -vif $okaywords < $tempout > ${tempout}.2
    mv ${tempout}.2 $tempout
  fi

  if [ -s $tempout ] ; then
    echo "Probable spelling errors: ${filename}"
    echo '-------' ; cat $tempout ; echo '========='
    cat $tempout | paste - - - -  | sed 's/^/  /'
  fi
done

exit 0