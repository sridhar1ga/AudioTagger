#!/bin/bash
set -e
# $1 --> folder of all the VRTs
# $2 --> New output folder
# $3 --> Mp4s folder
pwd
cd /VrtParserPipeline/
source process_vrt.sh

find $1 -type f -name *.vrt.gz | parallel -j 4 process_audio $1 $2 $3 {}


# for f in $(find $1 -type f -name *.vrt.gz); do
# 	process_audio $1 $2 $3 $f
# done

