#! /bin/bash 

################################################
#==============================================#
##### Christian Dayan Arcos Gordillo  ##########
#####       speech recognition         #########
#####     christian@cetuc.puc-rio.br    ########
#######       CETUC - PUC - RIO       ##########
#==============================================#
################################################

clear

###############   main variables   ######################
decision="Yes"
in=$1
##########################################################

echo ""
echo "#####################  WARNING# ###########################"
echo "."
echo    "  you will overwrite the training and testing folders
                 are you sure about that?"
echo   " if u are sure type but otherwise press Enter"
echo "."
echo "###########################################################"
echo ""
echo "Type Yes to continue or press Enter to exit: "

if [ ! -d $in ]; then
	echo "..erro.."
	echo "...enter the directory with the database..."
	echo ""
	exit 999
fi
read digite
if [ "$digite" == "$decision" ]; then

	find $in -name "*.wv1" | while read line

	do
	sph2pipe -f wav $line >> $line.wav
	done

	find $in -name "*wv1.wav" | while read file

	do
	if [ "$file" != "${file/\.wv1\.wav/.wav}" ];then
		mv "$file" "${file/\.wv1\.wav/.wav}"
	else
		echo " the database had already been processed "
	fi
	done
	find $in -name "*.wv1" | while read file

	do
	rm  -rf "$file" 
	done

fi

