function cresis_updatelayers(segments,layerdir,imagedir);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This takes information stored in the layerdata files and writes it into
% CSARP_Standard Files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% segments - This is a string, with the day and flight numbers of interest.
%            If left blank, this is done for all files in the directory
%
% layerdir - Name of the layerdata directory ['CSARP_layerData']
%
% imagedir - Name of the focused image directory ['CSARP_standard'];
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('segments') == 0;
    segments = {[]};
end
if length(segments) == 0;
    segments = {[]};
end

if exist('layerdir') == 0
    ldirs = 'CSARP_layerData';
else
    if length(layerdir) == 0 | layerdir == 0
        ldirs = 'CSARP_layerData';
    else
        ldirs = layerdir;
    end
end

if exist('imagedir') == 0
    rdirs = 'CSARP_standard';
else
    if length(imagedir) == 0 | imagedir == 0
        rdirs = 'CSARP_standard';
    else
        rdirs = imagedir;
    end
end

ld_dirs = [];
for i = 1:length(segments)
    temp = folders([ldirs,'/',segments{i}]);
    ld_dirs = [ld_dirs; temp];
end

disp(['Total Directories = ',num2str(length(ld_dirs))])
for i = 1:length(ld_dirs)
    cd(ldirs)
    cd(ld_dirs(i).name);
    ld_files = dir('*.mat');
    cd ./../../
    
    for j = 1:length(ld_files)
        cd(ldirs)
        cd(ld_dirs(i).name);
        load(ld_files(j).name);
        cd ./../../
        cd(rdirs)
        if exist(ld_dirs(i).name) ~= 0
            cd(ld_dirs(i).name);
            if exist(ld_files(j).name) ~= 0
                load(ld_files(j).name);
                Surface = layerData{1,1}.value{1,2}.data;
                Bottom = layerData{1,2}.value{1,2}.data;
                
                rs = resave_string(ld_files(j).name);
                eval(rs);
                clear rs
            end
            cd ./../
        end
        cd ./../
        
    end
    disp(['----- Completed Directory ',num2str(i),' of ',num2str(length(ld_dirs))])
end







