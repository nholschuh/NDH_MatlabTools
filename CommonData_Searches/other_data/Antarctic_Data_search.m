function z = Antarctic_Data_search(inputvec,data_set)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This searches a given grid and extracts the values at provided points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputvec - stereographic coordinates for the points of interest
% data_set - Number corresponding to the data_set of interest
%               1 - Temperature (ERF_Interim)
%               2 - Temperature ( SeaRise)
%               3 - Accumulation Rate (Arthern et al. 2006 - from Albmap)
%               4 - Accumulation Rate (Van de Berg et al. - from Albmap)
%               5 - Geothermal Flux (Fox Maule et al. - from Albmap)
%               6 - Geothermal Flux (Shapiro and Ritzwoller - from Albmap)
%               7 - Firn Correction (from Albmap)
%               8 - Temperature (Annual Mean 2m Temperature - ERA Interim 2014)
%               9 - Temperature (Annual Mean Skin Temperature - ERA Interim 2014)
%              10 - Helm (2014) dh/dt
%              11 - McMillan (2014) dh/dt (cryosat-2)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% z - The extracted value at points defined by inputvec
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if data_set == 1
    z = grdsearch(inputvec,'Ant_Temperature_ERF_interim.nc');
elseif data_set == 2
    z = grdsearch(inputvec,'SeaRise_2010_AlbmapInfo.nc',{'x1','y1','temp'});
elseif data_set == 3
    z = grdsearch(inputvec,'SeaRise_2010_AlbmapInfo.nc',{'x1','y1','acca'});
elseif data_set == 4
    z = grdsearch(inputvec,'SeaRise_2010_AlbmapInfo.nc',{'x1','y1','accr'});
elseif data_set == 5
    z = grdsearch(inputvec,'SeaRise_2010_AlbmapInfo.nc',{'x1','y1','ghffm'});
elseif data_set == 6
    z = grdsearch(inputvec,'SeaRise_2010_AlbmapInfo.nc',{'x1','y1','ghfsr'});
elseif data_set == 7
    z = grdsearch(inputvec,'SeaRise_2010_AlbmapInfo.nc',{'x1','y1','firn'});
elseif data_set == 8  
    z = grdsearch(inputvec,'Antarctic2mTemp_ERA_Int_2014.nc');
elseif data_set == 9    
    z = grdsearch(inputvec,'AntarcticSkinTemp_ERA_Int_2014.nc');
elseif data_set == 10
    z = grdsearch(inputvec,'Helm_dhdt.grd')
elseif data_set == 11
    load('CS2_dzdt.mat')
    z = matsearch(inputvec,gridx,gridy,AIS_dzdt);
end

