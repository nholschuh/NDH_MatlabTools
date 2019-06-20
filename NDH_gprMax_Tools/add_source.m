function add_source(filename,ascan0_or_bscan1,waveform_freq,waveform_type,antenna_type,cmp_position,sro,steps)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This adds the bed to an already initated domain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% filename - the name of the file to write or output to
% ascan0_or_bscan1 - This defines if the source moves across the domain or
%                    not. Ascan default is in the middle of the domain
% waveform_type - [1] Ricker
% waveform_freq - frequency of the wavelet in Hz
% antenna_type - [1]
% cmp_position - 
% sro - Source/Receiver offset
% steps - 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

freespace_thickness = 15;

if exist('ascan0_or_bscan1') == 0
    ascan0_or_bscan1 = 0;
end
if exist('sro') == 0
    sro = 10;
end

filename = [filename,'.in'];

fid=fopen(filename,'r');
break_flag = 0;
while break_flag == 0
    line = fgetl(fid);
    if str_contain(line,'domain') == 1
        vals = strsplit(line,' ');
        vals = [eval(vals{2}) eval(vals{3}) eval(vals{4})];
        break_flag = 1;
    end
end
fclose(fid);

fid=fopen(filename,'r');
break_flag = 0;
while break_flag == 0
    line = fgetl(fid);
    if str_contain(line,'dx_dy_dz') == 1
        vals2 = strsplit(line,' ');
        vals2 = [eval(vals2{2}) eval(vals2{3}) eval(vals2{4})];
        break_flag = 1;
    end
end
fclose(fid);


if exist('waveform_type') == 0
    waveform_type = 1;
end
if exist('waveform_freq') == 0
    waveform_freq = 3e6;
end
if exist('antenna_type') == 0
    antenna_type = 1;
end
if exist('cmp_position') == 0
    if ascan0_or_bscan1 == 0
        cmp_position = [vals(1)/2 vals(2)/2 vals(3)+1-freespace_thickness];
    else
        cmp_position = [10 vals(2)/2 vals(3)+1-freespace_thickness];
    end
end
if exist('steps') == 0
    steps = [vals2(1) 0 0];
end

if find(max(steps) == steps) == 1
    cmp_offset = [sro/2 0 0];
elseif find(max(steps) == steps) == 1
    cmp_offset = [0 sro/2 0];
end


fid=fopen(filename,'a');

fprintf(fid,'\n',[]);
fprintf(fid,['#waveform: ricker 1 %.3g mywavelet \n'],[waveform_freq]);
fprintf(fid,['#hertzian_dipole: x %.3g %.3g %.3g mywavelet \n'],cmp_position+cmp_offset);
fprintf(fid,['#rx: %.3g %.3g %.3g \n'],cmp_position-cmp_offset);

if ascan0_or_bscan1 == 1
    fprintf(fid,['#src_steps: %.3g %.3g %.3g \n'],steps);
    fprintf(fid,['#rx_steps: %.3g %.3g %.3g \n'],steps);
end


fclose(fid);
















