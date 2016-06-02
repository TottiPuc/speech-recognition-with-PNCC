#!/bin/bash
#put in resultfolder the name you want, for your destination folder results ex. recognizer
resultfolder=reconecedor_PNCC
IN=~/$resultfolder/productsDatabase/DatabaseAURORA/DatabaseComplete8kHz/Test/clean/
ResulpathIn=~/$resultfolder/products/htk/pnccAURORA/testResultsWords.txt
ResulpathOut=~/$resultfolder/resultsAURORA

ls $IN | while read line 
do
echo "cleaning features and configuration files for test"

path=`pwd`

rm -r $path/loadPNCCTestAURORA $path/htkTestAURORA

echo "testing aurora database"

make FOLDEROUT=$resultfolder DATATEST=$IN$line/ loadPNCCTestAURORA

echo "paso"
sleep 5

make FOLDEROUT=$resultfolder DATATEST=$IN$line/ htkTestAURORA

name=`echo $IN$line | cut -d '/' -f 9-10 | sed 's/\//_/g'`

cp $ResulpathIn  $ResulpathOut/"baseline_"$name".txt"

done
