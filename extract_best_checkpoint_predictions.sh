#!/bin/bash
#create files containing ground truth and predictions of the best checkpoint (for each data split)

if [ $# -ne 14 ]; then
    echo "Mismatch in # of arguments provided"
    echo "Please provide -n model_unique_identifier_name ; -d model_unique_description; -s source_lang; -t target_lang; -a 1/0; -b 1/0; -c 1/0;"
    exit 1
fi

while getopts n:d:s:t:a:b:c: flag
do
    case "${flag}" in
        n) model_folder_name=${OPTARG};;
        d) model_desc=${OPTARG};;
	s) source_lang=${OPTARG};;
	t) target_lang=${OPTARG};;
        a) is_train=${OPTARG};;
        b) is_valid=${OPTARG};;
        c) is_test=${OPTARG};;
    esac
done

lang=$source_lang-$target_lang

if [[ "$is_train" == 1 ]]; then
    echo "Extracting training text"
    grep "H-" output_custom_fldr/$model_folder_name/$model_desc/output_train_$lang.txt | cut -f 3 > output_custom_fldr/$model_folder_name/$model_desc/output_train_pred.txt
    grep "T-" output_custom_fldr/$model_folder_name/$model_desc/output_train_$lang.txt | cut -f 2 > output_custom_fldr/$model_folder_name/$model_desc/output_train_truth.txt
    echo "no of lines in output_train_pred is"
    wc -l output_custom_fldr/$model_folder_name/$model_desc/output_train_pred.txt
    echo "no of lines in output_train_truth is"
    wc -l output_custom_fldr/$model_folder_name/$model_desc/output_train_truth.txt
fi

if [[ "$is_valid" == 1 ]]; then
    echo "Extracting validation text"
    grep "H-" output_custom_fldr/$model_folder_name/$model_desc/output_valid_$lang.txt | cut -f 3 > output_custom_fldr/$model_folder_name/$model_desc/output_valid_pred.txt
    grep "T-" output_custom_fldr/$model_folder_name/$model_desc/output_valid_$lang.txt | cut -f 2 > output_custom_fldr/$model_folder_name/$model_desc/output_valid_truth.txt
    echo "no of lines in output_valid_pred is"
    wc -l output_custom_fldr/$model_folder_name/$model_desc/output_valid_pred.txt
    echo "no of lines in output_valid_truth is"
    wc -l output_custom_fldr/$model_folder_name/$model_desc/output_valid_truth.txt
fi

if [[ "$is_test" == 1 ]]; then
    echo "Extracting test text"
    grep "H-" output_custom_fldr/$model_folder_name/$model_desc/output_test_$lang.txt | cut -f 3 > output_custom_fldr/$model_folder_name/$model_desc/output_test_pred.txt
    grep "T-" output_custom_fldr/$model_folder_name/$model_desc/output_test_$lang.txt | cut -f 2 > output_custom_fldr/$model_folder_name/$model_desc/output_test_truth.txt
    echo "no of lines in output_test_pred is"
    wc -l output_custom_fldr/$model_folder_name/$model_desc/output_test_pred.txt
    echo "no of lines in output_test_truth is"
    wc -l output_custom_fldr/$model_folder_name/$model_desc/output_test_truth.txt
fi
