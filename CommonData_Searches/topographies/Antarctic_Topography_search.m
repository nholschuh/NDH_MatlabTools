function z2 = Antarctic_Topography_search(inputvec,data_set)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This searches a given grid and extracts the values at provided points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputvec - stereographic coordinates for the points of interest
% data_set - Number corresponding to the data_set of interest
%               1 - Bedmap2 Bed
%               2 - Bedmap2 Surface
%               3 - Bedmap2 thickness
%               4 - Geoid to WGS84 Correction [These values should be added
%                                              to geoid data (like bedmap2)
%                                              to bring the data in line
%                                              with the WGS84 reference
%                                              (like MCoRDS)]
%               5 - Cryosat2 Surface (Helm 2014 - WGS84)
%               6 - Albmap Bed
%               7 - Bedmap1 Bed
%               8 - Ground Mask
%               9 - Ben Smith Surface Elevation (WGS84)
%               10 - Morlighem Mass Con Antarctica Bed
%               11 - REMA DEM of Antarctica (200m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% z - The extracted value at points defined by inputvec
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exist('data_set') == 0
     data_set = listdlg('ListString',{'1 - Bedmap2 Bed' ,...
        '2 - Bedmap2 Surface', ...
        '3 - Bedmap2 thickness', ...
        '4 - Geoid to WGS84 Correction', ...
        '5 - Cryosat2 Surface (Holt 2014)', ...
        '6 - Albmap Bed', ...
        '7 - Bedmap1 Bed', ...
        '8 - Ground Mask', ...
        '9 - BenSmith Surface}'},'PromptString',sprintf(['Dataset Options:\n-----------------------------']))
end

if data_set == 1
    [x y z] = geotiffread_ndh('bedmap2_bed.tif');
    %[x y z] = grdread('Bedmap2_bed.grd');
elseif data_set == 2
    [x y z] = geotiffread_ndh('bedmap2_surface.tif');
    %[x y z] = grdread('Bedmap2_surface.grd');
elseif data_set == 3
    [x y z] = geotiffread_ndh('bedmap2_thickness.tif');
    %[x y z] = grdread('Bedmap2_thickness.grd');
elseif data_set == 4
    [x y z] = grdread('g104c_geoid_to_WGS84.nc');
elseif data_set == 5
    [x y z] = grdread('AntarcticSurface_Cryosat2.nc');
elseif data_set == 6
    [x y z] = grdread('ALBMAP_Bed.grd');
elseif data_set == 7    
    [x y z] = grdread('bedmap1.nc');
elseif data_set == 8 
    load moa_groundedmask.mat
    x = ix;
    y = iy;
    z = gl_mask;
    clearvars ix iy gl_mask
elseif data_set == 9
    [x y z] = grdread('BenSurface.nc');
elseif data_set == 10
    [x y z] = grdread('MC_Bed.nc');
elseif data_set == 11   
    [x y z] = grdread('REMA_200m_dem.nc');
end    

z2 = interp2(x,y,double(z),inputvec(:,1),inputvec(:,2));

end

