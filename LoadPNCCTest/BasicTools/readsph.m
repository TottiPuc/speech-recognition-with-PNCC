function [y,fs,ffx]=readsph(filename,mode,nmax,nskip)
%READSPH  Read a SPHERE/TIMIT format sound file [Y,FS,FFX]=(FILENAME,MODE,NMAX,NSKIP)
%
% Input Parameters:
%
%	FILENAME gives the name of the file (with optional .SPH extension) or alternatively
%                 can be the FFX output from a previous call to READSPH having the 'f' mode option
%	MODE		specifies the following (*=default):
%
%    Scaling: 's'    Auto scale to make data peak = +-1 (use with caution if reading in chunks)
%             'r'    Raw unscaled data (integer values)
%             'p' *	Scaled to make +-1 equal full scale
%   Format    'l'    Little endian data (Intel,DEC) (overrides indication in file)
%             'b'    Big endian data (non Intel/DEC) (overrides indication in file)
%   File I/O: 'f'    Do not close file on exit
%
%	NMAX     maximum number of samples to read (or -1 for unlimited [default])
%	NSKIP    number of samples to skip from start of file
%               (or -1 to continue from previous read when FFX is given instead of FILENAME [default])
%
% Output Parameters:
%
%	Y        data matrix of dimension (samples,channels)
%	FS       sample frequency in Hz
%	FFX      Cell array containing
%
%     {1}     filename
%     {2}     header information
%        {1}  first header field name
%        {2}  first header field value
%     {3}     format string (e.g. NIST_1A)
%     {4}(1)  file id
%        (2)  current position in file
%        (3)  dataoff	byte offset in file to start of data
%        (4)  order  byte order (l or b)
%        (5)  nsamp	number of samples
%        (6)  number of channels
%        (7)  nbytes	bytes per data value
%        (8)  bits	number of bits of precision
%        (9)  fs	sample frequency
%			(10) min value
%        (11) max value
%
%   If no output parameters are specified, header information will be printed.
%

%	Copyright (C) Mike Brookes 1998
%
%      Last modified Tue Sep 26 13:45:55 2000
%
%   VOICEBOX is a MATLAB toolbox for speech processing. Home page is at
%   http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 2 of the License, or
%   (at your option) any later version.
%
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You can obtain a copy of the GNU General Public License from
%   ftp://prep.ai.mit.edu/pub/gnu/COPYING-2.0 or by writing to
%   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

persistent BYTEORDER
codes={'sample_count'; 'channel_count';  'sample_n_bytes';'sample_sig_bits'; 'sample_rate'; 'sample_min'; 'sample_max'};
if isempty(BYTEORDER) BYTEORDER='l'; end
if nargin<1 error('Usage: [y,fs,hdr,fidx]=READSPH(filename,mode,nmax,nskip)'); end
if nargin<2 mode='p';
else mode = [mode(:).' 'p'];
end
k=find((mode>='p') & (mode<='s'));
sc=mode(k(1)); 
if any(mode=='l') BYTEORDER='l';
elseif any(mode=='b') BYTEORDER='b';
end
if nargout
ffx=cell(4,1);
if ischar(filename)
   fid=fopen(filename,'rb',BYTEORDER);
   if fid == -1
      fn=[filename,'.sph'];
      fid=fopen(fn,'rb',BYTEORDER);
      if fid ~= -1 filename=fn; end
   end
   if fid == -1 
      error(sprintf('Can''t open %s for input',filename)); 
   end
   ffx{1}=filename;
else
   if iscell(filename)
      ffx=filename;
   else
      fid=filename;
   end
end

if isempty(ffx{4});
   fseek(fid,0,-1);					
   str=char(fread(fid,16)');
   if str(8) ~= 10 | str(16) ~= 10 fclose(fid); error(sprintf('File does not begin with a SPHERE header')); end
   ffx{3}=str(1:7);
   hlen=str2num(str(9:15));
   hdr={};
   while 1
      str=fgetl(fid);
      if str(1) ~= ';'
         [tok,str]=strtok(str);
         if strcmp(tok,'end_head') break; end
         hdr(end+1,1)={tok};
         [tok,str]=strtok(str);
         if tok(1) ~= '-' error('Missing ''-'' in SPHERE header'); end
         if tok(2)=='s'
            hdr(end,2)={str(2:str2num(tok(3:end))+1)};
         elseif tok(2)=='i'
            hdr(end,2)={sscanf(str,'%d',1)};
         else
            hdr(end,2)={sscanf(str,'%f',1)};
         end
      end
   end
   i=find(strcmp(hdr(:,1),'sample_byte_format'));
   if ~isempty(i)
      bord=char('b'+('l'-'b')*(hdr{i,2}(1)=='0'));
      if bord ~= BYTEORDER & mode~='b' & mode ~='l'
         BYTEORDER=bord;
         fclose(fid);
         fid=fopen(filename,'rb',BYTEORDER);
      end
   end
   info=[fid; 0; hlen; double(BYTEORDER); 0; 1; 2; 16; 1 ; 1; -1];
   for j=1:7
      i=find(strcmp(hdr(:,1),codes{j}));
      if ~isempty(i)
         info(j+4)=hdr{i,2};
      end
   end
   if ~info(5)
      fseek(fid,0,1);
      info(5)=floor((ftell(fid)-info(3))/(info(6)*info(7)));
   end
   ffx{2}=hdr;
   ffx{4}=info;
end
info=ffx{4};
if nargin<4 nskip=info(2);
elseif nskip<0 nskip=info(2);
end

ksamples=info(5)-nskip;
if nargin>2
   if nmax>=0
      ksamples=min(nmax,ksamples);
   end
end

if ksamples>0
   fid=info(1);
   info(2)=nskip+ksamples;
   pk=(pow2(0.5,info(8))-0.5)*pow2(1,8*info(7)-info(8));		% full-scale range
   fseek(fid,info(3)+info(6)*info(7)*nskip,-1);
   nsamples=info(6)*ksamples;
   if info(7)<3
      if info(7)<2
         y=fread(fid,nsamples,'uchar');
         y=y-128;
      else
         y=fread(fid,nsamples,'short');
      end
   else
      if info(7)<4
         y=fread(fid,3*nsamples,'uchar');
         y=reshape(y,3,nsamples);
         y=[1 256 65536]*y-pow2(fix(pow2(y(3,:),-7)),24);
      else
         y=fread(fid,nsamples,'long');
      end
   end
   if sc ~= 'r'
      if sc=='s' 
         if info(10)>info(11)
            info(10)=min(y);
            info(11)=max(y);
         end
         pd=max(abs(info(10:11)));
         pd=pk/(pd+(pd==0));
      else pd=1;
      end
      y=pd/pk*y;
   end
   
   if info(6)>1 y = reshape(y,info(6),ksamples).'; end
else
   y=[];
end

if mode~='f' fclose(fid); end
ffx{4}=info;
fs=info(9);
else
   [y1,fs,ffx]=readsph(filename,mode,0);
   info=ffx{4};
   if ~isempty(ffx{1}) fprintf(1,'Filename: %s\n',ffx{1}); end
   fprintf(1,'Sphere file type: %s\n',ffx{3});
   fprintf(1,'Duration = %ss: %d channel * %d samples @ %sHz\n',sprintsi(info(5)/info(9)),info(6),info(5),sprintsi(info(9)));
end




