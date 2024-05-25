#!/bin/bash
#creates folders required for training and evaluating NMT model using the 'translation' task in fairseq

if [ $# -ne 4 ]; then
    echo "Mismatch in # of arguments provided. Please provide -n model_unique_identifier_name; -d model_description"
    exit 1
fi

while getopts n:d: flag
do
    case "${flag}" in
        n) model_folder_name=${OPTARG};;
	    d) model_desc=${OPTARG};;
    esac
done

echo "Environmnet setup for $model_folder_name in progress ..."

if [ ! -d "./output_custom_fldr" ] 
then
    echo "Creating ./output_custom_fldr as it was not found" 
    mkdir --parents ./output_custom_fldr
fi

if [ ! -d "./log_custom_fldr" ]
then
    echo "Creating ./log_custom_fldr as it was not found"
    mkdir --parents ./log_custom_fldr
fi

if [ ! -d "./data-bin" ]
then
    echo "Creating ./data-bin as it was not found"
    mkdir --parents ./data-bin
fi

if [ ! -d "./checkpoints" ]
then
    echo "Creating ./checkpoints as it was not found"
    mkdir --parents ./checkpoints
fi

if [ ! -d "./output_custom_fldr/$model_folder_name/$model_desc" ]
then
    mkdir --parents ./output_custom_fldr/$model_folder_name/$model_desc
    echo "$model_folder_name/$model_desc folder created in ./output_custom_fldr"
fi

if [ ! -d "./log_custom_fldr/$model_folder_name/$model_desc" ]
then
    mkdir --parents ./log_custom_fldr/$model_folder_name/$model_desc
    echo "$model_folder_name/$model_desc folder created in ./log_custom_fldr"
fi

if [ ! -d "./data-bin/$model_folder_name/bkp_custom" ]
then
    mkdir --parents ./data-bin/$model_folder_name/bkp_custom
    echo "$model_folder_name/bkp_custom folder created in ./data-bin"
fi

if [ ! -d "./checkpoints/$model_folder_name/$model_desc" ]
then
    mkdir --parents ./checkpoints/$model_folder_name/$model_desc
    echo "$model_folder_name/$model_desc folder created in ./checkpoints"
fi

if [ ! -d "./examples/translation/$model_folder_name/tmp/bkp_custom" ]
then
    mkdir --parents ./examples/translation/$model_folder_name/tmp/bkp_custom
    echo "$model_folder_name/tmp/bkp_custom folder created in ./examples/translation/"
fi


