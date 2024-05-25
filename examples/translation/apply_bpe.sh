#!/usr/bin/env bash
#
# Adapted from https://github.com/facebookresearch/MIXER/blob/master/prepareData.sh
#tokenizes sentence using the learnt BPE vocabulary 

BPEROOT=subword-nmt/subword_nmt

if [ $# -ne 4 ]; then
    echo "Mismatch in # of arguments provided"
    echo "Please provide -n model_unique_identifier_name ; -l lang_codeuage_code (used in file extension)"
    exit 1
fi

while getopts n:l: flag
do
    case "${flag}" in
        n) model_folder_name=${OPTARG};;
        l) lang_code=${OPTARG};;
    esac
done

prep=$model_folder_name
tmp=$prep/tmp

for f in train.$lang_code valid.$lang_code test.$lang_code; do
	echo "calling ${BPEROOT}/apply_bpe.py on ${f}..."
	#parallel --pipe --keep-order \
    #parallel --pipe --keep-order
    python $BPEROOT/apply_bpe.py \
        -c $prep/bpe_codes.$lang_code \
        --vocabulary $prep/vocab.$lang_code \
        --vocabulary-threshold 5 \
        --num-workers "-1" \
        < $tmp/$f \
        > $prep/$f
    #to ignore tokens whose frequency is less than 'vocabulary-threshold' modify --vocabulary-threshold
done
