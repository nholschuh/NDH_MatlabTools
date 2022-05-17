function [x y z I] = geotiffread_ndh(filename,xlims,ylims)
% (C) Nick Holschuh - Amherst College - 2020 (Nick.Holschuh@gmail.com)
% This circumvents the mapping toolbox to read in a geotiff (and can
% provide xlim and ylim to subset)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% filename - 
% xlim - 
% ylim - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% out1 - 
% out2 - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('xlims')
    [z,x,y,I]=geoimread(filename,xlims,ylims);
else
    [z,x,y,I]=geoimread(filename);
end


%%%%%%%%%%%%%%%%%%%%% This section requires the mapping toolbox (and is
%%%%%%%%%%%%%%%%%%%%% therefore deprecated).
% [z, R] = geotiffread(filename);
% 
% 
% if isprop(R,'LatitudeLimits');
% x = ((R.LongitudeLimits(1)+R.CellExtentInLongitude/2):R.CellExtentInLongitude:(R.LongitudeLimits(2)-R.CellExtentInLongitude/2));
% y = fliplr((R.LatitudeLimits(1)+R.CellExtentInLatitude/2):R.CellExtentInLatitude:(R.LatitudeLimits(2)-R.CellExtentInLatitude/2))';
% end
% 
% if isprop(R,'XWorldLimits')
% x = ((R.XWorldLimits(1)+R.CellExtentInWorldX/2):R.CellExtentInWorldX:(R.XWorldLimits(2)-R.CellExtentInWorldX/2));
% y = fliplr((R.YWorldLimits(1)+R.CellExtentInWorldY/2):R.CellExtentInWorldY:(R.YWorldLimits(2)-R.CellExtentInWorldY/2))';
% end












