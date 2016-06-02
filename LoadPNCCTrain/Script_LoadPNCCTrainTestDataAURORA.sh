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
INTRAIN=$2
INTESTE=$3
FUN=$4/LoadPNCCTrain


#*********************************************************************************#
#***  navigate through AURORA folders and files to list them in config files   ***#
#********        so they can be passed to the recognizer later         *********#

find $INTRAIN -name "*.wav" | while read line
do
nam=`ls $line | cut -d '/' -f 9 | sed 's/.wav/.feat/g'`
echo $OUT'/featuresTrain/'$nam >> $OUT/trainFeaturesFiles.txt
done


find $INTESTE -name "*.wav" | while read line
do
nam=`ls $line | cut -d '/' -f 9 | sed 's/.wav/.feat/g'`
echo $OUT'/featuresTest/'$nam >> $OUT/testFeaturesFiles.txt
done

#***************** Loop through wav files to extract PNCC of each one *****************************#
cat $OUT/trainFeaturesFiles.txt | head -n 1 | while read line
do
cp $line tmpIn
octave -q $FUN/function_htk.m
rm tmpIn
done

echo "*** Making HMM prototype file ***"

zeros_str="0"
ones_str="1"
numbreOfFeaturesCoefficients=`cat len.txt`

rm len.txt

for i in `seq 2 $numbreOfFeaturesCoefficients`;
do
	zeros_str=$zeros_str" 0"
	ones_str=$ones_str" 1"
done

#*****************************************************************************************#
#* make HMM prototype file (number of states, transition probability between them, etc) *#

touch $OUT/proto.txt

echo -e "~o <VecSize> $numbreOfFeaturesCoefficients <USER>" >> $OUT/proto.txt
echo -e "~h "proto"" >> $OUT/proto.txt
echo -e "<BeginHMM>" >> $OUT/proto.txt
echo -e "\t<NumStates> 5" >> $OUT/proto.txt
echo -e "\t<State> 2" >> $OUT/proto.txt
echo -e "\t\t<Mean> $numbreOfFeaturesCoefficients" >> $OUT/proto.txt
echo -e "\t\t\t$zeros_str" >> $OUT/proto.txt
echo -e "\t\t<Variance> $numbreOfFeaturesCoefficients" >> $OUT/proto.txt
echo -e "\t\t\t$ones_str" >> $OUT/proto.txt
echo -e "\t<State> 3" >> $OUT/proto.txt
echo -e "\t\t<Mean> $numbreOfFeaturesCoefficients" >> $OUT/proto.txt
echo -e "\t\t\t$zeros_str" >> $OUT/proto.txt
echo -e "\t\t<Variance> $numbreOfFeaturesCoefficients" >> $OUT/proto.txt
echo -e "\t\t\t$ones_str" >> $OUT/proto.txt
echo -e "\t<State> 4" >> $OUT/proto.txt
echo -e "\t\t<Mean> $numbreOfFeaturesCoefficients" >> $OUT/proto.txt
echo -e "\t\t\t$zeros_str" >> $OUT/proto.txt
echo -e "\t\t<Variance> $numbreOfFeaturesCoefficients" >> $OUT/proto.txt
echo -e "\t\t\t$ones_str" >> $OUT/proto.txt
echo -e "\t<TransP> 5" >> $OUT/proto.txt
echo -e "\t\t0 1 0 0 0" >> $OUT/proto.txt
echo -e "\t\t0 0.6 0.4 0 0" >> $OUT/proto.txt
echo -e "\t\t0 0 0.6 0.4 0" >> $OUT/proto.txt
echo -e "\t\t0 0 0 0.7 0.3" >> $OUT/proto.txt
echo -e "\t\t0 0 0 0 0" >> $OUT/proto.txt
echo "<EndHMM>" >> $OUT/proto.txt


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

