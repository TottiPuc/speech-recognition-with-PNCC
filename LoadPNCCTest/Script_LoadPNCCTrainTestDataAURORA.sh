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

OUT=$1/products/htk/pnccAURORA
INTEST=$2
FUN=$4/LoadPNCCTest


#*********************************************************************************
#***  navigate through AURORA folders and files to list them in config files   ***#
#********        so they can be passed to the recognizer later         *********#
find $INTEST -name "*.wav" | while read line
do
nam=`ls $line | cut -d '/' -f 11 | sed 's/.wav/.feat/g'`
echo $OUT'/featuresTest/'$nam >> $OUT/testFeaturesFiles.txt
done

#*****************************************************************************************#
#************* Prepare HTK to custom features, like SSCH and PNCC  ***********************#


touch $OUT/featureInfo.txt

echo "TARGETKIND = ANON" >> $OUT/featureInfo.txt


#*****************************************************************************************#
#************************ HDecode parameters for custom features  ************************#


touch $OUT/HDecodeParameters.txt

echo "TARGETKIND = USER" >> $OUT/HDecodeParameters.txt
echo "STARTWORD = !ENTER" >> $OUT/HDecodeParameters.txt
echo "ENDWORD = !EXIT"  >> $OUT/HDecodeParameters.txt

