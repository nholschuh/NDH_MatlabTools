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
    ldirs = 'CSARP_layer';
else
    if length(layerdir) == 0 | layerdir == 0
        ldirs = 'CSARP_layer';
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
    clearvars bedflag surfflag bedind surfind
    cd(ldirs)
    cd(ld_dirs(i).name);
    ld_files = dir('Data*.mat');
    
    if length(dir('Layer*.mat')) > 0
        lf = dir('Layer*.mat');
        lf_info = load(lf(1).name);
        [surfflag surfind] = strcmp_ndh(lf_info.lyr_name,'surface');
        [bedflag bedind] = strcmp_ndh(lf_info.lyr_name,'bottom');
    else
        surfflag = 1;
        surfind = 1;
        bedflag = 1;
        bedind = 2;
    end
    
    cd ./../../
    
    for j = 1:length(ld_files)
        cd(ldirs)
        cd(ld_dirs(i).name);
        lf_info2 = load(ld_files(j).name);
        cd ./../../
        cd(rdirs)
        if exist(ld_dirs(i).name) ~= 0
            cd(ld_dirs(i).name);
            if exist(ld_files(j).name) ~= 0
                load(ld_files(j).name);
                
                if surfflag == 1
                    %Surface = layerData{1,1}.value{1,2}.data;
                    Elevation = interp1(lf_info2.gps_time,lf_info2.elev,GPS_time,'linear','extrap');
                    Surface = interp1(lf_info2.gps_time,lf_info2.twtt(surfind,:),GPS_time,'linear','extrap');
                end
                
                if bedflag == 1
                    try
                        %Bottom = layerData{1,2}.value{1,2}.data;
                        Bottom = interp1(lf_info2.gps_time,lf_info2.twtt(bedind,:),GPS_time,'linear','extrap');
                    catch
                        warning('No Bottom Information Here')
                    end
                end
                
                rs = resave_string(ld_files(j).name,{'Bottom','Surface'});
                eval(rs);
                clear rs
            end
            cd ./../
        end
        cd ./../
        
    end
    disp(['----- Completed Directory ',num2str(i),' of ',num2str(length(ld_dirs))])
end







