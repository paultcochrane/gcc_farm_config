#! /bin/sh
#
# Written by configsmoke.pl v0.082
# Thu Nov 13 14:13:15 2014
# NOTE: Changes made in this file will be *lost*
#       after rerunning configsmoke.pl
#
# 
# Run renice:
(renice -n 10 $$ >/dev/null 2>&1) || (renice 10 $$ >/dev/null 2>&1)

cd /home/ptc/p5smoke/smoke
CFGNAME=${CFGNAME:-smokecurrent_config}
LOCKFILE=${LOCKFILE:-smokecurrent.lck}
continue=''
if test -f "$LOCKFILE" && test -s "$LOCKFILE" ; then
    echo "We seem to be running (or remove $LOCKFILE)" >& 2
    exit 200

fi
echo "$CFGNAME" > "$LOCKFILE"


PATH=.:/usr/local/bin:/usr/bin:/bin:/usr/games
export PATH
umask 0
/usr/bin/perl ./tssmokeperl.pl -c "$CFGNAME" $continue $* > smokecurrent.log 2>&1

rm "$LOCKFILE"
