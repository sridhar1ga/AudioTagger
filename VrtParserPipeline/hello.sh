#!/bin/bash
set -e
# $1 --> folder of all the VRTs
# $2 --> New output folder
# $3 --> Mp4s folder

find $1 -type f -name *.vrt.gz | parallel -j 3 process_audio $1 $2 $3 {}


# for f in $(find $1 -type f -name *.vrt.gz); do
# 	process_audio $1 $2 $3 $f
# done

