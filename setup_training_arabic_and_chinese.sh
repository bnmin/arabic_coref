#!/bin/bash


ontonotes_path=$1
data_dir=$2

dlx() {
  wget -P $data_dir $1/$2
  tar -xvzf $data_dir/$2 -C $data_dir
  rm $data_dir/$2
}

download_bert(){
  model=$1
  wget -P $data_dir https://storage.googleapis.com/bert_models/2018_11_23/$model.zip
  unzip $data_dir/$model.zip
  rm $data_dir/$model.zip
  mv $model $data_dir/
}

# download_bert multi_cased_L-12_H-768_A-12

function compile_partition() {
    rm -f $2.$5.$3$4
    cat $data_dir/conll-2012/$3/data/$1/data/$5/annotations/*/*/*/*.$3$4 >> $data_dir/$2.$5.$3$4
}

function compile_language() {
    compile_partition development dev v4 _gold_conll $1
    compile_partition train train v4 _gold_conll $1
    compile_partition test test v4 _gold_conll $1
}

# compile_language chinese
# compile_language arabic

vocab_file=./data/multi_cased_L-12_H-768_A-12/vocab.txt
python minimize.py $vocab_file $data_dir $data_dir false
