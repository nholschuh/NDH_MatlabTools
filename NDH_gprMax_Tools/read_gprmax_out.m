function [src rx dist time out]= read_gprmax_out(infile,outfile,all_polarizations);
% (C) Nick Holschuh - U. of Washington - 2017 (Nick.Holschuh@gmail.com)
% This takes the radar output from gprmax models and imports the radar data
% and the relevent positioning information.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% infile - gprmax input file
% outfile - gprmax output file
% all_polarizations - [0] only the polarization of the transmit antennae,
%                     otherwise (1) all polarizations
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% src - source positions
% rx - receiver positions
% dist - distance vector for a zscope
% time - twtt vector for the zscope
% out - the zscope
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('all_polarizations') == 0
    all_polarizations = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% This section reads meta information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% directly from the model input file
fid=fopen(infile,'r');

break_flag = 0;
counter = 1;
while break_flag == 0
    line = fgetl(fid);
    if str_contain(line,'hertzian_dipole') == 1
        vals = strsplit(line,' ');
        if vals{2} == 'x';
            polarization = 1;
        elseif vals{2} == 'y';
            polarization = 2;
        elseif vals{2} == 'z';
            polarization = 3;
        end
        s_pos{counter} = [eval(vals{3}) eval(vals{4}) eval(vals{5})];
        counter = counter+1;
    elseif line == -1
       break_flag = 1; 
    end
end
fseek(fid,0,'bof');
break_flag = 0;
counter = 1;
while break_flag == 0
    line = fgetl(fid);
    if str_contain(line,'src_steps') == 1
        vals = strsplit(line,' ');
        s_steps = [eval(vals{2}) eval(vals{3}) eval(vals{4})];
        break_flag = 1;
    end
end
fseek(fid,0,'bof');
break_flag = 0;
counter = 1;
while break_flag == 0
    line = fgetl(fid);
    if str_contain(line,'rx:') == 1
        vals = strsplit(line,' ');
        r_pos{counter} = [eval(vals{2}) eval(vals{3}) eval(vals{4})];
        counter = counter+1;
    elseif line == -1
       break_flag = 1; 
    end
end
fseek(fid,0,'bof');
break_flag = 0;
while break_flag == 0
    line = fgetl(fid);
    if str_contain(line,'rx_steps:') == 1
        vals = strsplit(line,' ');
        r_steps = [eval(vals{2}) eval(vals{3}) eval(vals{4})];
        break_flag = 1;
    end
end
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Input info End

data = read_h5(outfile);
time = data.Meta.dt:data.Meta.dt:data.Meta.dt*double(data.Meta.Iterations);
rx_f = fields(data.rxs);



for i = 1:length(rx_f);
        size_str = ['ds = size(data.rxs.',rx_f{i},'.Ex);'];
        eval(size_str);    
    if all_polarizations == 1
        data_str = ['out(i).Ex = data.rxs.',rx_f{i},'.Ex'';'];
        eval(data_str);
        data_str = ['out(i).Ey = data.rxs.',rx_f{i},'.Ey'';'];
        eval(data_str);
        data_str = ['out(i).Ez = data.rxs.',rx_f{i},'.Ez'';'];
        eval(data_str);
    elseif polarization == 1
        data_str = ['out(i).Ex = data.rxs.',rx_f{i},'.Ex'';'];
        eval(data_str);
        out(i).polarization = 'x';
    elseif polarization == 2
        data_str = ['out(i).Ey = data.rxs.',rx_f{i},'.Ey'';'];
        eval(data_str);
        out(i).polarization = 'y';
    elseif polarization == 3
        data_str = ['out(i).Ez = data.rxs.',rx_f{i},'.Ez'';'];
        eval(data_str);
        out(i).polarization = 'z';
    end  
end



%%%%%%%%%%%%%%%%%% Compute the receiver positions from the input files
if exist('r_steps') == 1
    for i = 1:length(r_pos);
        rx{i}.xyz = r_pos{i};
        for j = 2:ds(1)
            rx{i}.xyz(j,:) = rx{i}.xyz(j-1,:)+r_steps;
        end
        dist{i} = distance_vector(rx{i}.xyz(:,1),rx{i}.xyz(:,2));
    end    
    if length(rx) == 1;
        rx = rx{i}.xyz;
        dist = dist{i};
    end
else
    for i = 1:length(r_pos);
        rx{i}.xyz = r_pos{i};
    end 
    if length(rx) == 1;
        rx = rx{i}.xyz;
        dist = dist{i};
    end    
end

if exist('s_steps') == 1
    for i = 1:length(s_pos);
        src{i}.xyz = s_pos{i};
        for j = 2:ds(1)
            src{i}.xyz(j,:) = src{i}.xyz(j-1,:)+s_steps;
        end
    end  
    if length(src) == 1;
        src = src{i}.xyz;
    end
else
    for i = 1:length(s_pos);
        src{i}.xyz = s_pos{i};
    end  
    if length(src) == 1;
        src = src{i}.xyz;
    end
end


end


