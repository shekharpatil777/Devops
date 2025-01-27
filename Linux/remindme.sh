#!/bin/sh


rememberfile="$HOME/.remember"

if [ $# -eq 0 ] ; then
  more $rememberfile
else
  grep -i "$@" $rememberfile | ${PAGER:-more}
fi

exit 0