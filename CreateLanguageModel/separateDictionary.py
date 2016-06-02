#!/usr/bin/env python
#coding: utf-8

###############################################
#==============================================#
##### Christian Dayan Arcos Gordillo  ##########
#####         speech recognition       #########
#######       CETUC - PUC - RIO       ##########
#####     christian@cetuc.puc-rio.br    ########
#####       dayan3846@gmail.com.co      ########
#==============================================#
################################################


# this script will receive the dictionary whit the phonetic transcriptions and will return a new file only whit words, the first argument argv[1] is the dictionary the second one is the final file 

import os, sys

def splitfile(lineIn):

	indice = 0 
	while indice < len(lineIn):
		symbol = lineIn[indice]
		#print (symbol)
		if symbol != ' ':
			fid2.write(symbol)
			indice+=1
		else:
			fid2.write('\n')
			indice+=1
			#print ('exit')
			break

if __name__=="__main__":
	if len(sys.argv)==3:
		fid1 = open (sys.argv[1], 'r')
		fid2 = open (sys.argv[2], 'w')
		#print('>>> read file)
		lines = fid1.readlines()
		for line in lines:
			#print(fid.readline() + '\n')
			splitfile(line)
		fid2.write('!ENTER\n')
		fid2.write('!EXIT\n')
		fid1.close()
		fid2.close()
