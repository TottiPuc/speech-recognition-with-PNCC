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

USE_CROSSWORD_TRIPHONE=0

echo " *** Making a monophones0 nad monophones1 files (without and with short pauses)****"

DB=$1/productsDatabase/DatabaseAURORA
OUT=$1/products/htk/phonesAURORA
OUTList=$1/products/htk
sour=$2/CreatePhones
pathTrain=$3
pathTest=$4
#rm -f $OUT/*.txt $OUTList/wordsInTrainSentencesAURORA.txt  $OUTList/wordsInTestSentencesAURORA.txt  $OUTList/TrainSentencesAURORA.txt $OUTList/TestSentencesAURORA.txt


#****************************************************************************************#
#************ make monophones0 and monophones1 files from monphones file  ***************#

cp $DB/monophones.txt $OUT/monophones0.tmp
cp $DB/monophones.txt $OUT/monophones1.tmp

cat $OUT/monophones0.tmp | tr -d "\r" > $OUT/monophones0.txt
cat $OUT/monophones1.tmp | tr -d "\r" > $OUT/monophones1.txt

rm -f $OUT/monophones0.tmp $OUT/monophones1.tmp

echo "sil" >> $OUT/monophones0.txt
echo "sil" >> $OUT/monophones1.txt
echo "sp" >> $OUT/monophones1.txt

#****************************************************************************************#
#************  prepare special dictionary and wordnet for monophone test  ***************#

touch $OUT/dictionaryForPhonesTest.txt
touch $OUT/grammarPhones.txt

$sour/createPhones.py $OUT/monophones0.txt $OUT/dictionaryForPhonesTest.txt $OUT/grammarPhones.txt

HParse $OUT/grammarPhones.txt $OUT/wordNetPhones.txt

echo ""
echo " *** Listing words of train/test sentences in MLF file ***"
echo ""

touch $OUTList/wordsInTrainSentencesAURORA.tmp
touch $OUTList/wordsInTestSentencesAURORA.tmp
touch $OUTList/TrainSentencesAURORA.txt


echo "#!MLF!#" >> $OUTList/wordsInTrainSentencesAURORA.tmp
find $pathTrain -name "*stc.txt" | while read line
do
nam=`ls $line | cut -d '/' -f 9`
echo "\"*/$nam\"" >> $OUTList/wordsInTrainSentencesAURORA.tmp
cat $line | tr -s " " "\012"  >> $OUTList/wordsInTrainSentencesAURORA.tmp
echo "." >> $OUTList/wordsInTrainSentencesAURORA.tmp
sen=`cat $line`
echo "\"*/$nam\" $sen" >> $OUTList/TrainSentencesAURORA.txt
done
cat $OUTList/wordsInTrainSentencesAURORA.tmp | tr -d "\r" | sed '/./!d' > $OUTList/wordsInTrainSentencesAURORA.txt   #delet character ascii

##test

echo "#!MLF!#" >> $OUTList/wordsInTestSentencesAURORA.tmp
find $pathTest -name "*stc.txt" | while read line
do
nam=`ls $line | cut -d '/' -f 9`
echo "\"*/$nam\"" >> $OUTList/wordsInTestSentencesAURORA.tmp
cat $line | tr -s " " "\012"  >> $OUTList/wordsInTestSentencesAURORA.tmp
echo "." >> $OUTList/wordsInTestSentencesAURORA.tmp
sen=`cat $line`
echo "\"*/$nam\" $sen" >> $OUTList/TestSentencesAURORA.txt
done
cat $OUTList/wordsInTestSentencesAURORA.tmp | tr -d "\r" | sed '/./!d' > $OUTList/wordsInTestSentencesAURORA.txt   #delet character ascii

rm -f $OUTList/wordsInTestSentencesAURORA.tmp $OUTList/wordsInTrainSentencesAURORA.tmp

echo ""
echo " *** listing phones of /train/test sentences in MFL file***"
echo ""

touch $OUT/dictionaryWithShortPause.txt
touch $OUT/dictionaryWithShortPauseTest.txt
#$sour/dicAcusticModelAurora.sh $OUTList     # run this script only if aurora AM dictionary hasn't been created
cat $OUT/dictionaryCMU/dictionaryAM.txt | sed 's/$/ sp/g' >> $OUT/dictionaryWithShortPause.txt
cat $OUT/dictionaryCMU/dictionaryAMTest.txt | sed 's/$/ sp/g' >> $OUT/dictionaryWithShortPauseTest.txt

echo "!ENTER sil" >> $OUT/dictionaryWithShortPause.txt
echo "!EXIT sil" >> $OUT/dictionaryWithShortPause.txt
echo "!ENTER sil" >> $OUT/dictionaryWithShortPauseTest.txt
echo "!EXIT sil" >> $OUT/dictionaryWithShortPauseTest.txt


echo ""
echo " *** create a master label file manually, comparing phone and word file***"
echo ""

touch $OUT/phonesInSentencesConfiguration0.txt
touch $OUT/phonesInSentencesConfiguration1.txt

echo "EX" >> $OUT/phonesInSentencesConfiguration0.txt
echo "IS sil sil" >> $OUT/phonesInSentencesConfiguration0.txt
echo "DE sp" >> $OUT/phonesInSentencesConfiguration0.txt
echo "" >> $OUT/phonesInSentencesConfiguration0.txt

echo "EX" >> $OUT/phonesInSentencesConfiguration1.txt
echo "IS sil sil" >> $OUT/phonesInSentencesConfiguration1.txt
echo "" >> $OUT/phonesInSentencesConfiguration1.txt

HLEd -A -D -T 1 -X phn.txt -l '*' -d $OUT/dictionaryWithShortPause.txt -i $OUT/phonesInTrainSentences0.txt $OUT/phonesInSentencesConfiguration0.txt $OUTList/wordsInTrainSentencesAURORA.txt

#echo "" >> $OUT/phonesInTrainSentences0.txt

HLEd -A -D -T 1 -X phn.txt -l '*' -d $OUT/dictionaryWithShortPause.txt -i $OUT/phonesInTrainSentences1.txt $OUT/phonesInSentencesConfiguration1.txt $OUTList/wordsInTrainSentencesAURORA.txt

#echo "" >> $OUT/phonesInTrainSentences1.txt

HLEd -A -D -T 1 -X phn.txt -l '*' -d $OUT/dictionaryWithShortPauseTest.txt -i $OUT/phonesInTestSentences0.txt $OUT/phonesInSentencesConfiguration0.txt $OUTList/wordsInTestSentencesAURORA.txt

sed -i 's/.stc.phn.txt/.phn.txt/g' $OUT/phonesInTestSentences0.txt
sed -i 's/.stc.phn.txt/.phn.txt/g' $OUT/phonesInTrainSentences1.txt
sed -i 's/.stc.phn.txt/.phn.txt/g' $OUT/phonesInTrainSentences0.txt

#*************************************************************************************************************************************************************************************#
#************************************ generating all posible triphonescombinations (and not only the ones in sentences) **************************************************************#


echo "*** Generating all popsible triphones ***"

cp $OUT/monophones1.txt $OUT/triphonesAllCombinations.txt

$sour/generateTriphones.py $OUT/monophones1.txt $OUT/triphonesAllCombinations.txt

touch $OUT/silenceConfiguration.txt

echo "AT 2 4 0.2 {sil.transP}" >> $OUT/silenceConfiguration.txt
echo "AT 4 2 0.2 {sil.transP}" >> $OUT/silenceConfiguration.txt
echo "AT 1 3 0.3 {sp.transP}" >> $OUT/silenceConfiguration.txt
echo "TI silst {sil.state[3],sp.state[2]}" >> $OUT/silenceConfiguration.txt

touch $OUT/modelCloneForTriphoneConfiguration.txt

echo "CL $OUT/triphones1.txt" >> $OUT/modelCloneForTriphoneConfiguration.txt

$sour/confSilence.py $OUT/monophones1.txt $OUT/modelCloneForTriphoneConfiguration.txt

touch $OUT/mergeSpSilConfiguration.txt

echo "ME sil sp sil" >> $OUT/mergeSpSilConfiguration.txt
echo "ME sil sil sil" >> $OUT/mergeSpSilConfiguration.txt
echo "ME sp sil sil" >> $OUT/mergeSpSilConfiguration.txt


touch  $OUT/triphoneConfiguration.txt

echo "WB sil" >> $OUT/triphoneConfiguration.txt
echo "WB sp" >> $OUT/triphoneConfiguration.txt

if [ $USE_CROSSWORD_TRIPHONE -eq 1 ]
then
echo "NB sp" >> $OUT/triphoneConfiguration.txt
fi

echo "TC" >> $OUT/triphoneConfiguration.txt

rm -rf $OUT/*.tmp

# in case to restart the process the archives .txt.tmp into the folder reconhecedor_CETUC/productsDatabase/DatabaseAURORA/DatabaseComplete8kHz/Train must be deleted "rm -rf *.tmp"
