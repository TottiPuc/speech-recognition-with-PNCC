#!/bin/bash

echo "creating folder files..."
resultfolder=reconecedor2
path=~/

mkdir -p $path"$resultfolder"/productsDatabase $path"$resultfolder"/products/htk/mfccAURORA $path"$resultfolder"/products/htk/mfccAURORA/featuresTest $path"$resultfolder"/products/htk/mfccAURORA/featuresTrain $path"$resultfolder"/products/htk/mfccAURORA/model  $path"$resultfolder"/products/htk/mfccAURORA/model/hmm1_start $path"$resultfolder"/products/htk/mfccAURORA/model/hmm2_monophones $path"$resultfolder"/products/htk/mfccAURORA/model/hmm3_triphones $path"$resultfolder"/products/htk/mfccAURORA/model/hmm4_triphonesMultistream  $path"$resultfolder"/products/htk/languageModel/AURORA $path"$resultfolder"/products/htk/phonesAURORA/dictionaryCMU   $path"$resultfolder"/resultsAURORA

echo "########################################################################################################"
echo "ATENTION: you should copy the database into the 'producsDatabase' folder, with the name 'DatabaseAURORA'"
echo "########################################################################################################"
echo ""
echo "your workstation is already this is the  path"
echo ""
tree $path"$resultfolder"
