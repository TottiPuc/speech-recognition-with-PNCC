#!/bin/bash

################################################
#==============================================#
##### Christian Dayan Arcos Gordillo  ##########
#####         speech recognition       #########
#####     christian@cetuc.puc-rio.br    ########
#######       CETUC - PUC - RIO       ##########
#==============================================#
################################################

clear

###############   main variables   ######################
Database="AURORA"
Path_files=$1/OriginalDataBase"$Database"/
Out=$1/productsDatabase/DatabaseAURORA/
sour=$2/ConvertDatabases/DatabaseAURORA
decision=Y

echo "do you want overwrite the existing databasew Y/n?"

read opcion
if [ "$opcion" == "$decision" ]; then

echo "."
echo "copying the original database files"
echo "."
cp -r $Path_files $Out
rm -r $Out/ConvertDataBaseAURORA/
mv $Out/OriginalDataBaseAURORA/ $Out/ConvertDataBaseAURORA/
sleep 10
echo "."
echo "start converting audios WV1 to wav"
echo "."

$sour/script_ConvertDatabase.sh $Out/ConvertDataBaseAURORA/

echo "."
echo "end of the process"
echo "."
fi

echo "."
echo "creating sentences from database training "
echo "."
sleep 10

$sour/database_train.sh $Out

echo "."
echo "creating sentences from database test"
echo "."

$sour/database_test.sh $Out

echo "."
echo "creating dictionary, monophones and fixing sentences for training"
echo "."

$sour/fix_Dictionary.sh $Out $sour
