#! /bin/bash

################################################
#==============================================#
##### Christian Dayan Arcos Gordillo  ##########
#####       Reconhecimento de voz      #########
#####     christian@cetuc.puc-rio.br    ########
#######       CETUC - PUC - RIO       ##########
#==============================================#
################################################

###############  Configuration variables  ######################
nameDatabase="$1"
Train_Teste="$2"
ProductsDatabas="$3"
Dictionary="$4"
###############################################################
echo ""
echo "###########################################################"
echo "."
echo " creating training , test and configuration files"
echo "."
echo "###########################################################"
rm -rf $Train_Teste $ProductsDatabas
mkdir -p  $Train_Teste $ProductsDatabas
mkdir -p  $Train_Teste/Train $Train_Teste/Test $Train_Teste/Doc
mkdir -p  $ProductsDatabas/Train/ $ProductsDatabas/Test/ $ProductsDatabas/smallTest/  
touch  $Dictionary/monophones.txt $Dictionary/dictionary.txt $Dictionary/dictionary2.txt $Dictionary/questions.txt $Dictionary/sentences.txt
clear
echo "..."
echo " copying backup files from the original databases"
echo "..."
cp ~/Documentos/OriginalDatabasesBackup/timitComplete/DOC/*  ~/reconhecedor_CETUC/OriginalDataBases$nameDatabase/Doc
cp -r  ~/Documentos/OriginalDatabasesBackup/timitComplete/TEST/*  ~/reconhecedor_CETUC/OriginalDataBases$nameDatabase/Test
cp -r ~/Documentos/OriginalDatabasesBackup/timitComplete/TRAIN/*  ~/reconhecedor_CETUC/OriginalDataBases$nameDatabase/Train
echo""

