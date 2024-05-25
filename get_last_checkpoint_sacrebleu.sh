#!/bin/bash
#get sacrebleu of last checkpoint predictions against ground truth (for each data split)

if [ $# -ne 10 ]; then
    echo "Mismatch in # of arguments provided"
    echo "Please provide -n model_unique_identifier_name ; -d model_unique_description; -a 1/0; -b 1/0; -c 1/0;"
    exit 1
fi

while getopts n:d:a:b:c: flag
do
    case "${flag}" in
        n) model_folder_name=${OPTARG};;
        d) model_desc=${OPTARG};;
        a) is_train=${OPTARG};;
        b) is_valid=${OPTARG};;
        c) is_test=${OPTARG};;
    esac
done

if [[ "$is_train" == 1 ]]; then
    echo "Train BLEU score"
    fairseq-score -s output_custom_fldr/$model_folder_name/$model_desc/output_train_lastCP_pred.txt -r output_custom_fldr/$model_folder_name/$model_desc/output_train_lastCP_truth.txt -o 4 --sacrebleu
    echo ""
fi

if [[ "$is_valid" == 1 ]]; then
    echo "Valid BLEU score"
    fairseq-score -s output_custom_fldr/$model_folder_name/$model_desc/output_valid_lastCP_pred.txt -r output_custom_fldr/$model_folder_name/$model_desc/output_valid_lastCP_truth.txt -o 4 --sacrebleu
    echo ""
fi

if [[ "$is_test" == 1 ]]; then
    echo "Test BLEU score"
    fairseq-score -s output_custom_fldr/$model_folder_name/$model_desc/output_test_lastCP_pred.txt -r output_custom_fldr/$model_folder_name/$model_desc/output_test_lastCP_truth.txt -o 4 --sacrebleu
fi
