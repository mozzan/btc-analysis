#!/bin/bash

BASE_DIR=`dirname $0`
DATA_DIR="$BASE_DIR/data"

if [ ! -d "$DATA_DIR" ]
then
    mkdir ./$DATA_DIR
    echo "Dir created"
else
    echo "Dir exists"
fi

cd $DATA_DIR

filenames=(BlockAndTx-545957-545937.7z)

for filename in ${filenames[@]}; do
  wget --no-check-certificate "http://dev.polipoli.com.tw/btc-analysis/$filename" -O $filename
  7za x $filename -o $DATA_DIR
done

