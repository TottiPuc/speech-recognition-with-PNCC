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

echo " .. Creating Language Model .. "
LM=$1/products/htk/languageModel/TIMIT
DB=$1/productsDatabase/DatabaseTIMIT
sour=$2/CreateLanguageModel
touch  $LM/LanguageModelParameters
touch  $LM/wordMap
touch  $LM/wordsOfDictionary
touch  $LM/OOVWordMap
touch  $LM/unigramsAux
touch  $LM/bigramsAux
touch  $LM/trigramsAux



	echo "HMEM: STARTWORD = '!ENTER'" > $LM/LanguageModelParameters       
	echo "HMEM: ENDWORD = '!EXIT'" >> $LM/LanguageModelParameters


LNewMap -f WFC Sentences $LM/emptyLanguageModel

LGPrep -C  $LM/LanguageModelParameters -a 1000000 -b 2000000 -n 3 -s "Language Model" -d $LM/ -w $LM/wordMap $LM/emptyLanguageModel $DB/sentences.txt

#LGList $LM/wordMap $LM/gram.0 | more

LGCopy -C $LM/LanguageModelParameters -b 2000000 -d $LM/ $LM/wordMap $LM/gram.0

$sour/separateDictionary.py $DB/dictionary.txt $LM/wordsOfDictionary 

LSubset -a 10000 -C $LM/LanguageModelParameters $LM/wordMap $LM/wordsOfDictionary $LM/OOVWordMap

################################################################################################
#################   Build language models: unigrams, bigrams and trigrams  #####################


LBuild -C $LM/LanguageModelParameters -f TEXT -n 1 $LM/OOVWordMap $LM/unigramsAux $LM/data.0
LBuild -C $LM/LanguageModelParameters -f TEXT -c 2 0 -n 2 $LM/OOVWordMap $LM/bigramsAux $LM/data.0
LBuild -C $LM/LanguageModelParameters -f TEXT -c 2 0 -c 3 0 -n 3 $LM/OOVWordMap $LM/trigramsAux $LM/data.0

LNorm -f TEXT $LM/unigramsAux $LM/unigrams
LNorm -f TEXT $LM/bigramsAux $LM/bigrams
LNorm -f TEXT $LM/trigramsAux $LM/trigrams
########################## For HTK Windows  ##################################################
LNorm -f TEXT $LM/unigramsAux $LM/unigrams.txt
LNorm -f TEXT $LM/bigramsAux $LM/bigrams.txt
LNorm -f TEXT $LM/trigramsAux $LM/trigrams.txt


################################################################################################
#######################   replace Replace strange characters   #################################

sed -i "s/'em/\\\'em/g" $LM/unigrams
sed -i "s/'em/\\\'em/g" $LM/bigrams
sed -i "s/'em/\\\'em/g" $LM/trigrams
######################### For HTK Windows  ###################################################
sed -i "s/'em/\\\'em/g" $LM/unigrams.txt
sed -i "s/'em/\\\'em/g" $LM/bigrams.txt
sed -i "s/'em/\\\'em/g" $LM/trigrams.txt


################################################################################################
#####################  Build wordnets (not for trigrams, since they ar  ########################
##################  supported only by HDecode, wich uses trigrams directly  ####################

HBuild -T 0 -z -u '!!UNK' -s '!ENTER' '!EXIT' -n $LM/unigrams $LM/wordsOfDictionary $LM/wordNetUnigrams
HBuild -T 0 -z -u '!!UNK' -s '!ENTER' '!EXIT' -n $LM/bigrams $LM/wordsOfDictionary $LM/wordNetBigrams








