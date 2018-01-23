#!/bin/bash
# 
src=$1
extension="${src#*.}"
filename="${src%%.*}"
dest=$filename.$(md5 -q $src).$extension

#ln -s $src $dest
cp $src $dest