#inference preprocessing file
#this file preprocesses sentences of the English language
import time, sys, os, re
import random, string
from sacremoses import MosesPunctNormalizer
from sacremoses import MosesTokenizer

if len(sys.argv) != 6:
    print(f"There is a mismatch in the # of arguments passed")
    print(f"Please enter 1 language followed by folder name, file_name, isCasePreserving (1 for yes) and isLog (1 for yes)")
    print("Supported language is only english")
    exit()
lang = sys.argv[1].lower()
folder_name = sys.argv[2]
file_name = sys.argv[3]
isCasePreserving = sys.argv[4]
is_log = sys.argv[5]
log_fldr = f"log_{file_name}"

valid_languages = ["english"]
if lang not in valid_languages:
    print("Please enter a valid language")
    print(f"{lang} is not english")
    exit()

if is_log == "1":
    #creating log folder if it does not exist
    if not os.path.isdir(f"{folder_name}/{log_fldr}"):
        os.mkdir(f"{folder_name}/{log_fldr}")

def log_changes_in_file(data_after_change, data_before_change, folder_name, log_fldr, lang, process_name):
    num_lines_diff = 0
    with open(f"{folder_name}/{log_fldr}/{lang}_{process_name}_diff.txt", 'w', encoding="utf-8") as fw:
        for i in range(len(data_after_change)):
            if data_after_change[i] != data_before_change[i]:
                num_lines_diff += 1
                fw.write("BC: "+data_before_change[i]+"\n")
                fw.write("AC: "+data_after_change[i]+"\n\n")
    print(f"No of lines modified by processing of {process_name} are {num_lines_diff}")

##################################### Transforming data to format expected by model ##########################################

with open(f"{folder_name}/{file_name}", 'r', encoding="utf-8") as fr:
    data_lang = fr.readlines()
print(f"Original number of sentences are {len(data_lang)}")

#step 1 - (conditional) lower casing
data_lang_temp = data_lang.copy()
if isCasePreserving != "1":
    data_lang = [x.lower().strip() for x in data_lang]
    assert False not in [x==x.lower().strip() for x in data_lang], "lower casing error"
else:
    data_lang = [x.strip() for x in data_lang]
    assert False not in [x==x.strip() for x in data_lang], "trimming error"

"""
#step 2 - remove not allowed symbols
allowed_symbols = {'!',  "'",  ',', '.', '?'}
allowed_symbols_str = "".join(allowed_symbols)
data_lang_temp = data_lang.copy()
for i in range(len(data_lang)):
    if len(set(re.sub(r'[a-zA-Z ]', "", data_lang[i])).difference(allowed_symbols)) != 0:
        data_lang[i] = re.sub(rf'[^a-zA-Z {allowed_symbols_str}]', "", data_lang[i])
assert False not in [x==re.sub(rf'[^a-zA-Z {allowed_symbols_str}]', "", x) for x in data_lang], "only_allowed_symbols error"

if is_log=="1":
    log_changes_in_file(data_after_change, data_before_change, folder_name, log_fldr, lang, "only_allowed_symbols")
"""

#step 3 - moses normalization and tokenization
#MosesTokenizer
en_tok = MosesTokenizer(lang="en")
en_normalizer = MosesPunctNormalizer()
data_lang_temp = data_lang.copy()
moses_normalizer_tokenizer = lambda x : " ".join(en_tok.tokenize(en_normalizer.normalize(x.strip()), escape=False))
data_lang = [moses_normalizer_tokenizer(x) for x in data_lang]
#assert False not in [x==moses_normalizer_tokenizer(x) for x in data_lang], "moses_normalizer_tokenizer error" # f(f(x)) != f(x) for this function

if is_log=="1":
    log_changes_in_file(data_lang, data_lang_temp, folder_name, log_fldr, lang, "tokenization")

"""
#step 4 - converting ... at end to just . (need to pos-process after translation to add back ..., not trivial for purna viraha scripts)
data_lang_temp = data_lang.copy()
for i in range(len(data_lang)):
    if '.' in set(data_lang[i]):
        if len(set(data_lang[i][data_lang[i].index('.') : -1]).difference(set([' ', '.']))) == 0:
            data_lang[i] = data_lang[i][:data_lang[i].index('.')+1]
assert False not in [x==x[:x.index('.')+1] for x in data_lang if '.' in set(x)], "multiple_dots error"

if is_log=="1":
    log_changes_in_file(data_after_change, data_before_change, folder_name, log_fldr, lang, "multiple_dots")
"""

"""
#step 5 - replace , as . if it occurs at the end of sentence
data_lang_temp = data_lang.copy()
for i in range(len(data_lang)):
    if data_lang[i].strip()[-1] == ',':
        data_lang[i] = data_lang[i].strip()[:-1].strip()+' .'
assert False not in [x.strip()[-1]!="," for x in data_lang], "ending_in_comma error"

if is_log=="1":
    log_changes_in_file(data_after_change, data_before_change, folder_name, log_fldr, lang, "ending_in_comma")
"""

"""
#step 6 - append " ." at the end of sentence if the sentence ends with symbols other than {'.', '!', '?'}
data_lang_temp = data_lang.copy()
for i in range(len(data_lang)):
    if data_lang[i].strip()[-1] not in {'.', '!', '?'}:
        data_lang[i] = data_lang[i].strip()+' .'
assert False not in [x.strip()[-2:]==" ." for x in data_lang], "adding_fullstop error"

if is_log=="1":
    log_changes_in_file(data_after_change, data_before_change, folder_name, log_fldr, lang, "adding_fullstop")
"""
processed_folder_path = os.path.join(folder_name, "processedEnglish")
if not os.path.isdir(processed_folder_path):
    os.makedirs(processed_folder_path)
file_name = file_name.strip().split(".")[0]
with open(f"{folder_name}/processed/{file_name}.eng", 'w', encoding="utf-8") as fw:
    for sent_no in range(len(data_lang)):
        fw.write(data_lang[sent_no]+"\n")
        
print(f"Number of sentences processed are {len(data_lang)}")