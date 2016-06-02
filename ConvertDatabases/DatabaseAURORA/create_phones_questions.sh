#! /bin/bash 

################################################
#==============================================#
##### Christian Dayan Arcos Gordillo  ##########
#####       Reconhecimento de voz      #########
#####     christian@cetuc.puc-rio.br    ########
#######       CETUC - PUC - RIO       ##########
#==============================================#
################################################
nameDatabase="AURORA"
result=$1
discar_strange_phones=1

if [ "$discar_strange_phones" -eq 1 ]; then

	echo "b" >> $result/monophones.txt
	echo "d" >> $result/monophones.txt
	echo "g" >> $result/monophones.txt
	echo "p" >> $result/monophones.txt
	echo "t" >> $result/monophones.txt
	echo "k" >> $result/monophones.txt
	echo "jh" >> $result/monophones.txt
	echo "ch" >> $result/monophones.txt
	echo "s" >> $result/monophones.txt
	echo "sh" >> $result/monophones.txt
	echo "z" >> $result/monophones.txt
	echo "zh" >> $result/monophones.txt
	echo "f" >> $result/monophones.txt
	echo "th" >> $result/monophones.txt
	echo "v" >> $result/monophones.txt
	echo "dh" >> $result/monophones.txt
	echo "m" >> $result/monophones.txt
	echo "n" >> $result/monophones.txt
	echo "ng" >> $result/monophones.txt
	echo "l" >> $result/monophones.txt
	echo "r" >> $result/monophones.txt
	echo "w" >> $result/monophones.txt
	echo "y" >> $result/monophones.txt
	echo "hh" >> $result/monophones.txt
	echo "iy" >> $result/monophones.txt
	echo "ih" >> $result/monophones.txt
	echo "eh" >> $result/monophones.txt
	echo "ey" >> $result/monophones.txt
	echo "ae" >> $result/monophones.txt
	echo "aa" >> $result/monophones.txt
	echo "aw" >> $result/monophones.txt
	echo "ay" >> $result/monophones.txt
	echo "ah" >> $result/monophones.txt
	echo "ao" >> $result/monophones.txt
	echo "oy" >> $result/monophones.txt
	echo "ow" >> $result/monophones.txt
	echo "uh" >> $result/monophones.txt
	echo "uw" >> $result/monophones.txt
	echo "er" >> $result/monophones.txt
else
	echo "el" >> $result/monophones.txt
        echo "ax" >> $result/monophones.txt
        echo "ix" >> $result/monophones.txt
        echo "axr" >> $result/monophones.txt
        echo "em" >> $result/monophones.txt
        echo "en" >> $result/monophones.txt 
        echo "bcl" >> $result/monophones.txt
        echo "dcl" >> $result/monophones.txt
        echo "gcl" >> $result/monophones.txt
        echo "kcl" >> $result/monophones.txt
        echo "pcl" >> $result/monophones.txt
        echo "tcl" >> $result/monophones.txt
        echo "epi" >> $result/monophones.txt
        echo "q" >> $result/monophones.txt
        echo "pau" >> $result/monophones.txt
        echo "eng" >> $result/monophones.txt
        echo "nx" >> $result/monophones.txt
        echo "axh" >> $result/monophones.txt
        echo "dx" >> $result/monophones.txt
        echo "hv" >> $result/monophones.txt
        echo "ux" >> $result/monophones.txt
fi

# make questions file, to help on triphone tying


echo "QS \"L_Class-Stop\"		{p-*,b-*,t-*,d-*,k-*,g-*}" >> $result/questions.txt
echo "QS \"L_Nasal\"              {m-*,n-*,ng-*}" >> $result/questions.txt
echo "QS \"L_FricatAffricative\"  {s-*,sh-*,z-*,zh-*,f-*,v-*,ch-*,jh-*,th-*,dh-*}" >> $result/questions.txt
echo "QS \"L_Liquid\"             {l-*,el-*,r-*,ua-*,ia-*,w-*,y-*,hh-*}" >> $result/questions.txt
echo "QS \"L_Vowel\"              {ey-*,ea-*,eh-*,ih-*,ao-*,ae-*,aa-*,oh-*,uw-*,ua-*,uh-*,er-*,ay-*,oy-*,iy-*,ia-*,aw-*,ow-*,ax-*,ah-*}" >> $result/questions.txt
echo "QS \"L_Silence\"            {epi-*,pau-*,h#-*,#h-*}" >> $result/questions.txt
echo "QS \"L_C-Front\"            {p-*,b-*,m-*,f-*,v-*,w-*}" >> $result/questions.txt
echo "QS \"L_C-Central\"          {t-*,d-*,n-*,s-*,z-*,zh-*,th-*,dh-*,l-*,el-*,r-*,ua-*,ia-*}" >> $result/questions.txt
echo "QS \"L_C-Back\"             {sh-*,ch-*,jh-*,y-*,k-*,g-*,ng-*,hh-*}" >> $result/questions.txt
echo "QS \"L_V-Front\"            {iy-*,ia-*,ih-*,ey-*,ea-*,eh-*}" >> $result/questions.txt
echo "QS \"L_V-Central\"          {ae-*,oh-*,aa-*,er-*,ao-*}" >> $result/questions.txt
echo "QS \"L_V-Back\"             {uw-*,ua-*,uh-*,ow-*,ax-*,ah-*}" >> $result/questions.txt
echo "QS \"L_Front\"              {p-*,b-*,m-*,f-*,v-*,w-*,iy-*,ia-*,ih-*,ey-*,ea-*,eh-*}" >> $result/questions.txt
echo "QS \"L_Central\"            {t-*,d-*,n-*,s-*,z-*,zh-*,th-*,dh-*,l-*,el-*,r-*,ua-*,ia-*,ae-*,aa-*,er-*,ao-*}" >> $result/questions.txt
echo "QS \"L_Back\"               {sh-*,ch-*,jh-*,y-*,k-*,g-*,ng-*,hh-*,oh-*,uw-*,ua-*,uh-*,ow-*,ax-*,ah-*}" >> $result/questions.txt
echo "QS \"L_Fortis\"             {p-*,t-*,k-*,f-*,th-*,s-*,sh-*,ch-*}" >> $result/questions.txt
echo "QS \"L_Lenis\"              {b-*,d-*,g-*,v-*,dh-*,z-*,zh-*,jh-*}" >> $result/questions.txt
echo "QS \"L_UnFortLenis\"        {m-*,n-*,ng-*,hh-*,l-*,el-*,r-*,ua-*,ia-*,y-*,w-*}" >> $result/questions.txt
echo "QS \"L_Coronal\"            {t-*,d-*,n-*,th-*,dh-*,s-*,z-*,sh-*,zh-*,ch-*,jh-*,el-*,l-*,r-*,ua-*,ia-*}" >> $result/questions.txt
echo "QS \"L_NonCoronal\"         {p-*,b-*,m-*,k-*,g-*,ng-*,f-*,v-*,hh-*,y-*,w-*}" >> $result/questions.txt
echo "QS \"L_Anterior\"           {p-*,b-*,m-*,t-*,d-*,n-*,f-*,v-*,th-*,dh-*,s-*,z-*,l-*,el-*,w-*}" >> $result/questions.txt
echo "QS \"L_NonAnterior\"        {k-*,g-*,ng-*,sh-*,zh-*,hh-*,ch-*,jh-*,r-*,ua-*,ia-*,y-*}" >> $result/questions.txt
echo "QS \"L_Continuent\"         {m-*,n-*,ng-*,f-*,v-*,th-*,dh-*,s-*,z-*,sh-*,zh-*,hh-*,l-*,el-*,r-*,ua-*,ia-*,y-*,w-*}" >> $result/questions.txt
echo "QS \"L_NonContinuent\"      {p-*,b-*,t-*,d-*,k-*,g-*,ch-*,jh-*}" >> $result/questions.txt
echo "QS \"L_Strident\"           {s-*,z-*,sh-*,zh-*,ch-*,jh-*}" >> $result/questions.txt
echo "QS \"L_NonStrident\"        {f-*,v-*,th-*,dh-*,hh-*}" >> $result/questions.txt
echo "QS \"L_UnStrident\"         {p-*,b-*,m-*,t-*,d-*,n-*,k-*,g-*,ng-*,l-*,el-*,r-*,ua-*,ia-*,y-*,w-*}" >> $result/questions.txt
echo "QS \"L_Glide\"              {hh-*,l-*,el-*,r-*,ua-*,ia-*,y-*,w-*}" >> $result/questions.txt
echo "QS \"L_Syllabic\"           {el-*,er-*}" >> $result/questions.txt
echo "QS \"L_Unvoiced-cons\"      {p-*,t-*,k-*,s-*,sh-*,f-*,th-*,hh-*,ch-*}" >> $result/questions.txt
echo "QS \"L_Voiced-cons\"        {jh-*,b-*,d-*,dh-*,g-*,y-*,l-*,el-*,m-*,n-*,ng-*,r-*,ua-*,ia-*,v-*,w-*,z-*}" >> $result/questions.txt
echo "QS \"L_Unvoiced-all\"       {p-*,t-*,k-*,s-*,sh-*,f-*,th-*,hh-*,ch-*,sil-*,sp-*}" >> $result/questions.txt
echo "QS \"L_Long\"               {iy-*,ia-*,ow-*,aw-*,ao-*,uw-*,ua-*,el-*}" >> $result/questions.txt
echo "QS \"L_Short\"              {ae-*,ey-*,ea-*,aa-*,eh-*,ih-*,ay-*,oy-*,oh-*,ax-*,ah-*,uh-*}" >> $result/questions.txt
echo "QS \"L_Dipthong\"           {ey-*,ea-*,ay-*,oy-*,aw-*,er-*,el-*}" >> $result/questions.txt
echo "QS \"L_Front-Start\"        {ey-*,ea-*,aw-*,er-*}" >> $result/questions.txt
echo "QS \"L_Fronting\"           {ay-*,ey-*,ea-*,oy-*}" >> $result/questions.txt
echo "QS \"L_High\"               {ih-*,uw-*,ua-*,uh-*,iy-*,ia-*}" >> $result/questions.txt
echo "QS \"L_Medium\"             {ey-*,ea-*,er-*,ax-*,ah-*,ow-*,eh-*,el-*}" >> $result/questions.txt
echo "QS \"L_Low\"                {ae-*,ay-*,aw-*,aa-*,oh-*,ao-*,oy-*}" >> $result/questions.txt
echo "QS \"L_Rounded\"            {ao-*,uw-*,ua-*,uh-*,oy-*,ow-*,w-*}" >> $result/questions.txt
echo "QS \"L_Unrounded\"          {eh-*,ih-*,ae-*,aa-*,oh-*,er-*,ay-*,ey-*,ea-*,iy-*,ia-*,aw-*,ax-*,ah-*,hh-*,l-*,el-*,r-*,ua-*,ia-*,y-*}" >> $result/questions.txt
echo "QS \"L_Fricative\"          {s-*,sh-*,z-*,zh-*,f-*,v-*,th-*,dh-*}" >> $result/questions.txt
echo "QS \"L_Affricate\"          {ch-*,jh-*}" >> $result/questions.txt
echo "QS \"L_IVowel\"             {ih-*,iy-*,ia-*}" >> $result/questions.txt
echo "QS \"L_EVowel\"             {ey-*,ea-*,eh-*}" >> $result/questions.txt
echo "QS \"L_AVowel\"             {ae-*,aa-*,oh-*,er-*,ay-*,aw-*}" >> $result/questions.txt
echo "QS \"L_OVowel\"             {ao-*,oy-*,ow-*}" >> $result/questions.txt
echo "QS \"L_UVowel\"             {ax-*,ah-*,el-*,uh-*,uw-*,ua-*}" >> $result/questions.txt
echo "QS \"L_Voiced-Stop\"        {b-*,d-*,g-*}" >> $result/questions.txt
echo "QS \"L_Unvoiced-Stop\"      {p-*,t-*,k-*}" >> $result/questions.txt
echo "QS \"L_Front-Stop\"         {p-*,b-*}" >> $result/questions.txt
echo "QS \"L_Central-Stop\"       {t-*,d-*}" >> $result/questions.txt
echo "QS \"L_Back-Stop\"          {k-*,g-*}" >> $result/questions.txt
echo "QS \"L_Voiced-Fricative\"   {z-*,zh-*,dh-*,ch-*,v-*}" >> $result/questions.txt
echo "QS \"L_Unvoiced-Fricative\" {s-*,sh-*,th-*,f-*,ch-*}" >> $result/questions.txt
echo "QS \"L_Front-Fricative\"    {f-*,v-*}" >> $result/questions.txt
echo "QS \"L_Central-Fricative\"  {s-*,z-*,th-*,dh-*}" >> $result/questions.txt
echo "QS \"L_Back-Fricative\"     {sh-*,zh-*,ch-*,jh-*}" >> $result/questions.txt
echo "QS \"R_Class-Stop\"         {*+p,*+b,*+t,*+d,*+k,*+g}" >> $result/questions.txt
echo "QS \"R_Nasal\"              {*+m,*+n,*+ng}" >> $result/questions.txt
echo "QS \"R_FricatAffricative\"  {*+s,*+sh,*+z,*+zh,*+f,*+v,*+ch,*+jh,*+th,*+dh}" >> $result/questions.txt
echo "QS \"R_Liquid\"             {*+l,*+el,*+r,*+ua,*+ia,*+w,*+y,*+hh}" >> $result/questions.txt
echo "QS \"R_Vowel\"              {*+ey,*+ea,*+eh,*+ih,*+ao,*+ae,*+aa,*+oh,*+uw,*+ua,*+uh,*+er,*+ay,*+oy,*+iy,*+ia,*+aw,*+ow,*+ax,*+ah}" >> $result/questions.txt
echo "QS \"R_Silence\"            {epi-*,pau-*,h#-*,#h-*}" >> $result/questions.txt
echo "QS \"R_C-Front\"            {*+p,*+b,*+m,*+f,*+v,*+w}" >> $result/questions.txt
echo "QS \"R_C-Central\"          {*+t,*+d,*+n,*+s,*+z,*+zh,*+th,*+dh,*+l,*+el,*+r,*+ua,*+ia}" >> $result/questions.txt
echo "QS \"R_C-Back\"             {*+sh,*+ch,*+jh,*+y,*+k,*+g,*+ng,*+hh}" >> $result/questions.txt
echo "QS \"R_V-Front\"            {*+iy,*+ia,*+ih,*+ey,*+ea,*+eh}" >> $result/questions.txt
echo "QS \"R_V-Central\"          {*+ae,*+oh,*+aa,*+er,*+ao}" >> $result/questions.txt
echo "QS \"R_V-Back\"             {*+uw,*+ua,*+uh,*+ow,*+ax,*+ah}" >> $result/questions.txt
echo "QS \"R_Front\"              {*+p,*+b,*+m,*+f,*+v,*+w,*+iy,*+ia,*+ih,*+ey,*+ea,*+eh}" >> $result/questions.txt
echo "QS \"R_Central\"            {*+t,*+d,*+n,*+s,*+z,*+zh,*+th,*+dh,*+l,*+el,*+r,*+ua,*+ia,*+ae,*+aa,*+er,*+ao}" >> $result/questions.txt
echo "QS \"R_Back\"               {*+sh,*+ch,*+jh,*+y,*+k,*+g,*+ng,*+hh,*+oh,*+uw,*+ua,*+uh,*+ow,*+ax,*+ah}" >> $result/questions.txt
echo "QS \"R_Fortis\"             {*+p,*+t,*+k,*+f,*+th,*+s,*+sh,*+ch}" >> $result/questions.txt
echo "QS \"R_Lenis\"              {*+b,*+d,*+g,*+v,*+dh,*+z,*+zh,*+jh}" >> $result/questions.txt
echo "QS \"R_UnFortLenis\"        {*+m,*+n,*+ng,*+hh,*+l,*+el,*+r,*+ua,*+ia,*+y,*+w}" >> $result/questions.txt
echo "QS \"R_Coronal\"            {*+t,*+d,*+n,*+th,*+dh,*+s,*+z,*+sh,*+zh,*+ch,*+jh,*+el,*+l,*+r,*+ua,*+ia}" >> $result/questions.txt
echo "QS \"R_NonCoronal\"         {*+p,*+b,*+m,*+k,*+g,*+ng,*+f,*+v,*+hh,*+y,*+w}" >> $result/questions.txt
echo "QS \"R_Anterior\"           {*+p,*+b,*+m,*+t,*+d,*+n,*+f,*+v,*+th,*+dh,*+s,*+z,*+l,*+el,*+w}" >> $result/questions.txt
echo "QS \"R_NonAnterior\"        {*+k,*+g,*+ng,*+sh,*+zh,*+hh,*+ch,*+jh,*+r,*+ua,*+ia,*+y}" >> $result/questions.txt
echo "QS \"R_Continuent\"         {*+m,*+n,*+ng,*+f,*+v,*+th,*+dh,*+s,*+z,*+sh,*+zh,*+hh,*+l,*+el,*+r,*+ua,*+ia,*+y,*+w}" >> $result/questions.txt
echo "QS \"R_NonContinuent\"      {*+p,*+b,*+t,*+d,*+k,*+g,*+ch,*+jh}" >> $result/questions.txt
echo "QS \"R_Strident\"           {*+s,*+z,*+sh,*+zh,*+ch,*+jh}" >> $result/questions.txt
echo "QS \"R_NonStrident\"        {*+f,*+v,*+th,*+dh,*+hh}" >> $result/questions.txt
echo "QS \"R_UnStrident\"         {*+p,*+b,*+m,*+t,*+d,*+n,*+k,*+g,*+ng,*+l,*+el,*+r,*+ua,*+ia,*+y,*+w}" >> $result/questions.txt
echo "QS \"R_Glide\"              {*+hh,*+l,*+el,*+r,*+ua,*+ia,*+y,*+w}" >> $result/questions.txt
echo "QS \"R_Syllabic\"           {*+el,*+er}" >> $result/questions.txt
echo "QS \"R_Unvoiced-cons\"      {*+p,*+t,*+k,*+s,*+sh,*+f,*+th,*+hh,*+ch}" >> $result/questions.txt
echo "QS \"R_Voiced-cons\"        {*+jh,*+b,*+d,*+dh,*+g,*+y,*+l,*+el,*+m,*+n,*+ng,*+r,*+ua,*+ia,*+v,*+w,*+z}" >> $result/questions.txt
echo "QS \"R_Unvoiced-all\"       {*+p,*+t,*+k,*+s,*+sh,*+f,*+th,*+hh,*+ch,*+sil,*+sp}" >> $result/questions.txt
echo "QS \"R_Long\"               {*+iy,*+ia,*+ow,*+aw,*+ao,*+uw,*+ua,*+el}" >> $result/questions.txt
echo "QS \"R_Short\"              {*+ae,*+ey,*+ea,*+aa,*+eh,*+ih,*+ay,*+oy,*+oh,*+ax,*+ah,*+uh}" >> $result/questions.txt
echo "QS \"R_Dipthong\"           {*+ey,*+ea,*+ay,*+oy,*+aw,*+er,*+el}" >> $result/questions.txt
echo "QS \"R_Front-Start\"        {*+ey,*+ea,*+aw,*+er}" >> $result/questions.txt
echo "QS \"R_Fronting\"           {*+ay,*+ey,*+ea,*+oy}" >> $result/questions.txt
echo "QS \"R_High\"               {*+ih,*+uw,*+ua,*+uh,*+iy,*+ia}" >> $result/questions.txt
echo "QS \"R_Medium\"             {*+ey,*+ea,*+er,*+ax,*+ah,*+ow,*+eh,*+el}" >> $result/questions.txt
echo "QS \"R_Low\"                {*+ae,*+ay,*+aw,*+aa,*+oh,*+ao,*+oy}" >> $result/questions.txt
echo "QS \"R_Rounded\"            {*+ao,*+uw,*+ua,*+uh,*+oy,*+ow,*+w}" >> $result/questions.txt
echo "QS \"R_Unrounded\"          {*+eh,*+ih,*+ae,*+aa,*+oh,*+er,*+ay,*+ey,*+ea,*+iy,*+ia,*+aw,*+ax,*+ah,*+hh,*+l,*+el,*+r,*+ua,*+ia,*+y}" >> $result/questions.txt
echo "QS \"R_Fricative\"          {*+s,*+sh,*+z,*+zh,*+f,*+v,*+th,*+dh}" >> $result/questions.txt
echo "QS \"R_Affricate\"          {*+ch,*+jh}" >> $result/questions.txt
echo "QS \"R_IVowel\"             {*+ih,*+iy,*+ia}" >> $result/questions.txt
echo "QS \"R_EVowel\"             {*+ey,*+ea,*+eh}" >> $result/questions.txt
echo "QS \"R_AVowel\"             {*+ae,*+aa,*+oh,*+er,*+ay,*+aw}" >> $result/questions.txt
echo "QS \"R_OVowel\"             {*+ao,*+oy,*+ow}" >> $result/questions.txt
echo "QS \"R_UVowel\"             {*+ax,*+ah,*+el,*+uh,*+uw,*+ua}" >> $result/questions.txt
echo "QS \"R_Voiced-Stop\"        {*+b,*+d,*+g}" >> $result/questions.txt
echo "QS \"R_Unvoiced-Stop\"      {*+p,*+t,*+k}" >> $result/questions.txt
echo "QS \"R_Front-Stop\"         {*+p,*+b}" >> $result/questions.txt
echo "QS \"R_Central-Stop\"       {*+t,*+d}" >> $result/questions.txt
echo "QS \"R_Back-Stop\"          {*+k,*+g}" >> $result/questions.txt
echo "QS \"R_Voiced-Fricative\"   {*+z,*+zh,*+dh,*+ch,*+v}" >> $result/questions.txt
echo "QS \"R_Unvoiced-Fricative\" {*+s,*+sh,*+th,*+f,*+ch}" >> $result/questions.txt
echo "QS \"R_Front-Fricative\"    {*+f,*+v}" >> $result/questions.txt
echo "QS \"R_Central-Fricative\"  {*+s,*+z,*+th,*+dh}" >> $result/questions.txt
echo "QS \"R_Back-Fricative\"     {*+sh,*+zh,*+ch,*+jh}" >> $result/questions.txt



