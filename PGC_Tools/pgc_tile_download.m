function pgc_tile_download(filein,outdir,wholeTar_or_dem)
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% Download the 8m REMA tile based on URL provided from the shape file index
% function (find_REMA_tile.m). Current version sources REMA 1.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% filein - structure containing tile names and tile URLS
% outdir - [optional] specific name for the download directory
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('wholeTar_or_dem') == 0
    wholeTar_or_dem = 1;
end

time0 = now;

for i = 1:length(filein);
    if exist('outdir') == 0
        if exist('./DEM_Tiles') == 0
            mkdir('DEM_Tiles')
        end
        ad_local_dir = ['./DEM_Tiles/',filein(i).tile,'/'];
    else
        ad_local_dir = outdir;
    end
    
    if exist(ad_local_dir) == 0
        mkdir(ad_local_dir);
    end
    
    fileurl = filein(i).fileurl;
    [flag_10 rep_inds] = str_contain(fileurl,'1.0');
    if flag_10 == 1
        fileurl(rep_inds(1):rep_inds(2)) = '1.1';
    end
    
    [~,fName,ext] = fileparts(fileurl); 
    local_path_tar = fullfile(ad_local_dir, [fName,ext]);
    
    
    if exist([local_path_tar(1:end-7),'_dem.tif']) == 0 & exist([local_path_tar(1:end-7),'.tar']) ==0
        fprintf('Downloading PGC Tile %s: %.1fmin\n', filein(i).tile, time0-(now))

        % save in tempfile then rename
        [~, FF] = fileparts(tempname);
        foo_path = fullfile(ad_local_dir, [FF, ext]);
        websave(foo_path, fileurl);
        
        % rename file when complete
        movefile(foo_path, local_path_tar)
        
        % unzip tile
        untar(local_path_tar, fullfile(ad_local_dir, fName))
        
        if wholeTar_or_dem == 1
        movefile([local_path_tar(1:end-3),'/',filein(i).tile,'_8m_dem.tif'],ad_local_dir)
        rmdir(local_path_tar(1:end-3),'s')
        end
        delete(local_path_tar)
        
        fprintf('Downloaded PGC Tile %s: %.1fmin\n', filein(i).tile, (now-time0)*24*60)
        pause(3)
    elseif exist([local_path_tar(1:end-7),'_dem.tif']) ~= 0 & wholeTar_or_dem == 0
        fprintf('You have the file, but not the whole .tar folder')
    elseif exist([local_path_tar(1:end-7),'.tar']) ~= 0 & wholeTar_or_dem == 1
        fprintf('You have the whole .tar file, but not just the individual file in the folder')    
    end        
        fprintf('------ File already exists\n')
    end
end