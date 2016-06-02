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

OUTMODEL=$1/products/htk/pnccAURORA/model
INPHONE=$1/products/htk/phonesAURORA
IN=$1/products/htk/pnccAURORA
INHTK=$1/products/htk/languageModel/AURORA
DB=$2
RESULT=$1/products/htk

TEST_PHONE_RECOGNITION=0
USE_HVITE_FOR_WORDS=0     #otherwise, use HDecode (better, but slower)
GRAMMAR_SCALE_FACTOR=15

#*********************************************************************************************************************#
#************************************** Evaluate recognition  ********************************************************#

if [ $TEST_PHONE_RECOGNITION -eq 1 ];then

echo "*** recognizing phones in sentences ***"

HVite -B -T 1 -H -p 0.0 -s 5.0 -H $OUTMODEL/hmm4_triphonesMultistream/macros -H $OUTMODEL/hmm4_triphonesMultistream/hmmdefs -S $IN/testFeaturesFiles.txt -i $IN/testRecognizedPhones.txt -w $INHTK/wordNetPhones.txt $INPHONE/dictionaryWithShortPause.txt $IN/triphonesTied.txt

fi


echo "*** Recognizing words in sentences ***"

if [ $USE_HVITE_FOR_WORDS -eq 1 ]; then

HVite -B -T 1 -p 4.0 -s 15.0 -H $OUTMODEL/hmm4_triphonesMultistream/macros -H $OUTMODEL/hmm4_triphonesMultistream/hmmdefs -S $IN/testFeaturesFiles.txt -i $IN/testRecognizedWords.txt -w $INHTK/wordNetBigrams.txt $INPHONE/dictionaryWithShortPause.txt $IN/triphonesTied.txt

else

HDecode -T 1 -t 420.0 420.0 -s 15.0 -C $IN/HDecodeParameters.txt -H $OUTMODEL/hmm4_triphonesMultistream/macros -H $OUTMODEL/hmm4_triphonesMultistream/hmmdefs -S $IN/testFeaturesFiles.txt -i $IN/testRecognizedWords.txt -w $INHTK/trigrams.txt $INPHONE/dictionaryWithShortPause.txt $IN/triphonesTied.txt
 
fi

#*********************************************************************************************************************#
#********************************* Delete !ENTER and !EXIT from recognitions *****************************************#

cat $IN/testRecognizedWords.txt | sed '/!ENTER/d' | sed '/!EXIT/d' > $IN/testRecognizedWords2.txt

#*********************************************************************************************************************#
#******************* print the results in files, adding the current time on their name********************************#

echo "***  Evaluating results ***"

clock=`date +'%F %H:%M:%S'`


if [ $TEST_PHONE_RECOGNITION -eq 1  ];then

# print results on file
HResults -T 1 -X phn.txt -L $DB -I $INPHONE/phonesInTestSentences0.txt $IN/triphonesTied.txt $IN/testRecognizedPhones.txt >> $IN/testResultsPhones.txt

#print results on screen
HResults -T 1 -X phn.txt -L $DB -I $INPHONE/phonesInTestSentences0.txt $IN/triphonesTied.txt $IN/testRecognizedPhones.txt  

fi

HResults -T 1 -f -X stc.txt -L $DB -I $RESULT/wordsInTestSentencesAURORA.txt $INPHONE/monophones1.txt  $IN/testRecognizedWords2.txt >> $IN/testResultsWords.txt

HResults -T 1 -X stc.txt -L $DB -I $RESULT/wordsInTestSentencesAURORA.txt $INPHONE/monophones1.txt  $IN/testRecognizedWords2.txt





