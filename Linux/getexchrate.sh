#!/bin/sh



url="http://money.cnn.com/markets/currencies/crosscurr.html"
age="+720"	# 12 hours, in minutes
outf="/tmp/.exchangerate"

# Do we need the new exchange rate values?  Let's check to see:
# if the file is less than 12 hours old, the find fails ...

if [ -f $outf ] ; then
  if [ -z "$(find $outf -cmin $age -print)" ]; then
    echo "$0: exchange rate data is up-to-date." >&2
    exit 1
  fi
fi

# Actually get the latest exchange rates, translating into the
# format required by the exchrate script.

lynx -dump 'http://money.cnn.com/markets/currencies/crosscurr.html' | \
  grep -E '(Japan|Euro|Can|UK)' | \
  awk '{ if (NF == 5 ) { print $1"="$2} }' | \
  tr '[:upper:]' '[:lower:]' | \
  sed 's/dollar/cand/' > $outf

echo "Success. Exchange rates updated at $(date)."

exit 0
