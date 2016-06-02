#!/bin/bash
################################################
#==============================================#
##### Christian Dayan Arcos Gordillo  ##########
#####         speech recognition       #########
#######       CETUC - PUC - RIO       ##########
#####     christian@cetuc.puc-rio.br    ########
#####       dayan3846@gmail.com.co      ########
#==============================================#
################################################

#IN=$1/productsDatabase/DatabaseAURORA/DatabaseComplete8kHz/train/
OUT=$1/products/htk/pnccAURORA
FUN=$2/LoadPNCCTrain
IN=$3


#*********************************************************************************#
#***  navigate through AURORA folders and files to list them in config files   ***#
#********        so they can be passed to the recognizer later         *********#
#********** Loop through wav files to extract PNCC of each one *******************#

echo "***  Extracting PNCC from AURORA training data  ***"
nem=`ls $IN*.wav | wc -l`
i=1
find $IN -name "*.wav" | while read line
do
nam=`ls $line | cut -d '/' -f 9 | sed 's/.wav/.feat/g'`
echo 'extracting PNCC from file_'$i"_of_"$nem
cp $line tmpIn
sai=$OUT'/featuresTrain/'$nam
octave -q $FUN/PNCC_function.m
mv tmpOut $sai
i=`expr $i + 1`
rm tmpIn
done

