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

IN=$1/products/htk/pnccAURORA
OUTMODEL=$1/products/htk/pnccAURORA/model
INPHONE=$1/products/htk/phonesAURORA
INHTK=$1/products/htk
DB=$2


NUMBRE_OF_REESTIMATIONS_FOR_CICLE=3

MIN_MIXTURE_STEPS=2
MAX_MIXTURE_STEPS=8

#************************  Create an initial HMM  ****************************#

echo "First HMM model"

HCompV -T 0 -C $IN/featureInfo.txt -f 0.01 -m -S $IN/trainFeaturesFiles.txt -M $OUTMODEL/hmm1_start/ $IN/proto.txt

#*************** Create macro file proto and vFloors files  *****************#

head -n 3 $OUTMODEL/hmm1_start/proto >$OUTMODEL/hmm1_start/macros
tail -n 27 $OUTMODEL/hmm1_start/proto > $OUTMODEL/hmm1_start/proto.tmp 
cat $OUTMODEL/hmm1_start/vFloors >> $OUTMODEL/hmm1_start/macros

#********** Create hmdefs (describing the HMM of heach monophone ************#

touch $OUTMODEL/hmm1_start/hmmdefs

cat $INPHONE/monophones0.txt | while read line
do
echo '~h "'$line'"' >> $OUTMODEL/hmm1_start/hmmdefs
cat $OUTMODEL/hmm1_start/proto.tmp >> $OUTMODEL/hmm1_start/hmmdefs
echo "" >> $OUTMODEL/hmm1_start/hmmdefs
done

# **************************** First reestimations **************************#

echo "*** Creating monophones models ***"

touch $INHTK/warningsAURORA.txt

for i in `seq 1 $NUMBRE_OF_REESTIMATIONS_FOR_CICLE`
do
echo "Re-estimation $i..."
HERest -A -D -T 1 -X phn.txt -L $DB -C $IN/featureInfo.txt -I $INPHONE/phonesInTrainSentences0.txt -t 250.0 150.0 1500.0 -S $IN/trainFeaturesFiles.txt -H $OUTMODEL/hmm1_start/macros -H $OUTMODEL/hmm1_start/hmmdefs -M $OUTMODEL/hmm1_start/ $INPHONE/monophones0.txt >> $INHTK/warningsAURORA.txt 
done

#******** Fix the silence (add short pauses) and more reestimations *********#

echo "*** Fixing the silence ***"

cp $OUTMODEL/hmm1_start/macros $OUTMODEL/hmm2_monophones/

touch $OUTMODEL/hmm2_monophones/hmmdefs 

readingSil=0
discardLines=0
spData_str=''
matrixLine=0

cat $OUTMODEL/hmm1_start/hmmdefs | while read line
do
echo $line >> $OUTMODEL/hmm2_monophones/hmmdefs
if [ $readingSil -eq 1 ];then
	if [ "$line" == '<NUMSTATES> 5' ]; then
		spData_str=$spData_str'<NUMSTATES> 3\n'
	elif [ "$line" == '<STATE> 2' ] || [ "$line" == '<STATE> 4' ]; then
		discardLines=1
	elif [ "$line" == '<STATE> 3' ]; then	
		discardLines=0
		spData_str=$spData_str'<STATE> 2\n'
	elif [ "$line" == '<TRANSP> 5' ]; then
		discardLines=0
		spData_str=$spData_str'<TRANSP> 3\n'
		matrixLine=1
	elif [ "$line" == '<ENDHMM>' ]; then
		readingSil=0
		spData_str=$spData_str'<ENDHMM>'
		echo -e $spData_str >> $OUTMODEL/hmm2_monophones/hmmdefs
	else
		if ! [ $discardLines -eq 1 ]; then
			if [ $matrixLine -gt 0 ]; then
				if [ $matrixLine -eq 2 ] || [ $matrixLine -eq 4 ]; then
					spData_str=$spData_str`echo $line | awk ' { print $1 " " $2 " " $3  } ' `
					spData_str=$spData_str'\n'
				elif [ $matrixLine -eq 3 ]; then
					spData_str=$spData_str`echo $line | awk ' { print $2 " " $3 " " $4  } ' `
					spData_str=$spData_str'\n'
				fi
				matrixLine=` expr $matrixLine + 1` 
			else
				spData_str=$spData_str`echo $line"\n"`
			fi
		fi
	fi
elif [ "$line" == '~h "sil"' ]; then
	
	readingSil=1
	spData_str=$spData_str'~h "sp"\n'
fi
done

HHEd -T 0 -H $OUTMODEL/hmm2_monophones/macros -H $OUTMODEL/hmm2_monophones/hmmdefs -M $OUTMODEL/hmm2_monophones/ $INPHONE/silenceConfiguration.txt $INPHONE/monophones1.txt >> $INHTK/warningsAURORA.txt


for i in `seq 1 $NUMBRE_OF_REESTIMATIONS_FOR_CICLE`
do
echo "Re-estimation $i..."
HERest -T 1 -X phn.txt -L $DB -C $IN/featureInfo.txt -I $INPHONE/phonesInTrainSentences1.txt -t 250.0 150.0 1500.0 -S $IN/trainFeaturesFiles.txt -H $OUTMODEL/hmm2_monophones/macros -H $OUTMODEL/hmm2_monophones/hmmdefs -M $OUTMODEL/hmm2_monophones/ $INPHONE/monophones1.txt >> $INHTK/warningsAURORA.txt
done

#*****************************************************************************************************************************#
#****************************  Make triphone models from monophones models  **************************************************#

echo "*** Making triphone models from monophone models***"

HLEd -l '*' -X txt -n $INPHONE/triphones1.txt -i $INPHONE/triphonesInTrainSentences1.txt $INPHONE/triphoneConfiguration.txt $INPHONE/phonesInTrainSentences1.txt >> $INHTK/warningsAURORA.txt

HHEd -T 0 -B -H $OUTMODEL/hmm2_monophones/macros -H $OUTMODEL/hmm2_monophones/hmmdefs -M $OUTMODEL/hmm3_triphones/ $INPHONE/modelCloneForTriphoneConfiguration.txt $INPHONE/monophones1.txt >> $INHTK/warningsAURORA.txt

for i in `seq 1 $NUMBRE_OF_REESTIMATIONS_FOR_CICLE`
do
echo "Re-estimation $i..."
extraParameter_str=''

if [ $i -eq $NUMBRE_OF_REESTIMATIONS_FOR_CICLE ];then
	extraParameter_str=$extraParameter_strls' -s '$IN/statsFile.txt
fi
 
HERest -T 0 -B -X phn.txt -L $DB $extraParameter_str -C $IN/featureInfo.txt -I $INPHONE/triphonesInTrainSentences1.txt -t 250.0 150.0 1500.0 -S $IN/trainFeaturesFiles.txt -H $OUTMODEL/hmm3_triphones/macros -H $OUTMODEL/hmm3_triphones/hmmdefs -M $OUTMODEL/hmm3_triphones/ $INPHONE/triphones1.txt >> $INHTK/warningsAURORA.txt
done

#************************************************************************************************************************#
#************************************ Tied-states triphones *************************************************************#

echo "***  Tying triphones ***"

touch $IN/tiedStateConfiguration.txt
echo "RO 200 $IN/statsFile.txt" >> $IN/tiedStateConfiguration.txt
echo "TR 0" >> $IN/tiedStateConfiguration.txt

cat $1/productsDatabase/DatabaseAURORA/questions.txt >> $IN/tiedStateConfiguration.txt


cat $INPHONE/monophones1.txt | while read line
do
echo 'QS "R_'$line'" {*+'$line'}' >> $IN/tiedStateConfiguration.txt
done


cat $INPHONE/monophones1.txt | while read line
do
echo 'QS "L_'$line'" {'$line'-*}' >> $IN/tiedStateConfiguration.txt
done

		
for i in `seq 2 4`
do
	cat $INPHONE/monophones1.txt | while read line
	do
	echo 'TB 750 "ST_'$line'_'$i'_" {("'$line'","*-'$line'+*","'$line'+*","*-'$line'").state['$i']}' >> $IN/tiedStateConfiguration.txt
	done
done

echo "TR 1" >> $IN/tiedStateConfiguration.txt
echo "AU $INPHONE/triphonesAllCombinations.txt" >> $IN/tiedStateConfiguration.txt
echo "CO $IN/triphonesTied.txt" >> $IN/tiedStateConfiguration.txt
echo "ST $IN/trees.txt" >> $IN/tiedStateConfiguration.txt

HHEd -T 0 -B -H $OUTMODEL/hmm3_triphones/macros -H $OUTMODEL/hmm3_triphones/hmmdefs -M $OUTMODEL/hmm3_triphones/ $IN/tiedStateConfiguration.txt $INPHONE/triphones1.txt >> $INPHONE/tiedLog.txt


for i in `seq 1 $NUMBRE_OF_REESTIMATIONS_FOR_CICLE`
do
echo "Re-estimation $i..."
HERest -T 0 -B -X phn.txt -L $DB -C $IN/featureInfo.txt -I $INPHONE/triphonesInTrainSentences1.txt -t 250.0 150.0 1500.0 -S $IN/trainFeaturesFiles.txt -H $OUTMODEL/hmm3_triphones/macros -H $OUTMODEL/hmm3_triphones/hmmdefs -M $OUTMODEL/hmm3_triphones/ $IN/triphonesTied.txt >> $INHTK/warningsAURORA.txt
done

#***********************************************************************************************************************#
#****************************** Multistream gaussians (add mixture) for triphones *************************************#

touch $INHTK/addMixtureConfigurationAURORA.txt

for i in `seq $MIN_MIXTURE_STEPS $MAX_MIXTURE_STEPS`
do
echo "*** Triphone Mixture $i... ***"
echo "MU $i {*.state[2-4].mix}" >> $INHTK/addMixtureConfigurationAURORA.txt

if [ $i -eq 2 ];then
	HHEd -T 0 -B -H $OUTMODEL/hmm3_triphones/macros -H $OUTMODEL/hmm3_triphones/hmmdefs -M $OUTMODEL/hmm4_triphonesMultistream/ $INHTK/addMixtureConfigurationAURORA.txt $IN/triphonesTied.txt >> $INHTK/warningsAURORA.txt

else
	HHEd -T 0 -B -H $OUTMODEL/hmm4_triphonesMultistream/macros -H $OUTMODEL/hmm4_triphonesMultistream/hmmdefs -M $OUTMODEL/hmm4_triphonesMultistream/ $INHTK/addMixtureConfigurationAURORA.txt $IN/triphonesTied.txt >> $INHTK/warningsAURORA.txt
fi

for j in `seq 1 $NUMBRE_OF_REESTIMATIONS_FOR_CICLE`
do
echo "Re-estimation $j..."
HERest -T 0 -B -X phn.txt -L $DB -C $IN/featureInfo.txt -I $INPHONE/triphonesInTrainSentences1.txt -t 250.0 150.0 1500.0 -S $IN/trainFeaturesFiles.txt -H $OUTMODEL/hmm4_triphonesMultistream/macros -H $OUTMODEL/hmm4_triphonesMultistream/hmmdefs -M $OUTMODEL/hmm4_triphonesMultistream/ $IN/triphonesTied.txt >> $INHTK/warningsAURORA.txt
done	


done


