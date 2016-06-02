#!/bin/bash
#put in resultfolder the name you want, for your destination folder results ex. recognizer
resultfolder=reconecedor_PNCC
pathTrain=~/$resultfolder/productsDatabase/DatabaseAURORA/DatabaseComplete8kHz/Train/
pathTest=~/$resultfolder/productsDatabase/DatabaseAURORA/DatabaseComplete8kHz/Test/clean/
path=`pwd`

rm -r $path/createLMAURORA $path/createPhoneAURORA $path/loadPNCCTrainAURORA $path/htkTrainAURORA 

echo "creating language model"

make FOLDEROUT=$resultfolder createLMAURORA 

echo "making phones"

make FOLDEROUT=$resultfolder DATATRAIN=$pathTrain  DATATEST=$pathTest createPhoneAURORA

echo "getting MFCC attributes"

make FOLDEROUT=$resultfolder DATATRAIN=$pathTrain DATATEST=$pathTest loadPNCCTrainAURORA

echo "Training speech recognizer"

make FOLDEROUT=$resultfolder DATATRAIN=$pathTrain htkTrainAURORA
