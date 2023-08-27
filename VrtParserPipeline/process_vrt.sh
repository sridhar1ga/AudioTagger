#!/bin/bash
# $1 --> vrt files folder
# $2 --> duplicate folder to extract compressed vrts
# $3 --> mp4 path
# $4 --> vrt.gz file path

process_audio(){
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

export -f process_audio
