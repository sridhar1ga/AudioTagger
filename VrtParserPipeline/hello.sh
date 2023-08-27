#!/bin/bash
set -e
# $1 --> folder of all the VRTs
# $2 --> New output folder
# $3 --> Mp4s folder

process_audio(){
    #f=/mnt/rds/redhen/gallina/projects/vrt_files_2016/2016-01/2016-01-01/2016-01-01_0837_US_KABC_Nightline.v4.vrt.gz
	f=$4
	SCRATCH_PATH=/scratch/users/sxv499
	GALLINA_OUTPUT_PATH=/mnt/rds/redhen/gallina/home/sxv499/tv_output
	relative_path=$(realpath --relative-to="$1" "$f")
    chunks_path=$2/"${relative_path%.v4.vrt.gz}"
	vrt_path=$2/"${relative_path%.*}"
	mp4_gallina_path="$3/${relative_path%.v4.vrt.gz}.mp4"
	mp4_name=$(basename $mp4_gallina_path)
	mp4_scratch_path=$SCRATCH_PATH/$mp4_name
	ssh dtn2 "cp -r $mp4_gallina_path $mp4_scratch_path"
	gunzip -c "$f" | install -D /dev/stdin  $vrt_path
	mkdir -p $chunks_path
	python3 -c "from vrt_parser import process_vrt; process_vrt('$vrt_path','${mp4_scratch_path}','${chunks_path}')"
	ssh dtn2 "mkdir -p $GALLINA_OUTPUT_PATH/${relative_path%.v4.vrt.gz}" && ssh dtn2 "cp -r $chunks_path/* $GALLINA_OUTPUT_PATH/${relative_path%.v4.vrt.gz}"
	rm -r $chunks_path $vrt_path $mp4_scratch_path
}

find $1 -type f -name *.vrt.gz | parallel -j 2 --halt soon,done=3 process_audio $1 $2 $3 {}


# for f in $(find $1 -type f -name *.vrt.gz); do
# 	process_audio $1 $2 $3 $f
# done

