function z = Greenland_Topography_search(inputvec,data_set)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This searches a given grid and extracts the values at provided points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputvec - stereographic coordinates for the points of interest
% data_set - Number corresponding to the data_set of interest
%               1 - Bed (Bamber)
%               2 - Surface (Bamber)
%               3 - Thickness (Bamber)
%               4 - MassCon Bed (Mouginot)
%               5 - MassCon Surface (Mouginot)
%               6 - MassCon Thickness (Mouginot)
%               7 - geoid (Mouginot)
%               8 - Surface (Worldview - 210m)
%               9 - Surface (Full Resolution [30m])
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% z - The extracted value at points defined by inputvec
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exist('data_set') == 0
     data_set = listdlg('ListString',{'1 - Bed (Bamber)' ,...
        '2 - Surface (Bamber)', ...
        '3 - Thickness (Bamber)', ...
        '4 - MassCon Bed (Mouginot)', ...
        '5 - MassCon Surface (Mouginot)', ...
        '6 - MassCon Thickness (Mouginot)', ...
        '7 - geoid (Mouginot)', ...
        '8 - Surface (Worldview - 210m)', ...
        '9 - Surface (Full Resolution [30m])'},'PromptString',sprintf(['Dataset Options:\n-----------------------------']))
end

if data_set == 1
    z = grdsearch(inputvec,'GreenlandBed_Bamber.nc');
elseif data_set == 2
    z = grdsearch(inputvec,'GreenlandSurface_Bamber.nc');
elseif data_set == 3
    z = grdsearch(inputvec,'GreenlandThick_Bamber.nc');
elseif data_set == 4
    % Old Version
    % z = grdsearch(inputvec,'MCdata_set-2015-04-27.nc',{'x','y','bed'});
    z = grdsearch(inputvec,'BedMachineGreenland-2017-09-20.nc',{'x','y','bed'});
elseif data_set == 5
    % Old Version
    % z = grdsearch(inputvec,'MCdata_set-2015-04-27.nc',{'x','y','surface'});
    z = grdsearch(inputvec,'BedMachineGreenland-2017-09-20.nc',{'x','y','surface'});
elseif data_set == 6
    % Old Version
    % z = grdsearch(inputvec,'MCdata_set-2015-04-27.nc',{'x','y','thickness'});
    z = grdsearch(inputvec,'BedMachineGreenland-2017-09-20.nc',{'x','y','thickness'});
elseif data_set == 7    
    z = grdsearch(inputvec,'MCdata_set-2015-04-27.nc',{'x','y','geoid'});
elseif data_set == 8    
    z = grdsearch(inputvec,'WV_Greenland_Surf_210m.nc');
elseif data_set == 9
    
x1 = min(inputvec(:,1));
x2 = max(inputvec(:,1));
y1 = min(inputvec(:,2));
y2 = max(inputvec(:,2));

    load tile_info.mat
    file_inds = find(nc_xlims(:,2) > x1 & nc_xlims(:,1) < x2 & nc_ylims(:,2) > y1 & nc_ylims(:,1) < y2);
    x = min(nc_xlims(file_inds,1)):dx:max(nc_xlims(file_inds,2));
    y = min(nc_ylims(file_inds,1)):dy:max(nc_ylims(file_inds,2));
    zout = zeros(length(y),length(x));
    for i = 1:length(file_inds);
        [xt yt zt] = grdread(files(file_inds(i)).name);
        fillx_ind = find(min(xt) == x):find(max(xt) == x);
        filly_ind = find(min(yt) == y):find(max(yt) == y);
        zout(filly_ind,fillx_ind) = zt;
    end
 
    [z]= matsearch(inputvec,x,y,zout);


end   





