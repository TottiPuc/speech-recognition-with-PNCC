#! /bin/bash 

################################################
#==============================================#
##### Christian Dayan Arcos Gordillo  ##########
#####       Reconhecimento de voz      #########
#####     christian@cetuc.puc-rio.br    ########
#######       CETUC - PUC - RIO       ##########
#==============================================#
################################################

clear

###############   main variables   ######################
Database="TIMIT"
PathProducts=$1/Test
testFolder=$1/smallTest/
start=1
##########################################################
echo ""
echo ""
echo "how many sentences do you want to test?... "
read Sentences

ls $PathProducts/*.wav | while read line
do
	cp  $line $testFolder
	if [ $start -ge $Sentences ]; then
                break
	else
		start=`expr $start + 1`
	fi
done
		
ls $PathProducts/*.phn.txt | while read line
do
        cp $line $testFolder
	if [ $start -ge $Sentences ]; then
                break
        fi
		start=`expr $start + 1`
done

ls $PathProducts/*.wrd.txt | while read line
do
        cp $line $testFolder
	if [ $start -ge $Sentences ]; then
                break
        else
		start=`expr $start + 1`
        fi
done

ls $PathProducts/*.stc.txt | while read line
do
        cp $line $testFolder
	if [ $start -ge $Sentences ]; then
                break
        else
		start=`expr $start + 1`
        fi
done


