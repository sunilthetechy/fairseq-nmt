#common file for both training and inference
#this file preprocesses sentences of the Indic languages
import time, sys, os, re
from indicnlp.normalize.indic_normalize import IndicNormalizerFactory
from indicnlp.tokenize import indic_tokenize

if len(sys.argv) != 5:
    print(f"There is a mismatch in the # of arguments passed")
    print(f"Please enter 1 language followed by folder name, file_name and isLog (1 for yes)")
    print("Supported languages are tamil, telugu, odia, mundari, kui, kannada, lambani, soliga and hindi")
    exit()
lang = sys.argv[1].lower()
folder_name = sys.argv[2]
file_name = sys.argv[3]
is_log = sys.argv[4]
log_fldr = f"log_{file_name}"

valid_languages = ["odia", "mundari", "kui", "kannada", "lambani", "soliga", "hindi", "tamil", "telugu"]
if lang not in valid_languages:
    print(f"Please enter a valid language: {' '.join(valid_languages)}")
    exit()

if is_log == "1":
    #creating log folder if it does not exist
    if not os.path.isdir(f"{folder_name}/{log_fldr}"):
        os.mkdir(f"{folder_name}/{log_fldr}")

def log_changes_in_file(data_after_change, data_before_change, folder_name, log_fldr, lang, process_name, is_normalization=False):
    num_lines_diff = 0
    with open(f"{folder_name}/{log_fldr}/{lang}_{process_name}_diff.txt", 'w', encoding="utf-8") as fw:
        for i in range(len(data_after_change)):
            if data_after_change[i] != data_before_change[i]:
                num_lines_diff += 1
                fw.write("BC: "+data_before_change[i]+"\n")
                if is_normalization:
                    fw.write("BC: "+' '.join([hex(ord(c)) for c in data_before_change[i]])+"\n")
                fw.write("AC: "+data_after_change[i]+"\n")
                if is_normalization:
                    fw.write("AC: "+' '.join([hex(ord(c)) for c in data_after_change[i]])+"\n\n")
                
    print(f"No of lines modified by processing of {process_name} are {num_lines_diff}")

##################################### Transforming data to format expected by model ##########################################

with open(f"{folder_name}/{file_name}", 'r', encoding="utf-8") as fr:
    data_lang = fr.readlines()
print(f"Original number of sentences are {len(data_lang)}")

#step 1 - trimming
data_lang_temp = data_lang.copy()
data_lang = [x.strip() for x in data_lang]
assert False not in [x==x.strip() for x in data_lang], "trimming error"

#step 2 - indic normalization
lang_code = {"tamil":"ta", "telugu":"te"}
factory = IndicNormalizerFactory()
normalizer = factory.get_normalizer(lang_code[lang], remove_nuktas=False)
data_lang_temp = data_lang.copy()
data_lang = [normalizer.normalize(x) for x in data_lang]
assert False not in [x==normalizer.normalize(x) for x in data_lang], "normalizer error"

if is_log=="1":
    log_changes_in_file(data_lang, data_lang_temp, folder_name, log_fldr, lang, "normalization", is_normalization=True)

#step 3 - indic tokenization
data_lang_temp = data_lang.copy()
data_lang = [" ".join(indic_tokenize.trivial_tokenize(x)) for x in data_lang]
assert False not in [x==" ".join(indic_tokenize.trivial_tokenize(x)) for x in data_lang], "tokenizer error"
processed_folder="processed"+lang.title()
if is_log=="1":
    log_changes_in_file(data_lang, data_lang_temp, folder_name, log_fldr, lang, "tokenization")
processed_folder_path = os.path.join(folder_name, processed_folder)
if not os.path.isdir(processed_folder_path):
    os.makedirs(processed_folder_path)

file_name = file_name.strip().split(".")[0]
with open(f"{processed_folder_path}/{file_name}.{lang[:3]}", 'w', encoding="utf-8") as fw:
    for sent_no in range(len(data_lang)):
        fw.write(data_lang[sent_no]+"\n")
        
print(f"Number of sentences processed are {len(data_lang)}")