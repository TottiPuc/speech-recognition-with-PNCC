#! /bin/bash 

################################################
#==============================================#
##### Christian Dayan Arcos Gordillo  ##########
#####       Reconhecimento de voz      #########
#####     christian@cetuc.puc-rio.br    ########
#######       CETUC - PUC - RIO       ##########
#==============================================#
################################################


nameDatabase="AURORA"
DictionaryPath="$1"ConvertDataBase$nameDatabase/CMU_dictionary/dicWlist5c.txt
SentencesPath="$1"ConvertDataBase$nameDatabase/trainList.txt
script=$2
resultPath="$1"

# clean files
rm -f $resultPath/dictionary.txt $resultPath/monophones.txt $resultPath/questions.txt $resultPath/sentences.txt


cat $DictionaryPath | 
tr -d "\r" |
sed 's/\t/  /g'|
sed '/#/d' |
sed '/./!d'|
sed 's/\///g'|
sed 's/\.//g'|
sed 's/1//g'|
sed 's/2//g'|
sed 's/[1-9]//g'|
sed 's/()//g' |
sed -e '$a PHILIPPINES  F IH L IH P IY N Z' |
sed -e '$a PHILIPS  F IH L AH P S' |
sed -e '$a PURCHASING  P ER CH AH S IH NG' |
sed -e '$a ROUTE  R AW T' |
sed -e '$a ROUTE  R UW T' |
sed -e '$a ROUTINE  R UW T IY N' |
sed -e '$a ROVER  R OW V ER' |
tr [[:upper:]] [[:lower:]] | sort | uniq > $resultPath/dictionary.txt

echo ""
echo "*** make monopones files (without short pauses) and questions file ***"
echo ""

touch $resultPath/monophones.txt $resultPath/questions.txt
$script/create_phones_questions.sh $resultPath

echo ""
echo "*** fix sentences list  ***"
echo ""

cat $SentencesPath | awk '{ $(NF)=""; print }' | awk '{ $(NF)=""; print }'|
sed 's/\.//g' |
sed 's/\?//g' |
sed 's/{//g' |
sed 's/}//g' |
sed 's/!//g' |
sed 's/%//g' |
sed 's/&//g' |
sed 's/\///g' |
sed 's/\://g' |
sed 's/\;//g' |
sed 's/\,//g' |
sed 's/\"//g' |
sed 's/\--//g' |
sed 's/\-/ /g' |
tr [[:upper:]] [[:lower:]] |
sed "s/'a'/a/g" |
sed "s/'chemical'/chemical/g" |
sed "s/'come/come/g" |
sed "s/settle'/settle/g" |
sed "s/'eighty/eighty/g" |
sed "s/'presented'/presented/g" |
sed "s/'single/single/g" |
sed "s/'the/the/g" |
sed "s/man'/man/g" |
sed "s/'what's/what's/g" |
sed "s/stuff'/stuff/g" |
sed "s/'up'/up/g" |
sed "s/'yeah/yeah/g" |
sed "s/wrong'/wrong/g" |
sed "s/(*)*//g"  > $resultPath/sentences.txt




