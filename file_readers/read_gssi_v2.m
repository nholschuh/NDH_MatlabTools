%---------------------------------
%-- NOTE BY OLA 2004
%-- ORIGINAL WRITTEN BY ANTONIS G.
%--
%-- EXAMPLE TO READ GSSI DATA --
%-- data = readgssi('file1.dzt')
%-- 
%-- TO EXCTRACT DATA...
%-- data.head
%-- or...
%-- data.head.Gainpoints
%-- 
%-- THE DATA IS STORED AS...
%-- data.samp
%---------------------------------


%%%%%%%%%%%%%%%%%%%%%%% Phython Equivalents
%%%% H - ushort
%%%% h - short
%%%% I - uint
%%%% i - int
%%%% f - float


function data=read_gssi(name);

precision_opt = 1;

if precision_opt == 1
    us = 'ushort';
    s = 'short';
end


bit_count = 0;

fid=fopen(name);

fseek(fid,0,'bof');
rh.tag=fread(fid,1,us,0,'l'); bit_count = bit_count + 16;

fseek(fid,2,'bof');
rh.data=fread(fid,1,us,0,'l'); bit_count = bit_count + 16;

fseek(fid,4,'bof');
rh.nsamp=fread(fid,1,us,0,'l'); bit_count = bit_count + 16;

fseek(fid,6,'bof');
rh.bits=fread(fid,1,us,0,'l'); bit_count = bit_count + 16;
rh.bytes = rh.bits/8;
if rh.bits == 32
    us_datatype = 'uint';
    s_datatype = 'int';
elseif rh.bits == 16
    us_datatype = us;
    s_datatype = s ;
end

fseek(fid,8,'bof');
rh.zero=fread(fid,1,'long',0,'l'); bit_count = bit_count + 16;

fseek(fid,10,'bof');
rh.sps=fread(fid,1,'float',0,'l'); bit_count = bit_count + 32;

fseek(fid,14,'bof');
rh.spm=fread(fid,1,'float',0,'l'); bit_count = bit_count + 32;

fseek(fid,18,'bof');
rh.mpm=fread(fid,1,'float',0,'l'); bit_count = bit_count + 32;

fseek(fid,22,'bof');
rh.position=fread(fid,1,'float',0,'l'); bit_count = bit_count + 32;

fseek(fid,26,'bof');
rh.range=fread(fid,1,'float',0,'l'); bit_count = bit_count + 32;

%%%%%%%%%%%%% used to be ushort?
fseek(fid,30,'bof');
rh.npass=fread(fid,1,s,0,'l'); bit_count = bit_count + 16;

% rh.create_full = fread(fid,4,'char',0,'l'); bit_count = bit_count + 4; 
% rh.modify_full = fread(fid,4,'char',0,'l'); bit_count = bit_count + 4; 

fseek(fid,32,'bof');
Create.sec2=fread(fid,1,'ubit5',0,'l'); bit_count = bit_count + 5; 
Create.min=fread(fid,1,'ubit6',0,'l'); bit_count = bit_count + 6;
Create.hour=fread(fid,1,'ubit5',0,'l'); bit_count = bit_count + 5;
Create.day=fread(fid,1,'ubit5',0,'l'); bit_count = bit_count + 5;
Create.month=fread(fid,1,'ubit4',0,'l');bit_count = bit_count + 4; 
Create.year=fread(fid,1,'ubit7',0,'l'); bit_count = bit_count + 7;

fseek(fid,36,'bof');
Modify.sec2=fread(fid,1,'ubit5',0,'l'); bit_count = bit_count + 5;
Modify.min=fread(fid,1,'ubit6',0,'l'); bit_count = bit_count + 6;
Modify.hour=fread(fid,1,'ubit5',0,'l'); bit_count = bit_count + 5;
Modify.day=fread(fid,1,'ubit5',0,'l'); bit_count = bit_count + 5;
Modify.month=fread(fid,1,'ubit4',0,'l'); bit_count = bit_count + 4; 
Modify.year=fread(fid,1,'ubit7',0,'l'); bit_count = bit_count + 7;


fseek(fid,40,'bof');
rh.rgain=fread(fid,1,us,0,'l'); bit_count = bit_count + 16;

fseek(fid,42,'bof');
rh.nrgain=fread(fid,1,us,0,'l')+2; bit_count = bit_count + 16;

fseek(fid,44,'bof');
rh.text=fread(fid,1,us,0,'l'); bit_count = bit_count + 16;

fseek(fid,46,'bof');
rh.ntext=fread(fid,1,us,0,'l'); bit_count = bit_count + 16;

fseek(fid,48,'bof');
rh.proc=fread(fid,1,us,0,'l'); bit_count = bit_count + 16;

fseek(fid,50,'bof');
rh.nproc=fread(fid,1,us,0,'l'); bit_count = bit_count + 16;

fseek(fid,52,'bof');
rh.nchan=fread(fid,1,us,0,'l'); bit_count = bit_count + 16;

fseek(fid,54,'bof');
rh.epsr=fread(fid,1,'float',0,'l'); bit_count = bit_count + 32;

fseek(fid,58,'bof');
rh.top=fread(fid,1,'float',0,'l'); bit_count = bit_count + 32;

fseek(fid,62,'bof');
rh.depth=fread(fid,1,'float',0,'l'); bit_count = bit_count + 32;

fseek(fid,66,'bof');
rh.XCoords=fread(fid,1,'double',0,'l'); bit_count = bit_count + 64;

fseek(fid,74,'bof');
rh.servo_level=fread(fid,1,'float',0,'l'); bit_count = bit_count + 32;

fseek(fid,78,'bof');
reserved=fread(fid,3,'char',0,'l'); bit_count = bit_count + 24;

fseek(fid,81,'bof');
rh.accomp=fread(fid,3,'uint8',0,'l'); bit_count = bit_count + 8;

fseek(fid,82,'bof');
rh.config=fread(fid,3,us,0,'l'); bit_count = bit_count + 8;

fseek(fid,84,'bof');
rh.spp=fread(fid,3,us,0,'l'); bit_count = bit_count + 8;

fseek(fid,86,'bof');
rh.linenum=fread(fid,3,us,0,'l'); bit_count = bit_count + 8;

fseek(fid,88,'bof');
rh.YCoords=fread(fid,1,'double',0,'l'); bit_count = bit_count + 64;

fseek(fid,97,'bof');
rh.dtype=fread(fid,1,'char',0,'l'); bit_count = bit_count + 64;

fseek(fid,98,'bof');
rh.AntennaType=fread(fid,14,'char',0,'l'); bit_count = bit_count + 64;

fseek(fid,114,'bof');
rh.filename=fread(fid,14,'char',0,'l'); bit_count = bit_count + 64;

fseek(fid,126,'bof');
rh.filename=fread(fid,14,'char',0,'l'); bit_count = bit_count + 64;

fseek(fid,rh.rgain,'bof');
rh.break=fread(fid,1,us,0,'l'); bit_count = bit_count+16;

fseek(fid,rh.rgain+2,'bof');
rh.Gainpoints=fread(fid,rh.nrgain,'int',0,'l');



rh.Gain = 0;

%%%%%%%%%%%%% This is designed to find the first trace
start_val = 713800;

for i = 1:4
    fseek(fid,start_val+i,'bof');
    d=fread(fid,[rh.nsamp 101],'long',0,'l');
    opts(:,i) = sum(diff(d,[],2),2);
    % subplot(1,4,i)
    % imagesc(d)
    % caxis([0 300])
end
[r c] = find(opts == 100);
fseek(fid,start_val+c,'bof');
d=fread(fid,[rh.nsamp 101],s_datatype,0,'l');
trace_guess = d(r,1)*4*2048-(r-1)*4;
fseek(fid,start_val+c-trace_guess,'bof');
d=fread(fid,[rh.nsamp inf],s_datatype,0,'l');
caxis([0 300])



d = [d(3:end,:); d(end,:); d(end,:)];


d=d-mean(mean(d));;



data.head=rh;
data.samp=d;
fclose(fid);

