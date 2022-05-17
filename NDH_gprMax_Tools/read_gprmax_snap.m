function [out_field axes s_pos]= read_gprmax_snap(filename);
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This takes snapshot images from the gprMax output and reads them into the
% workspace

file_parse = strsplit(filename,'/');
sourcef_name = [file_parse{1}];
for i = 2:length(file_parse)-2
    sourcef_name = [sourcef_name,'/',file_parse{1}];
end
sourcef_name = [sourcef_name,'/',file_parse{end-1}(1:end-6),'.in'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% This section reads meta information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% directly from the model input file
fid=fopen(sourcef_name,'r');
if fid ~= -1
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
            s_pos = [eval(vals{3}) eval(vals{4}) eval(vals{5})];
        elseif line == -1
            break_flag = 1;
        end
    end
    fseek(fid,0,'bof');
    break_flag = 0;
    counter = 1;
    while break_flag == 0
        line = fgetl(fid);
        if str_contain(line,'domain') == 1
            vals = strsplit(line,' ');
            domain_size = [eval(vals{2}) eval(vals{3}) eval(vals{4})];
            break_flag = 1;
        end
    end
    fclose(fid);
else
    polarization = 0;
    s_pos = [NaN NaN NaN];
    domain_size = [NaN NaN NaN];
end

%%%%%%%%%%%%%%%%%%%%% Here we read into the snaps themselves, producing a
%%%%%%%%%%%%%%%%%%%%% wave field that depends on the polarization of the
%%%%%%%%%%%%%%%%%%%%% source


head = vtk_read_header(filename);
[volume axes_temp] = vtk_read_volume(head);


if polarization == 0
    out_field = squeeze(sqrt(volume.Efield.Component1.^2+volume.Efield.Component2.^2+volume.Efield.Component3.^2));
elseif polarization == 1
    out_field = squeeze(volume.Efield.Component1);
elseif polarization == 2
    out_field = squeeze(volume.Efield.Component2);
elseif polarization == 3
    out_field = squeeze(volume.Efield.Component3);    
end



ss = size(out_field);
for i = 1:length(axes_temp)
    axis_size(i) = length(axes_temp{i});
end

for i = 1:length(ss)
    axis_num(i) = find(axis_size == ss(i));
end

axes = axes_temp(axis_num);


end
    












