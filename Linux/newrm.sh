#!/bin/sh


 mydir="$HOME/.deleted-files"
realrm="/bin/rm "
  copy="/bin/cp -R"

if [ $# -eq 0 ] ; then  # let 'rm' ouptut the usage error 
  exec $realrm        # our shell dies and is replaced by /bin/rm
fi

# parse all options looking for '-f'

flags=""

while getopts "dfiPRrvW" opt
do
  case $opt in
    f ) exec $realrm "$@"     ;;  # exec lets us exit this script directly.
    * ) flags="$flags -$opt"  ;;  # other flags are for 'rm', not us
  esac
done
shift $(( $OPTIND - 1 ))

# make sure that the $mydir exists

if [ ! -d $mydir ] ; then
  if [ ! -w $HOME ] ; then
    echo "$0 failed: can't create $mydir in $HOME" >&2 
    exit 1
  fi
  mkdir $mydir
  chmod 700 $mydir        # a little bit of privacy, please
fi

for arg 
do
  newname="$mydir/$(date "+%S.%M.%H.%d.%m").$(basename "$arg")"
  if [ -f "$arg" ] ; then
    $copy "$arg" "$newname"
  elif [ -d "$arg" ] ; then
    $copy "$arg" "$newname"
  fi
done

exec $realrm $flags "$@"        # our shell is replaced by realrm