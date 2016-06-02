#!/usr/bin/env python
#coding: utf-8


#==============================================#
##### Christian Dayan Arcos Gordillo  ##########
#####         speech recognition       #########
#######       CETUC - PUC - RIO       ##########
#####     christian@cetuc.puc-rio.br    ########
#####       dayan3846@gmail.com.co      ########
#==============================================#
################################################

import sys
fid1 = open(sys.argv[1], 'r')
fid2 = open(sys.argv[2], 'a')

lines1 = fid1.readlines()

for i in range(len(lines1)):
    mono=lines1[i].replace('\n','')
    fid2.write('TI T_'+mono + ' {(*-'+ mono + '+*,' + mono + '+*,' + '*-'+ mono + ').transP}' + '\n' )
