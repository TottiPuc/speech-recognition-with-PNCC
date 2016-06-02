#! /bin/bash 

################################################
#==============================================#
##### Christian Dayan Arcos Gordillo  ##########
#####       Reconhecimento de voz      #########
#####     christian@cetuc.puc-rio.br    ########
#######       CETUC - PUC - RIO       ##########
#==============================================#
################################################


nameDatabase="TIMIT"
DictionaryPath=$1/Doc/TIMITDIC.TXT
SentencesPath=$1/Doc/PROMPTS.TXT
resultPath="$2"
sour="$3"

cat $DictionaryPath | 
sed '/;/d' |  
sed "s/^'/\\\\'/g"|
#sed "s/^'/\\\\\\\\\'/g"|
sed -r '/bourgeois/ a bourgeoisie  b uh r zh w aa z iy'|
sed -r '/^line/ a lined  l ay n d'|
sed -r '/simmer/ a simmered  s ih m axr d'|
sed -r '/teems/ a teeny  t iy n iy'|
sed 's/\///g'|
sed 's/\.//g'|
sed 's/1//g'|
sed 's/2//g'|
sed 's/~n//g'|
sed 's/~v_past//g'|
sed 's/~v_pres//g'|
sed 's/~v//g'|
sed 's/~adj//g'|
sed '/^$/d' > $resultPath/dic.tmp

mv $resultPath/dic.tmp $resultPath/dictionary.txt

echo ""
echo "create new dictionary from phone transcriptions"
echo ""

#touch $resultPath/phones.tmp $resultPath/word.tmp


ls $resultPath/DatabaseComplet8KHz/Train/*.phn.txt > $resultPath/phones.tmp
ls $resultPath/DatabaseComplet8KHz/Train/*.wrd.txt > $resultPath/words.tmp

$sour/Creat_Dictionary2.py $resultPath/words.tmp $resultPath/phones.tmp $resultPath/dictionary2.tmp

cat $resultPath/dictionary.txt | while read line
do
	echo $line >> $resultPath/dictionary2.tmp
done 

cat $resultPath/dictionary2.tmp | sed 's/  / /g'| sed 's/ /  /g' | sed "s/^'/\\\\'/g" |sort |uniq > $resultPath/dictionary2.txt



echo ""
echo "*** make monopones files (without short pauses) and questions file ***"
echo ""

touch $resultPath/monophones.txt $resultPath/questions.txt
sh $sour/create_phones_questions.sh $resultPath

echo ""
echo "*** fix sentences list  ***"
echo ""

cat $SentencesPath |
sed '/;/d' |
sed 's/\.//g' |
sed 's/\?//g' |
sed 's/\://g' |
sed 's/\;//g' |
sed 's/\,//g' |
sed 's/\"//g' |
sed 's/\--//g' |
sed "s/'em/\\\'em/g" |
sed "s/(.*)//g" |
sed "s/ *$//g" |
tr [[:upper:]] [[:lower:]] > $resultPath/sentences.txt

#echo ""
#echo "*** remove all temporal files *.tmp  ***"
#echo ""

#rm -rf $resultPath/*.tmp



