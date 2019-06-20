function info =vtk_read_header(filename)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% Heavily modified from a script downloaded from mathworks, designed to
% read .vti files produced from gprMax for visualization purposes. This
% stage reads the header.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% filename
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Function for reading the header of a Visualization Toolkit (VTK)
% 
% info  = vtk_read_header(filename);
%
% examples:
% 1,  info=vtk_read_header()
% 2,  info=vtk_read_header('volume.vtk');

if(exist('filename','var')==0)
    [filename, pathname] = uigetfile('*.vtk', 'Read vtk-file');
    filename = [pathname filename];
end

fid=fopen(filename,'rb');
if(fid<0)
    fprintf('could not open file %s\n',filename);
    return
end

str = fgetl(fid);
info.Filename=filename;

%%%%%%%%%%%%% These are hardcoded values for gprMax. May need to be changed
%%%%%%%%%%%%% later to make the code more adaptable %%%%%%%%%%%%%%%%%%%%%%%
info.DatasetFormat='b';                                 %%%%%%%%%%%%%%%%%%%
info.Datatype='Float32';                                %%%%%%%%%%%%%%%%%%%
info.BitDepth=32;                                       %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

headers = 1;
var_counter = 0;
while headers == 1
    
    str=fgetl(fid);
    s=find(str==' ');
    es=find(str=='=');
    
    %%%%% This parses out the XML, isolating "name"="value" pairs
    s = [0 s length(str)+1];
    es = [0 es length(str)+1];
    
    keep_inds = [];
    for i = 1:length(es)-2;
        inds = find(s > es(i) & s < es(i+1));
        keep_inds = [keep_inds inds(end)];
    end
    keep_inds = [1 keep_inds length(s)];
    
    s = s(keep_inds);

    if(length(s) == 2)
        headers = 0;
    else
        
        name = {};
        value = {};
        %%%%%%%%%%%% This extracts the information from the XML
        for i = 2:length(s)-1;
            temp_str = str(s(i)+1:s(i+1)-1);
            split_ts = strsplit(temp_str,'=');
            split_ts2 = strsplit(split_ts{2},'"');
            name{i-1} = split_ts{1};
            value{i-1} = split_ts2{2};
        end
        
        %%%%%%%%%%%% This determines if there are separate variable names
        order = 1:length(name);
        varflag = 0;
        for i = 1:length(name)
            if length(name{i}) == 4
                if name{i} == 'Name';
                    name_ind = i;
                    varflag = 1;
                    var_counter = var_counter+1;
                    break
                end
            end
        end
        
        %%%%%%%%%%%%% This is where data is written to info into either
        %%%%%%%%%%%%% separate variables or not.
        for i = 1:length(order)
            if varflag == 0
                if isstrprop(value{i}(1),'digit') == 1
                    write_str = ['info.',name{i},' = [',value{i},'];'];
                else
                    write_str = ['info.',name{i},' = ''',value{i},''';'];
                end
            elseif varflag == 1
                if isstrprop(value{i}(1),'digit') == 1
                    write_str = ['info.var(var_counter).',name{i},' = [',value{i},'];'];
                else
                    write_str = ['info.var(var_counter).',name{i},' = ''',value{i},''';'];
                end     
            end
            eval(write_str);
        end
    end
end

for i = 1:3;
    str=fgetl(fid);
end

info.HeaderSize=ftell(fid);


fclose(fid);




