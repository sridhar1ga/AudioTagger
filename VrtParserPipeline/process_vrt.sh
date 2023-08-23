#!/bin/bash
# $1 --> vrt files folder
# $2 --> duplicate folder to extract compressed vrts
# $3 --> mp4 path
# $4 --> vrt.gz file path

process_audio(){
    	#f=/mnt/rds/redhen/gallina/projects/vrt_files_2016/2016-01/2016-01-01/2016-01-01_0837_US_KABC_Nightline.v4.vrt.gz
	f=$4
	relative_path=$(realpath --relative-to="$1" "$f")
    	chunks_path=$2/"${relative_path%.v4.vrt.gz}"
	vrt_path=$2/"${relative_path%.*}"
	gunzip -c "$f" | install -D /dev/stdin  $vrt_path
	mkdir -p $chunks_path
	mp4_path="$3/${relative_path%.v4.vrt.gz}.mp4"
	python3 -c "from vrt_parser import process_vrt; process_vrt('$vrt_path','${mp4_path}','${chunks_path}')"
	rm $vrt_path
}
