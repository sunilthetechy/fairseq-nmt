#!/bin/bash
#binarizes data for fast access during training

if [ $# -ne 6 ]; then
    echo "Mismatch in # of arguments provided. Please provide -n model_unique_identifier_name -s source_lang; -t target_lang"
    exit 1
fi

while getopts n:s:t: flag
do
    case "${flag}" in
        n) model_folder_name=${OPTARG};;
        s) source_lang=${OPTARG};;
		t) target_lang=${OPTARG};;
    esac
done


TEXT=examples/translation/$model_folder_name

echo "Starting fairsequence preprocess..."
fairseq-preprocess \
	--source-lang $source_lang \
	--target-lang $target_lang \
	--trainpref $TEXT/train \
	--validpref $TEXT/valid \
	--testpref $TEXT/test \
	--destdir data-bin/$model_folder_name \
	--workers 20
	#set no of workers based on the availability in your system, if you face error due to this default value (20)

echo "Creating backup..."
cp ./data-bin/$model_folder_name/*.* ./data-bin/$model_folder_name/bkp_custom

