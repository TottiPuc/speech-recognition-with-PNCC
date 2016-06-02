SHELL:=/bin/bash
#############################################################################################
PATHSCRIPTS=`pwd`
PATHPRODUCTOS=~/$(FOLDEROUT)
PATHPRODUCTOSCORRUPTED=~/$(FOLDEROUT)/productsDatabase/DatabaseAURORA/DatabaseCorrupted8kHz/Test/
#############################################################################################
#****************************** products **************************************************#

DBAURORA=$(PATHPRODUCTOS)/productsDatabase/DatabaseAURORA/*.txt
PHAURORA=$(PATHPRODUCTOS)/products/htk/phonesAURORA/*.txt

#############################################################################################
#******************************** scripts **************************************************#

convDB=$(PATHSCRIPTS)/ConvertDatabases
LM=$(PATHSCRIPTS)/CreateLanguageModel/
PHN=$(PATHSCRIPTS)/CreatePhones/
PNCCTrain=$(PATHSCRIPTS)/LoadPNCCTrain/
PNCCTest=$(PATHSCRIPTS)/LoadPNCCTest/
HTKTRAIN=$(PATHSCRIPTS)/htkTrainAndTest/

#############################################################################################
#*********************************  clean Sripts  ******************************************#
all: cleanAURORA convDataBaseAURORA


cleanAURORA:
	@ echo "delet all files to preparate scripts for speech recognition with AURORA database"
	@ rm convDataBaseAURORA
	@ rm createLMAURORA
	@ rm createPhoneAURORA
	@ rm loadPNCCTrainAURORA
	@ rm loadPNCCTestAURORA
	@ rm htkTrainAURORA
	@ rm htkTestAURORA	

##############################################################################################
#******************************** convert Databases  ****************************************#

convDataBaseAURORA:
		@ echo "*** Clean data base files ***"
	#	@ rm $(DBAURORA)
		@ echo "convert database and create monophones, dictionary, words and senteces files  from AURORA database"
		@ $(convDB)/DatabaseAURORA/make-run.sh $(PATHPRODUCTOS) $(PATHSCRIPTS)
		@ touch $@

################################################################################################
#********************************* make Language models ***************************************#

createLMAURORA:
	@ echo "*** take the LM from original AURORA database (baseline) ***"
	@ cp $(PATHPRODUCTOS)/productsDatabase/DatabaseAURORA/LM_AURORA/tcb05cnp $(PATHPRODUCTOS)/products/htk/languageModel/AURORA/
	@ mv $(PATHPRODUCTOS)/products/htk/languageModel/AURORA/tcb05cnp $(PATHPRODUCTOS)/products/htk/languageModel/AURORA/trigrams.tmp
	@ cat $(PATHPRODUCTOS)/products/htk/languageModel/AURORA/trigrams.tmp | tr [[:upper:]] [[:lower:]] > $(PATHPRODUCTOS)/products/htk/languageModel/AURORA/trigrams.txt
	@ rm -r $(PATHPRODUCTOS)/products/htk/languageModel/AURORA/trigrams.tmp 
	@ touch $@

################################################################################################
#*********************************  make monophones  ******************************************#

createPhoneAURORA:
	@ echo "*** clean phones files ***"
	@ rm $(PHAURORA) || true
	@ rm $(PATHPRODUCTOS)/products/htk/wordsInTrainSentencesAURORA.txt || true
	@ rm $(PATHPRODUCTOS)/products/htk/TrainSentencesAURORA.txt || true
	@ rm $(PATHPRODUCTOS)/products/htk/wordsInTestSentencesAURORA.txt || true
	@ rm $(PATHPRODUCTOS)/products/htk/TestSentencesAURORA.txt || true
	@ sleep 5
	@ echo "make monophones"
	@ $(PHN)Script_CreatePhones_AURORA.sh $(PATHPRODUCTOS) $(PATHSCRIPTS) $(DATATRAIN) $(DATATEST)
	@ touch $@

###################################################################################################
#********************************** feature train extraction  ************************************#

loadPNCCTrainAURORA:
	@ echo "*** Clean PNCC train files ***"
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/proto.txt || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/featureInfo.txt || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/trainFeaturesFiles.txt || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/testFeaturesFiles.txt || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/featuresTrain/*.feat || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/HDecodeParameters.txt || true
	@ sleep 10
	@ echo " Listing AURORA train data"
	@ $(PNCCTrain)ExtractPNCCFolder.sh $(PATHPRODUCTOS) $(PATHSCRIPTS) $(DATATRAIN)
	@ $(PNCCTrain)Script_LoadPNCCTrainTestDataAURORA.sh $(PATHPRODUCTOS) $(DATATRAIN) $(DATATEST) $(PATHSCRIPTS)
	@ touch $@



####################################################################################################
#********************************** feature Test extraction  **************************************#

loadPNCCTestAURORA:
	@ echo "*** Clean PNCC test files ***"
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/testFeaturesFiles.txt || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/featureInfo.txt || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/HDecodeParameters.txt || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/featuresTest/*.feat || true
	@ sleep 3
	@ echo " Listing AURORA test data"
	@ $(PNCCTest)ExtractPNCCFolder.sh $(PATHPRODUCTOS) $(PATHSCRIPTS) $(DATATEST)
	@ $(PNCCTest)Script_LoadPNCCTrainTestDataAURORA.sh $(PATHPRODUCTOS) $(DATATEST) $(PATHSCRIPTS)
	@ touch $@

###################################################################################################
#*********************************** train recognizer ********************************************#

htkTrainAURORA:
	@echo "*** Clean training files ***"
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/model/hmm1_start/hmmdefs || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/model/hmm1_start/macros || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/model/hmm1_start/proto* || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/model/hmm1_start/vFloors || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/model/hmm2_monophones/hmmdefs || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/model/hmm2_monophones/macros || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/model/hmm3_triphones/hmmdefs || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/model/hmm3_triphones/macros || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/model/hmm4_triphonesMultistream/hmmdefs || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/model/hmm4_triphonesMultistream/macros || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/trees.txt || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/triphonesTied.txt || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/tiedStateConfiguration.txt || true
	@ rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/statsFile.txt || true
	@ rm $(PATHPRODUCTOS)/products/htk/warningsAURORA.txt || true
	@ rm $(PATHPRODUCTOS)/products/htk/addMixtureConfigurationAURORA.txt || true
	@ rm $(PATHPRODUCTOS)/products/htk/phonesAURORA/triphones1.txt || true
	@ rm $(PATHPRODUCTOS)/products/htk/phonesAURORA/triphonesInTrainSentences1.txt || true
	@ rm $(PATHPRODUCTOS)/products/htk/phonesAURORA/tiedLog.txt || true
	@ echo "*** training Speech recognition with AURORA ***"
	@ $(HTKTRAIN)Script_TrainHTK_AURORA.sh $(PATHPRODUCTOS) $(DATATRAIN)
	@ touch $@

####################################################################################################
#************************************** test recognizer *******************************************#

htkTestAURORA: 
	@echo "*** Clean test files AURORA ***"
	@rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/testResultsWords.txt || true
	@rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/testRecognizedWords.txt || true
	@rm $(PATHPRODUCTOS)/products/htk/pnccAURORA/testRecognizedWords2.txt || true
	@echo "*** evaluating results AURORA ***"
	@$(HTKTRAIN)Script_TestHTK_AURORA.sh $(PATHPRODUCTOS) $(DATATEST)
	@touch $@





