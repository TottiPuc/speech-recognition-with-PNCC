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


echo " .. Creating Language Model .. "
LM=~/reconhecedor_CETUC/products/htk/languageModel/AURORA
DB=~/reconhecedor_CETUC/productsDatabase/DatabaseAURORA
#:<<pol
mkdir -p  $LM
touch  $LM/LanguageModelParameters
touch  $LM/wordMap
touch  $LM/wordsOfDictionary
touch  $LM/OOVWordMap
touch  $LM/unigramsAux
touch  $LM/bigramsAux
touch  $LM/trigramsAux



	echo "HMEM: STARTWORD = '!ENTER'" > $LM/LanguageModelParameters       
	echo "HMEM: ENDWORD = '!EXIT'" >> $LM/LanguageModelParameters

cat $DB/sentencesLMTrain |
sed 's/\.//g' |
sed 's/\?//g' |
sed 's/{//g' |
sed 's/}//g' |
sed 's/!//g' |
sed 's/%//g' |
sed 's/&//g' |
sed 's/\$//g' |
sed 's/\///g' |
sed 's/\://g' |
sed 's/\;//g' |
sed 's/\,//g' |
sed 's/\"//g' |
sed 's/\--//g' |
sed 's/*//g' |
sed 's/\\//g' |
sed 's/[0-9]//g' |
sed "s/'til/\\\'til/g" |
sed "s/'cause/\\\'cause/g" |
sed "s/'n/\\\'n/g" |
sed "s/'em/\\\'em/g" > $DB/sentencesLM.txt


LNewMap -f WFC Sentences $LM/emptyLanguageModel

LGPrep -C  $LM/LanguageModelParameters -a 1000000 -b 2000000 -n 3 -s "Language Model" -d $LM/ -w $LM/wordMap $LM/emptyLanguageModel $DB/sentencesLM.txt

#LGList $LM/wordMap $LM/gram.0 | more

LGCopy -C $LM/LanguageModelParameters -b 2000000 -d $LM/ $LM/wordMap $LM/gram.*

cat $DB/dic5k.txt | tr [[:upper:]] [[:lower:]] >> $LM/wordsOfDictionary 
echo "!ENTER" >> $LM/wordsOfDictionary 
echo "!EXIT" >> $LM/wordsOfDictionary

LSubset -T 1 -a 1000000 -C $LM/LanguageModelParameters $LM/wordMap $LM/wordsOfDictionary $LM/OOVWordMap

################################################################################################
#################   Build language models: unigrams, bigrams and trigrams  #####################


LBuild -C $LM/LanguageModelParameters -f TEXT -n 1 $LM/OOVWordMap $LM/unigramsAux $LM/data.*
LBuild -C $LM/LanguageModelParameters -f TEXT -c 2 0 -n 2 $LM/OOVWordMap $LM/bigramsAux $LM/data.*
LBuild -C $LM/LanguageModelParameters -f TEXT -c 2 0 -c 3 0 -n 3 $LM/OOVWordMap $LM/trigramsAux $LM/data.*

LNorm -f TEXT $LM/unigramsAux $LM/unigrams
LNorm -f TEXT $LM/bigramsAux $LM/bigrams
LNorm -f TEXT $LM/trigramsAux $LM/trigrams
########################## For HTK Windows  ##################################################
LNorm -f TEXT $LM/unigramsAux $LM/unigrams.txt
LNorm -f TEXT $LM/bigramsAux $LM/bigrams.txt
LNorm -f TEXT $LM/trigramsAux $LM/trigrams.txt


################################################################################################
#######################   replace Replace strange characters   #################################

sed -i "s/'apostrophe/\\\'apostrophe/g" $LM/unigrams
sed -i "s/'bout/\\\'bout/g" $LM/unigrams
sed -i "s/'cause/\\\'cause/g" $LM/unigrams
sed -i "s/'course/\\\'course/g" $LM/unigrams
sed -i "s/'cuse/\\\'cuse/g" $LM/unigrams
sed -i "s/'em/\\\'em/g" $LM/unigrams
sed -i "s/'frisco/\\\'frisco/g" $LM/unigrams
sed -i "s/'gain/\\\'gain/g" $LM/unigrams
sed -i "s/'kay/\\\'kay/g" $LM/unigrams
sed -i "s/'m/\\\'m/g" $LM/unigrams
sed -i "s/'n/\\\'n/g" $LM/unigrams
sed -i "s/'round/\\\'round/g" $LM/unigrams
sed -i "s/'til/\\\'til/g" $LM/unigrams
sed -i "s/'tis/\\\'tis/g" $LM/unigrams
sed -i "s/'twas/\\\'twas/g" $LM/unigrams
sed -i "s/'apostrophe/\\\'apostrophe/g" $LM/bigrams
sed -i "s/'bout/\\\'bout/g" $LM/bigrams
sed -i "s/'cause/\\\'cause/g" $LM/bigrams
sed -i "s/'course/\\\'course/g" $LM/bigrams
sed -i "s/'cuse/\\\'cuse/g" $LM/bigrams
sed -i "s/'em/\\\'em/g" $LM/bigrams
sed -i "s/'frisco/\\\'frisco/g" $LM/bigrams
sed -i "s/'gain/\\\'gain/g" $LM/bigrams
sed -i "s/'kay/\\\'kay/g" $LM/bigrams
sed -i "s/'m/\\\'m/g" $LM/bigrams
sed -i "s/'n/\\\'n/g" $LM/bigrams
sed -i "s/'round/\\\'round/g" $LM/bigrams
sed -i "s/'til/\\\'til/g" $LM/bigrams
sed -i "s/'tis/\\\'tis/g" $LM/bigrams
sed -i "s/'twas/\\\'twas/g" $LM/bigrams
sed -i "s/'apostrophe/\\\'apostrophe/g" $LM/trigrams
sed -i "s/'bout/\\\'bout/g" $LM/trigrams
sed -i "s/'cause/\\\'cause/g" $LM/trigrams
sed -i "s/'course/\\\'course/g" $LM/trigrams
sed -i "s/'cuse/\\\'cuse/g" $LM/trigrams
sed -i "s/'em/\\\'em/g" $LM/trigrams
sed -i "s/'frisco/\\\'frisco/g" $LM/trigrams
sed -i "s/'gain/\\\'gain/g" $LM/trigrams
sed -i "s/'kay/\\\'kay/g" $LM/trigrams
sed -i "s/'m/\\\'m/g" $LM/trigrams
sed -i "s/'n/\\\'n/g" $LM/trigrams
sed -i "s/'round/\\\'round/g" $LM/trigrams
sed -i "s/'til/\\\'til/g" $LM/trigrams
sed -i "s/'tis/\\\'tis/g" $LM/trigrams
sed -i "s/'twas/\\\'twas/g" $LM/trigrams
####################### For HTK Windows  ###################################################
sed -i "s/'apostrophe/\\\'apostrophe/g" $LM/unigrams.txt
sed -i "s/'bout/\\\'bout/g" $LM/unigrams.txt
sed -i "s/'cause/\\\'cause/g" $LM/unigrams.txt
sed -i "s/'course/\\\'course/g" $LM/unigrams.txt
sed -i "s/'cuse/\\\'cuse/g" $LM/unigrams.txt
sed -i "s/'em/\\\'em/g" $LM/unigrams.txt
sed -i "s/'frisco/\\\'frisco/g" $LM/unigrams.txt
sed -i "s/'gain/\\\'gain/g" $LM/unigrams.txt
sed -i "s/'kay/\\\'kay/g" $LM/unigrams.txt
sed -i "s/'m/\\\'m/g" $LM/unigrams.txt
sed -i "s/'n/\\\'n/g" $LM/unigrams.txt
sed -i "s/'round/\\\'round/g" $LM/unigrams.txt
sed -i "s/'til/\\\'til/g" $LM/unigrams.txt
sed -i "s/'tis/\\\'tis/g" $LM/unigrams.txt
sed -i "s/'twas/\\\'twas/g" $LM/unigrams.txt
sed -i "s/'apostrophe/\\\'apostrophe/g" $LM/bigrams.txt
sed -i "s/'bout/\\\'bout/g" $LM/bigrams.txt
sed -i "s/'cause/\\\'cause/g" $LM/bigrams.txt
sed -i "s/'course/\\\'course/g" $LM/bigrams.txt
sed -i "s/'cuse/\\\'cuse/g" $LM/bigrams.txt
sed -i "s/'em/\\\'em/g" $LM/bigrams.txt
sed -i "s/'frisco/\\\'frisco/g" $LM/bigrams.txt
sed -i "s/'gain/\\\'gain/g" $LM/bigrams.txt
sed -i "s/'kay/\\\'kay/g" $LM/bigrams.txt
sed -i "s/'m/\\\'m/g" $LM/bigrams.txt
sed -i "s/'n/\\\'n/g" $LM/bigrams.txt
sed -i "s/'round/\\\'round/g" $LM/bigrams.txt
sed -i "s/'til/\\\'til/g" $LM/bigrams.txt
sed -i "s/'tis/\\\'tis/g" $LM/bigrams.txt
sed -i "s/'twas/\\\'twas/g" $LM/bigrams.txt
sed -i "s/'apostrophe/\\\'apostrophe/g" $LM/trigrams.txt
sed -i "s/'bout/\\\'bout/g" $LM/trigrams.txt
sed -i "s/'cause/\\\'cause/g" $LM/trigrams.txt
sed -i "s/'course/\\\'course/g" $LM/trigrams.txt
sed -i "s/'cuse/\\\'cuse/g" $LM/trigrams.txt
sed -i "s/'em/\\\'em/g" $LM/trigrams.txt
sed -i "s/'frisco/\\\'frisco/g" $LM/trigrams.txt
sed -i "s/'gain/\\\'gain/g" $LM/trigrams.txt
sed -i "s/'kay/\\\'kay/g" $LM/trigrams.txt
sed -i "s/'m/\\\'m/g" $LM/trigrams.txt
sed -i "s/'n/\\\'n/g" $LM/trigrams.txt
sed -i "s/'round/\\\'round/g" $LM/trigrams.txt
sed -i "s/'til/\\\'til/g" $LM/trigrams.txt
sed -i "s/'tis/\\\'tis/g" $LM/trigrams.txt
sed -i "s/'twas/\\\'twas/g" $LM/trigrams.txt

################################################################################################
#####################  Build wordnets (not for trigrams, since they ar  ########################
##################  supported only by HDecode, wich uses trigrams directly  ####################
#pol

HBuild -T 1 -z -u '!!UNK' -s '!ENTER' '!EXIT' -n $LM/unigrams $LM/wordsOfDictionary $LM/wordNetUnigrams
HBuild -T 0 -z -u '!!UNK' -s '!ENTER' '!EXIT' -n $LM/bigrams $LM/wordsOfDictionary $LM/wordNetBigrams








