function [y1] = A_Velocity_Search(inputvec,xys,data_set)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputvec - stereographic coordinates for the points of interest
% xys - This specifies whether you want ice speeds, x velocities, or y vel.
%       options: 'x','y','s'
% data_set - Number corresponding to the data_set of interest
%               1 - Measures data (1996 - 2011 aggregate, 450m, Rignot)
%               2 - Ian SipleCoast data (2001 - Joughin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('xys') == 0
    xys = 's';
end
if exist('data_set') == 0
     data_set = listdlg('ListString',{'1 - Measures data (1996 - 2011 aggregate, 450m, Rignot)' ,...
        'Ian SipleCoast data (2001 - Joughin)'},'PromptString',sprintf(['Dataset Options:\n-----------------------------']))
end


if data_set == 1
    if xys == 's'
        y1 = grdsearch(inputvec,'Antarctic_speed_1996.nc');
    elseif xys == 'x'
        y1 = grdsearch(inputvec,'Antarctic_vx_1996.nc');
    elseif xys == 'y';
        y1 = grdsearch(inputvec,'Antarctic_vy_1996.nc');
    end
elseif data_set == 2
    if xys == 's'
        y1 = grdsearch(inputvec,'Antarctic_2001_Ian_speed.nc');
    elseif xys == 'x'
        y1 = grdsearch(inputvec,'Antarctic_2001_Ian_vx.nc');
    elseif xys == 'y';
        y1 = grdsearch(inputvec,'Antarctic_2001_Ian_vy.nc');
    end
elseif data_set == 3
    if xys == 's'
        y1 = grdsearch(inputvec,'Antarctic_speed_2017.nc');
    elseif xys == 'x'
        y1 = grdsearch(inputvec,'Antarctic_vx_2017.nc');
    elseif xys == 'y';
        y1 = grdsearch(inputvec,'Antarctic_vy_2017.nc');
    end
end


end
