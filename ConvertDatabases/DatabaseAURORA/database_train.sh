#! /bin/bash 

################################################
#==============================================#
##### Christian Dayan Arcos Gordillo  ##########
#####       Reconhecimento de voz      #########
#####     christian@cetuc.puc-rio.br    ########
#######       CETUC - PUC - RIO       ##########
#==============================================#
################################################

pathTrainFile="$1"ConvertDataBaseAURORA/csr_1_senn_d2/11-13.1/wsj0/doc/indices/train/tr_s_wv1.ndx
TrainFiles="$1"ConvertDataBaseAURORA/csr_1_senn_d1/
pathTrainSource="$1"DatabaseComplete8kHz
TrainRaw="$1"ConvertDataBaseAURORA

if [ -d $pathTrainSource ]; then
	rm -r $pathTrainSource
	rm -r $TrainRaw/list.tmp $TrainRaw/promptx.tmp $TrainRaw/trainList.tmp $TrainRaw/trainList.txt  $TrainRaw/listTest.tmp $TrainRaw/promptxTest.tmp $TrainRaw/TestList.txt
	echo "entro train"
	sleep 2
fi

##sentence=1
mkdir -p $pathTrainSource/Train 

# delete sentences adaptatives
find "$1"ConvertDataBaseAURORA/promp_train_si_tr_s/ -name *.ptx  | sed '/a0100/d' | while read line
do
cat $line | sed '/./!d' >> $TrainRaw/promptx.tmp
done

cat $pathTrainFile |sed '/;/d'| sed 's/.wv1//g' | sed '/11_2_1:wsj0\/si_tr_s\/401\//d' | cut -d / -f 4 > $TrainRaw/list.tmp

fgrep -f $TrainRaw/list.tmp $TrainRaw/promptx.tmp > $TrainRaw/trainList.tmp

cat $TrainRaw/trainList.tmp | sed 's/exisiting/existing/g' > $TrainRaw/trainList.txt


cat $pathTrainFile |sed '/;/d'| sed 's/wv1/wav/g' | sed '/11_2_1:wsj0\/si_tr_s\/401\//d'| sed 's/_/-/' | sed 's/_/\./' | sed 's/:/\//' | sed "s|^|$TrainFiles|g" | while read line
do
speaker=`echo $line | cut -d "/" -f 12` 
sentence=`echo $line | cut -d "/" -f 13 | sed 's/.wav//g'`
#sox $line -r 8000 $pathTrainSource/Train/speaker"$speaker"_sentence"$sentence".wav   # se for convertir pra 8kz desde o começo tire o # dessa linha e comente a seguinte
cp $line $pathTrainSource/Train/speaker"$speaker"_sentence"$sentence".wav   # se for convertir pra 8kz desde o começo comente essa linha e descomente a linha de emcima
cat $TrainRaw/trainList.txt | grep $sentence > $pathTrainSource/Train/speaker"$speaker"_sentence"$sentence".txt
#sentence=`expr $sentence + 1`
done

find $pathTrainSource/Train/ -name "*.txt" | while read line
do
sen=`echo $line | cut -d "/" -f 9 | sed 's/.txt//g'`
cat $line | awk '{ $(NF)=""; print }' | awk '{ $(NF)=""; print }'|
#sed "s/...................................$//g"|
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
sed "s/'em/\\\'em/g" |
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
sed "s/(*)*//g"  > $pathTrainSource/Train/$sen.stc.txt
done






