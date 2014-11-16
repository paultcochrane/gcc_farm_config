#!/usr/bin/bash

FILES="perlcurrent.cfg perlcurrent.cfg.bak smokecurrent_config \
       smokecurrent.patchup smokecurrent.sh smokecurrent.skiptests \
       smokecurrent.usernote"

for file in $FILES
do
    ln -sf $HOME/p5smoke/gcc_farm_config/$file $HOME/p5smoke/smoke/$file
done
