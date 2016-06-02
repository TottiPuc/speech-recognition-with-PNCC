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

clear

USE_CROSSWORD_TRIPHONE=0
USE_PHONE_FILES_FOR_TRANSCRIPTION=0

echo " *** Making a monophones0 nad monophones1 files (without and with short pauses)****"

DB=$1/productsDatabase/DatabaseTIMIT
OUT=$1/products/htk/phonesTIMIT
OUTList=$1/products/htk
sour=$2/CreatePhones

#****************************************************************************************#
#************ make monophones0 and monophones1 files from monphones file  ***************#

cp $DB/monophones.txt $OUT/monophones0.tmp
cp $DB/monophones.txt $OUT/monophones1.tmp

cat $OUT/monophones0.tmp | tr -d "\r" > $OUT/monophones0.txt
cat $OUT/monophones1.tmp | tr -d "\r" > $OUT/monophones1.txt

rm -rf $OUT/monophones0.tmp $OUT/monophones1.tmp

echo "sil" >> $OUT/monophones0.txt
echo "sil" >> $OUT/monophones1.txt
echo "sp" >> $OUT/monophones1.txt

#****************************************************************************************#
#************  prepare special dictionary and wordnet for monophone test  ***************#

touch $OUT/dictionaryForPhonesTest.txt
touch $OUT/grammarPhones.txt

$sour/createPhones.py $OUT/monophones0.txt $OUT/dictionaryForPhonesTest.txt $OUT/grammarPhones.txt

HParse  $OUT/grammarPhones.txt $OUT/wordNetPhones.txt

echo ""
echo " *** Listing words of train/test sentences in MLF file ***"
echo ""

touch $OUTList/wordsInTrainSentencesTIMIT.tmp
touch $OUTList/wordsInTestSentencesTIMIT.tmp
touch $OUTList/TrainSentencesTIMIT.txt
touch $OUTList/TestSentencesTIMIT.txt

#train
echo "#!MLF!#" >> $OUTList/wordsInTrainSentencesTIMIT.tmp
find $DB/DatabaseComplet8KHz/Train/ -name "*stc.txt" | while read line
do
nam=`ls $line | cut -d '/' -f 9`
echo "\"*/$nam\"" >> $OUTList/wordsInTrainSentencesTIMIT.tmp
cat $line | tr -s " " "\012" >> $OUTList/wordsInTrainSentencesTIMIT.tmp
echo "." >> $OUTList/wordsInTrainSentencesTIMIT.tmp
sen=`cat $line`
echo "\"*/$nam\" $sen" >> $OUTList/TrainSentencesTIMIT.txt
done 
cat $OUTList/wordsInTrainSentencesTIMIT.tmp | tr -d "\r" | sed '/./!d' > $OUTList/wordsInTrainSentencesTIMIT.txt   #delet character ascii

#test
echo "#!MLF!#" >> $OUTList/wordsInTestSentencesTIMIT.tmp
find $DB/DatabaseComplet8KHz/Test/ -name "*stc.txt" | while read line
do
nam=`ls $line | cut -d '/' -f 9`
echo "\"*/$nam\"" >> $OUTList/wordsInTestSentencesTIMIT.tmp
cat $line | tr -s " " "\012" >> $OUTList/wordsInTestSentencesTIMIT.tmp
echo "." >> $OUTList/wordsInTestSentencesTIMIT.tmp
sen=`cat $line`
echo "\"*/$nam\" $sen" >> $OUTList/TestSentencesTIMIT.txt
done
cat $OUTList/wordsInTestSentencesTIMIT.tmp | tr -d "\r" | sed '/./!d' > $OUTList/wordsInTestSentencesTIMIT.txt   #delet character ascii

echo ""
echo " *** listing phones of /train/test sentences in MFL file***"
echo ""

touch $OUT/dictionaryWithShortPause.txt

cat $DB/dictionary.txt | sed 's/$/ sp/g' >> $OUT/dictionaryWithShortPause.txt
echo "!ENTER sil" >> $OUT/dictionaryWithShortPause.txt
echo "!EXIT sil" >> $OUT/dictionaryWithShortPause.txt

echo ""
echo " *** create a master label file manually, comparing phone and word file***"
echo ""

if [ $USE_PHONE_FILES_FOR_TRANSCRIPTION -eq 1 ]
then
touch $OUT/phonesInTrainSentences0.tmp
touch $OUT/phonesInTrainSentences1.tmp

echo "#!MLF!#" >> $OUT/phonesInTrainSentences0.tmp
echo "#!MLF!#" >> $OUT/phonesInTrainSentences1.tmp

ls $DB/DatabaseComplet8KHz/Train/*.phn.txt > $OUT/list1.tmp
ls $DB/DatabaseComplet8KHz/Train/*.wrd.txt > $OUT/list2.tmp

cat $OUT/list1.tmp | while read line2
do
nom=`ls $line2 | cut -d '/' -f 9`
echo "\"*/$nom\"" >> $OUT/phonesInTrainSentences0.tmp
cat $line2 >> $OUT/phonesInTrainSentences0.tmp
echo "." >> $OUT/phonesInTrainSentences0.tmp
#echo "\"*/$nam\"" >> $OUTList/phonesInTrainSentences1
done


$sour/createMasterLabels.py  $OUT/list2.tmp  $OUT/list1.tmp $OUT/phonesInTrainSentences1.tmp

cat $OUT/phonesInTrainSentences1.tmp | sed 's/\/home\/christianlab\/reconhecedor_CETUC\/productsDatabase\/DatabaseTIMIT\/DatabaseComplet8KHz\/Train//g' > $OUT/phonesInTrainSentences1.txt

echo "" >> $OUT/phonesInTrainSentences1.txt
echo "" >> $OUT/phonesInTrainSentences0.tmp
mv $OUT/phonesInTrainSentences0.tmp $OUT/phonesInTrainSentences0.txt

else

touch $OUT/phonesInSentencesConfiguration0.txt
touch $OUT/phonesInSentencesConfiguration1.txt

echo "EX" >> $OUT/phonesInSentencesConfiguration0.txt
echo "IS sil sil" >> $OUT/phonesInSentencesConfiguration0.txt
echo "DE sp" >> $OUT/phonesInSentencesConfiguration0.txt
echo "" >> $OUT/phonesInSentencesConfiguration0.txt

echo "EX" >> $OUT/phonesInSentencesConfiguration1.txt
echo "IS sil sil" >> $OUT/phonesInSentencesConfiguration1.txt
echo "" >> $OUT/phonesInSentencesConfiguration1.txt

HLEd -T 0 -X phn.txt -l '*' -d $OUT/dictionaryWithShortPause.txt -i $OUT/phonesInTrainSentences0.tmp $OUT/phonesInSentencesConfiguration0.txt $OUTList/wordsInTrainSentencesTIMIT.txt

#echo "" >> $OUT/phonesInTrainSentences0.tmp

HLEd -T 0 -X phn.txt -l '*' -d $OUT/dictionaryWithShortPause.txt -i $OUT/phonesInTrainSentences1.tmp $OUT/phonesInSentencesConfiguration1.txt $OUTList/wordsInTrainSentencesTIMIT.txt

#echo "" >> $OUT/phonesInTrainSentences1.tmp

HLEd -T 0 -X phn.txt -l '*' -d $OUT/dictionaryWithShortPause.txt -i $OUT/phonesInTestSentences0.tmp $OUT/phonesInSentencesConfiguration0.txt $OUTList/wordsInTestSentencesTIMIT.txt

echo "" >> $OUT/phonesInTestSentences0.tmp


cat $OUT/phonesInTrainSentences0.tmp | sed 's/stc.phn.txt/phn.txt/g' > $OUT/phonesInTrainSentences0.txt
cat $OUT/phonesInTrainSentences1.tmp | sed 's/stc.phn.txt/phn.txt/g' > $OUT/phonesInTrainSentences1.txt
cat $OUT/phonesInTestSentences0.tmp | sed 's/stc.phn.txt/phn.txt/g' > $OUT/phonesInTestSentences0.txt


fi

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

rm -f $OUT/*.tmp $OUTList/*.tmp










