#!/bin/bash

FILES="perlcurrent.cfg perlcurrent.cfg.bak smokecurrent_config \
       smokecurrent.patchup smokecurrent.sh smokecurrent.skiptests \
       smokecurrent.usernote"
for file in $FILES
do
    cp $HOME/p5smoke/smoke/$file $HOME/p5smoke/gcc_farm_config/$file
done
