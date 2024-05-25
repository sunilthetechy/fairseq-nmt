#!/bin/bash
# learns the vocabulary (bpe tokens) after doing 'no_of_bpe_merges' merge operations for language code 'lang_code' for the experiment 'model_folder_name'

BPEROOT=subword-nmt/subword_nmt

if [ $# -ne 6 ]; then
    echo "Mismatch in # of arguments provided"
    echo "Please provide -n model_unique_identifier_name ; -l language_code (used in file extension) ; -b no_of_bpe_merges"
    exit 1
fi

while getopts n:l:b: flag
do
    case "${flag}" in
        n) model_folder_name=${OPTARG};;
        l) lang_code=${OPTARG};;
		b) no_of_bpe_merges=${OPTARG};;
    esac
done

prep=$model_folder_name
tmp=$prep/tmp
train_file=$tmp/train

echo Input file: $train_file
echo `date`

echo "learning $lang_code BPE"
python $BPEROOT/learn_bpe.py \
   --input $train_file.$lang_code \
   -s $no_of_bpe_merges \
   -o $prep/bpe_codes.$lang_code\
   --num-workers -1

echo "computing $lang_code vocab"
python $BPEROOT/apply_bpe.py \
    -c $prep/bpe_codes.$lang_code \
    --num-workers -1  \
    -i $train_file.$lang_code  | \
python $BPEROOT/get_vocab.py \
    > $prep/vocab.tmp.$lang_code

python scripts/clean_vocab.py $prep/vocab.tmp.$lang_code $prep/vocab.$lang_code
rm $prep/vocab.tmp.$lang_code

echo `date`
