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

def splitfile(lineIn,i):
        st = ''
        indice = 0
        
        while indice < len(lineIn):
                symbol = lineIn[indice]
                if symbol != ' ' and symbol != '\n':
                        st+=symbol
                        indice+=1

                else:
                        if st != 'sil':
                            if i > 1:
                                fid3.write( ' | ')                          
                        else:
                            fid3.write(' ')
                            break

                        fid3.write(st)
                        indice+=1
       
        fid2.write(st + ' ' + st + '\n')
        
        
if __name__=="__main__":
                fid1 = open (sys.argv[1], 'r')
                fid2 = open (sys.argv[2], 'w')
                fid3 = open (sys.argv[3], 'a') 
                fid3.write('$phone = ')
		lines = fid1.readlines()
                i=0
                for line in lines:
                        i+=1
                        splitfile(line,i)
		fid3.write( ';\n')
		fid3.write( '(sil <$phone> sil)\n')
                fid1.close()
                fid2.close()
                fid3.close()


