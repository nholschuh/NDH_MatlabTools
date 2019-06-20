function z = Greenland_Data_search(inputvec,data_set)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This searches a given grid and extracts the values at provided points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputvec - stereographic coordinates for the points of interest
% data_set - Number corresponding to the data_set of interest
%               1 - Temperature (ERF_Interim)
%               2 - Surface Temperature (Ettema et al 2009 - SeaRise)
%               3 - 2m Temperature (Ettema et al 2009 - SeaRise)
%               4 - Surface Mass Balance ( - SeaRise)
%               5 - Runoff ( - SeaRise)
%               6 - Geothermal Flux ( - SeaRise)
%               7 - dhdt ( - SeaRise)
%               8 - Annual Mean 2m Temperature (ERA Interim - 2014)
%               9 - Annual Mean Skin Temperature (ERA Interim - 2014)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% z - The extracted value at points defined by inputvec
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if data_set == 1
    z = grdsearch(inputvec,'Temperature_ERF_interim.nc');
elseif data_set == 2
    [inputvec2(:,1) inputvec2(:,2)] = polarstereo_inv(inputvec(:,1),inputvec(:,2),2);
    z = grdsearch(inputvec2,'SeaRiseData_5km_dev1.2.nc',{'lat','lon','surftemp'});
elseif data_set == 3
    [inputvec2(:,1) inputvec2(:,2)] = polarstereo_inv(inputvec(:,1),inputvec(:,2),2);
    z = grdsearch(inputvec2,'SeaRiseData_5km_dev1.2.nc',{'lat','lon','airtemp2m'});    
elseif data_set == 4
    [inputvec2(:,1) inputvec2(:,2)] = polarstereo_inv(inputvec(:,1),inputvec(:,2),2);
    z = grdsearch(inputvec2,'SeaRiseData_5km_dev1.2.nc',{'lat','lon','smb'});    
elseif data_set == 5
    [inputvec2(:,1) inputvec2(:,2)] = polarstereo_inv(inputvec(:,1),inputvec(:,2),2);
    z = grdsearch(inputvec2,'SeaRiseData_5km_dev1.2.nc',{'lat','lon','runoff'});    
elseif data_set == 6
    [inputvec2(:,1) inputvec2(:,2)] = polarstereo_inv(inputvec(:,1),inputvec(:,2),2);
    z = grdsearch(inputvec2,'SeaRiseData_5km_dev1.2.nc',{'lat','lon','bheatflx'});    
elseif data_set == 7    
    [inputvec2(:,1) inputvec2(:,2)] = polarstereo_inv(inputvec(:,1),inputvec(:,2),2);
    z = grdsearch(inputvec2,'SeaRiseData_5km_dev1.2.nc',{'lat','lon','dhdt'});        
elseif data_set == 8    
    z = grdsearch(inputvec,'Greenland2mTemp_ERA_Int_2014.nc');
elseif data_set == 9
    z = grdsearch(inputvec,'GreenlandSkinTemp_ERA_Int_2014.nc');
end   





