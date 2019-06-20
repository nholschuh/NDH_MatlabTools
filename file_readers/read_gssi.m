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

bit_count = 0;

fid=fopen(name);
rh.tag=fread(fid,1,'ushort',0,'l'); bit_count = bit_count + 16;
rh.data=fread(fid,1,'ushort',0,'l'); bit_count = bit_count + 16;
rh.nsamp=fread(fid,1,'ushort',0,'l'); bit_count = bit_count + 16;
rh.bits=fread(fid,1,'ushort',0,'l'); bit_count = bit_count + 16;
rh.bytes = rh.bits/8;
if rh.bits == 32
    us_datatype = 'uint';
    s_datatype = 'int';
elseif rh.bits == 16
    us_datatype = 'ushort';
    s_datatype = 'short' ;
end

rh.zero=fread(fid,1,'short',0,'l'); bit_count = bit_count + 16;

rh.sps=fread(fid,1,'float',0,'l'); bit_count = bit_count + 32;
rh.spm=fread(fid,1,'float',0,'l'); bit_count = bit_count + 32;
rh.mpm=fread(fid,1,'float',0,'l'); bit_count = bit_count + 32;
rh.position=fread(fid,1,'float',0,'l'); bit_count = bit_count + 32;
rh.range=fread(fid,1,'float',0,'l'); bit_count = bit_count + 32;

%%%%%%%%%%%%% used to be ushort?
rh.npass=fread(fid,1,'short',0,'l'); bit_count = bit_count + 16;

rh.create_full = fread(fid,4,'char',0,'l'); bit_count = bit_count + 4; 
rh.modify_full = fread(fid,4,'char',0,'l'); bit_count = bit_count + 4; 

% Create.sec2=fread(fid,1,'ubit5',0,'l'); bit_count = bit_count + 5; 
% Create.min=fread(fid,1,'ubit6',0,'l'); bit_count = bit_count + 6;
% Create.hour=fread(fid,1,'ubit5',0,'l'); bit_count = bit_count + 5;
% Create.day=fread(fid,1,'ubit5',0,'l'); bit_count = bit_count + 5;
% Create.month=fread(fid,1,'ubit4',0,'l');bit_count = bit_count + 4; 
% Create.year=fread(fid,1,'ubit7',0,'l'); bit_count = bit_count + 7;
% 
% Modify.sec2=fread(fid,1,'ubit5',0,'l'); bit_count = bit_count + 5;
% Modify.min=fread(fid,1,'ubit6',0,'l'); bit_count = bit_count + 6;
% Modify.hour=fread(fid,1,'ubit5',0,'l'); bit_count = bit_count + 5;
% Modify.day=fread(fid,1,'ubit5',0,'l'); bit_count = bit_count + 5;
% Modify.month=fread(fid,1,'ubit4',0,'l'); bit_count = bit_count + 4; 
% Modify.year=fread(fid,1,'ubit7',0,'l'); bit_count = bit_count + 7;

rh.rgain=fread(fid,1,'ushort',0,'l'); bit_count = bit_count + 16;
rh.nrgain=fread(fid,1,'ushort',0,'l')+1; bit_count = bit_count + 16;
rh.text=fread(fid,1,'ushort',0,'l'); bit_count = bit_count + 16;
rh.ntext=fread(fid,1,'ushort',0,'l'); bit_count = bit_count + 16;
rh.proc=fread(fid,1,'ushort',0,'l'); bit_count = bit_count + 16;
rh.nproc=fread(fid,1,'ushort',0,'l'); bit_count = bit_count + 16;
rh.nchan=fread(fid,1,'ushort',0,'l'); bit_count = bit_count + 16;

rh.epsr=fread(fid,1,'float',0,'l'); bit_count = bit_count + 32;
rh.top=fread(fid,1,'float',0,'l'); bit_count = bit_count + 32;
rh.depth=fread(fid,1,'float',0,'l'); bit_count = bit_count + 32;

reserved=fread(fid,31,'char',0,'l'); bit_count = bit_count + 31;
rh.dtype=fread(fid,1,'char',0,'l'); bit_count = bit_count + 1;
rh.antname=fread(fid,14,'char',0,'l'); bit_count = bit_count + 14;
rh.chanmask=fread(fid,1,'ushort',0,'l'); bit_count = bit_count + 16;
rh.name=fread(fid,12,'char',0,'l'); bit_count = bit_count + 12;
rh.chksum=fread(fid,1,'ushort',0,'l'); bit_count = bit_count + 16;
%rh.var=setstr(fread(fid,896,'char'));

rh.breaks = fread(fid,1,'ushort',0,'l'); bit_count = bit_count + 16;
rh.Gainpoints=fread(fid,rh.Gain,'float',0,'l');bit_count = bit_count + 32;
rh.Gain=fread(fid,1,'ushort',0,'l'); bit_count = bit_count + 16;

rh.comments=setstr(fread(fid,rh.ntext,'char',0,'l')); bit_count = bit_count + rh.ntext;
rh.proccessing=fread(fid,rh.nproc,'char',0,'l'); bit_count = bit_count + rh.nproc;

%fseek(fid,0,'bof');
bit_count = bit_count+32600;

%%%%%%%%%%%%% This is designed to find the first trace
start_val = 713800;

for i = 1:4
    fseek(fid,start_val+i,'bof');
    d=fread(fid,[rh.nsamp 101],s_datatype,0,'l');
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
d=fread(fid,[rh.nsamp 101],s_datatype,0,'l');
caxis([0 300])


d(1,:)=d(3,:);
d(2,:)=d(3,:);


d=d+rh.zero;

data.head=rh;
data.samp=d;
fclose(fid);

