#!/bin/bash
#generate predictions for data splits train, valid and test using the best checkpoint

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

src=$source_lang
tgt=$target_lang
lang=$source_lang-$target_lang

echo "This code generates outputs for Training, Validation and Testing datasets for $model_folder_name, $model_desc..."

if [[ "$is_test" == 1 ]]; then
    echo "Generating output for testing data in ./output_custom_fldr/$model_folder_name/$model_desc"
    #Generate output
    fairseq-generate data-bin/$model_folder_name --path checkpoints/$model_folder_name/$model_desc/checkpoint_best.pt --batch-size 128 --beam 5 --remove-bpe --skip-invalid-size-inputs-valid-test > output_custom_fldr/$model_folder_name/$model_desc/output_test_$lang.txt
fi


if [[ "$is_train" == 1 ]]; then
    echo "Preparing files to generate output for training data"
    #Rename training files as test files
    cp ./data-bin/$model_folder_name/train.$lang.$src.bin ./data-bin/$model_folder_name/test.$lang.$src.bin
    cp ./data-bin/$model_folder_name/train.$lang.$src.idx ./data-bin/$model_folder_name/test.$lang.$src.idx
    cp ./data-bin/$model_folder_name/train.$lang.$tgt.bin ./data-bin/$model_folder_name/test.$lang.$tgt.bin
    cp ./data-bin/$model_folder_name/train.$lang.$tgt.idx ./data-bin/$model_folder_name/test.$lang.$tgt.idx
    echo "Generating output for training data in ./output_custom_fldr/$model_folder_name/$model_desc"
    #Generate output
    fairseq-generate data-bin/$model_folder_name --path checkpoints/$model_folder_name/$model_desc/checkpoint_best.pt --batch-size 128 --beam 5 --remove-bpe --skip-invalid-size-inputs-valid-test > output_custom_fldr/$model_folder_name/$model_desc/output_train_$lang.txt

    echo "Restoring test files from backup"
    cp ./data-bin/$model_folder_name/bkp_custom/test.$lang.$src.bin ./data-bin/$model_folder_name/test.$lang.$src.bin
    cp ./data-bin/$model_folder_name/bkp_custom/test.$lang.$src.idx ./data-bin/$model_folder_name/test.$lang.$src.idx
    cp ./data-bin/$model_folder_name/bkp_custom/test.$lang.$tgt.bin ./data-bin/$model_folder_name/test.$lang.$tgt.bin
    cp ./data-bin/$model_folder_name/bkp_custom/test.$lang.$tgt.idx ./data-bin/$model_folder_name/test.$lang.$tgt.idx
fi

if [[ "$is_valid" == 1 ]]; then
    echo "Preparing files to generate output for validation data"
    #Rename validation files as test files
    cp ./data-bin/$model_folder_name/valid.$lang.$src.bin ./data-bin/$model_folder_name/test.$lang.$src.bin
    cp ./data-bin/$model_folder_name/valid.$lang.$src.idx ./data-bin/$model_folder_name/test.$lang.$src.idx
    cp ./data-bin/$model_folder_name/valid.$lang.$tgt.bin ./data-bin/$model_folder_name/test.$lang.$tgt.bin
    cp ./data-bin/$model_folder_name/valid.$lang.$tgt.idx ./data-bin/$model_folder_name/test.$lang.$tgt.idx
    echo "Generating output for validation data in ./output_custom_fldr/$model_folder_name/$model_desc"
    #Generate output
    fairseq-generate data-bin/$model_folder_name --path checkpoints/$model_folder_name/$model_desc/checkpoint_best.pt --batch-size 128 --beam 5 --remove-bpe --skip-invalid-size-inputs-valid-test > output_custom_fldr/$model_folder_name/$model_desc/output_valid_$lang.txt

    echo "Restoring test files from backup"
    cp ./data-bin/$model_folder_name/bkp_custom/test.$lang.$src.bin ./data-bin/$model_folder_name/test.$lang.$src.bin
    cp ./data-bin/$model_folder_name/bkp_custom/test.$lang.$src.idx ./data-bin/$model_folder_name/test.$lang.$src.idx
    cp ./data-bin/$model_folder_name/bkp_custom/test.$lang.$tgt.bin ./data-bin/$model_folder_name/test.$lang.$tgt.bin
    cp ./data-bin/$model_folder_name/bkp_custom/test.$lang.$tgt.idx ./data-bin/$model_folder_name/test.$lang.$tgt.idx
fi
