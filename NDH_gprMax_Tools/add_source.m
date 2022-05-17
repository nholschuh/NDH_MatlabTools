function add_source(filename,ascan0_or_bscan1,waveform_freq,waveform_type,antenna_type,steps,cmp_position,sro)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This adds the bed to an already initated domain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% filename - the name of the file to write or output to
% ascan0_or_bscan1 - This defines if the source moves across the domain or
%                    not. Ascan default is in the middle of the domain
% waveform_type - [1] Ricker, 2 Sine, 3 gaussiandotnorm
% waveform_freq - frequency of the wavelet in Hz
% antenna_type - [1]
% steps - step size for sequential acquisitions
% cmp_position - [x y z] for the midpoint between source and receiver,
%           remember z increases upward from the bottom of the domain.
% sro - Source/Receiver offset, either a single value (representing
% horizontal distance in the x direction), or an xyz triplet.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

freespace_thickness = 50;

if exist('ascan0_or_bscan1') == 0
    ascan0_or_bscan1 = 0;
end
if exist('sro') == 0
    sro = 50;
end
if exist('waveform_type') == 0
    waveform_type = 1;
end
if exist('waveform_freq') == 0
    waveform_freq = 3e6;
end
if exist('antenna_type') == 0
    antenna_type = 1;
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

if exist('cmp_position') == 0
    if ascan0_or_bscan1 == 0
        cmp_position = [vals(1)/2 vals(2)/2 vals(3)-freespace_thickness];
    else
        startx = max([10 sro/2]);
        cmp_position = [startx vals(2)/2 vals(3)-freespace_thickness];
    end
end

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

if exist('steps') == 0
    steps = [vals2(1) 0 0];
else
    steps = [steps 0 0];
end

if length(sro) == 1
    if find(max(steps) == steps) == 1
        cmp_offset = [sro/2 0 0];
    elseif find(max(steps) == steps) == 2
        cmp_offset = [0 sro/2 0];
    end
elseif length(sro) == 3
    cmp_offset = sro/2;
end


fid=fopen(filename,'a');

fprintf(fid,'\n',[]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Here we add in the waveform
if waveform_type == 1
    fprintf(fid,['#waveform: ricker 1 %.3g mywavelet \n'],[waveform_freq]);
elseif waveform_type == 2
    fprintf(fid,['#waveform: sine 1 %.3g mywavelet \n'],[waveform_freq]);
elseif waveform_type == 3
    fprintf(fid,['#waveform: gaussiandotnorm 1 %.3g mywavelet \n'],[waveform_freq]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Here we add in the Transmit Antenna Type
fprintf(fid,['#hertzian_dipole: x %.3g %.3g %.3g mywavelet \n'],cmp_position+cmp_offset);

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Here we add in the Receiver Position
fprintf(fid,['#rx: %.3g %.3g %.3g \n'],cmp_position-cmp_offset);

if ascan0_or_bscan1 == 1
    fprintf(fid,['#src_steps: %.3g %.3g %.3g \n'],steps);
    fprintf(fid,['#rx_steps: %.3g %.3g %.3g \n'],steps);
end


fclose(fid);
















