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

    fid3.write("\"*" + text1 + "\"" + '\n')
   
    fid4 = open (text1,'r')
    fid5 = open (text2,'r')
    
    hasPrintedSp=0
    
    lines3 = fid4.readlines()
    lines4 = fid5.readlines()
    for indWord in range(len(lines3)):
        word = lines3[indWord].strip().split()
    
        for indice in range(len(lines4)):
            phone = lines4[indice].strip().split()
            if phone[2] == 'h#' and int(phone[0]) != 0:
                fid3.write(lines4[indice])
                break

            elif int(phone[0]) >= int(word[1]):
                if hasPrintedSp == 0:
                    fid3.write(phone[0] + ' ' + phone[0] + ' ' + 'sp\n')
                fid3.write(lines4[indice])
                hasPrintedSp = 0
                indWord+=1
                if indWord == len(lines3):
                    fid3.write('.\n')
                    break
                else:
                    word = lines3[indWord].strip().split()
                #if word[2].isalpha():
                                  
            else:
                fid3.write(lines4[indice])
                hasPrintedSp = 0
                if int(phone[1]) >= int(word[1]):
                    fid3.write(phone[1] + ' ' + phone[1] + ' ' + 'sp\n')
                    hasPrintedSp = 1
                    #print wordDef
                    indWord+=1
                    if indWord == len(lines3):
                        phone = lines4[indice+1].strip().split()
                        if phone[2] == 'sil':
                            fid3.write(lines4[indice+1]) 
                            fid3.write('.\n')
                            break
                        else:
                            fid3.write('.\n')
                            break                            
                    else:
                        word = lines3[indWord].strip().split()
                    #    wordDef = word[2] + ' '
            
        break
        
fid1.close()
fid2.close()
fid3.close()
fid4.close()
fid5.close()





