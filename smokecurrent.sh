#! /bin/sh
#
# Written by configsmoke.pl v0.082
# Sat Nov 15 13:01:33 2014
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


PATH=.:/home/ptc/perl5/perlbrew/bin:/home/ptc/perl5/perlbrew/perls/perl-5.16.3/bin:/usr/local/bin:/usr/bin:/bin:/usr/games
export PATH
umask 0
/home/ptc/perl5/perlbrew/perls/perl-5.16.3/bin/perl ./tssmokeperl.pl -c "$CFGNAME" $continue $* > smokecurrent.log 2>&1

rm "$LOCKFILE"
