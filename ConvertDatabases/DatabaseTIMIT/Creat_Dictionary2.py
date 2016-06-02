#!/usr/bin/env python
#coding: utf-8


################################################
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
fid2 = open(sys.argv[2], 'r')
fid3 = open(sys.argv[3], 'a')

lines1 = fid1.readlines()
lines2 = fid2.readlines()

lista = [lines1,lines2]

for i in range(len(lines1)):
    
    text1=lista[0][i].replace('\n','')
    text2=lista[1][i].replace('\n','')
    
    fid4 = open (text1,'r')
    fid5 = open (text2,'r')
    
    lines3 = fid4.readlines()
    lines4 = fid5.readlines()
    for indWord in range(len(lines3)):
        word = lines3[indWord].strip().split()
        wordDef = word[2] + ' '
        for indice in range(len(lines4)):
            phone = lines4[indice].strip().split()
            if phone[2] == 'sil' or phone[2] == 'sp':
                continue
            if int(phone[0]) < int(word[1]):
                wordDef = wordDef + ' ' + phone[2]
            if int(phone[1]) == int(word[1]) or int(phone[0]) >= int(word[1]):
                fid3.write(wordDef + '\n')
                #print wordDef
                indWord+=1
                if indWord == len(lines3):
                    break
                else:
                    word = lines3[indWord].strip().split()
                    wordDef = word[2] + ' '
            
        break
        
fid1.close()
fid2.close()
fid3.close()
fid4.close()
fid5.close()
