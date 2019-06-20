function [y1] = G_Velocity_Search(inputvec,xys,data_set)
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
     data_set = listdlg('ListString',{'1 - Measures 2015 mosaic' ,...
        '2 - Measures 2008-09 Data', ...
        '3 - Measures 2000-01 Data', ...
        '4 - Measures 2005-06 Data', ...
        '5 - Measures 2006-07 Data', ...
        '6 - Measures 2007-08 Data', ...
        '7 - Measures 2009-10 Data', ...
        '8 - Measures 2012-13 Data', ...
        '9 - Sentinal1 2014-15 Data', ...
        '10 - Sentinal1 2015-16 Data', ...
        '11 - Sentinal1 2016-17 Data'},'PromptString',sprintf(['Dataset Options:\n-----------------------------']))
end



if data_set == 1
    if xys == 's'
        y1 = grdsearch(inputvec,'greenland_vel_mosaic250_v1.nc');
    elseif xys == 'x'
        y1 = grdsearch(inputvec,'greenland_vel_mosaic250_vx_v1.nc');
    elseif xys == 'y';
        y1 = grdsearch(inputvec,'greenland_vel_mosaic250_vy_v1.nc');
    end
elseif data_set == 2
    if xys == 's'
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2008_2009_v2.nc');
    elseif xys == 'x'
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2008_2009_vx_v2.nc');
    elseif xys == 'y';
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2008_2009_vy_v2.nc');
    end
elseif data_set == 3
    if xys == 's'
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2000_2001_v2.nc');
    elseif xys == 'x'
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2000_2001_vx_v2.nc');
    elseif xys == 'y';
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2000_2001_vy_v2.nc');
    end
elseif data_set == 4
    if xys == 's'
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2005_2006_v2.nc');
    elseif xys == 'x'
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2005_2006_vx_v2.nc');
    elseif xys == 'y';
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2005_2006_vy_v2.nc');
    end
elseif data_set == 5
    if xys == 's'
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2006_2007_v2.nc');
    elseif xys == 'x'
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2006_2007_vx_v2.nc');
    elseif xys == 'y';
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2006_2007_vy_v2.nc');
    end
elseif data_set == 6
    if xys == 's'
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2007_2008_v2.nc');
    elseif xys == 'x'
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2007_2008_vx_v2.nc');
    elseif xys == 'y';
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2007_2008_vy_v2.nc');
    end    
elseif data_set == 7
    if xys == 's'
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2009_2010_v2.nc');
    elseif xys == 'x'
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2009_2010_vx_v2.nc');
    elseif xys == 'y';
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2009_2010_vy_v2.nc');
    end
elseif data_set == 8
    if xys == 's'
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2012_2013_v2.nc');
    elseif xys == 'x'
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2012_2013_vx_v2.nc');
    elseif xys == 'y';
        y1 = grdsearch(inputvec,'GMT_greenland_vel_mosaic500_2012_2013_vy_v2.nc');
    end
elseif data_set == 9
    if xys == 's'
        y1 = grdsearch(inputvec,'greenland_iv_500m_s1_20141101_20151201_v1_0.nc',{'land_ice_surface_velocity_magnitude',1,'x','y'});
    elseif xys == 'x'
        y1 = grdsearch(inputvec,'greenland_iv_500m_s1_20141101_20151201_v1_0.nc',{'land_ice_surface_easting_velocity',1,'x','y'});
    elseif xys == 'y';
        y1 = grdsearch(inputvec,'greenland_iv_500m_s1_20141101_20151201_v1_0.nc',{'land_ice_surface_northing_velocity',1,'x','y'});
    end
    y1 = y1*365.25;
elseif data_set == 10
    if xys == 's'
        y1 = grdsearch(inputvec,'greenland_iv_500m_s1_20151223_20160331_v1_0.nc',{'land_ice_surface_velocity_magnitude',1,'x','y'});
    elseif xys == 'x'
        y1 = grdsearch(inputvec,'greenland_iv_500m_s1_20151223_20160331_v1_0.nc',{'land_ice_surface_easting_velocity',1,'x','y'});
    elseif xys == 'y';
        y1 = grdsearch(inputvec,'greenland_iv_500m_s1_20151223_20160331_v1_0.nc',{'land_ice_surface_northing_velocity',1,'x','y'});
    end
    y1 = y1*365.25;
elseif data_set == 11
    if xys == 's'
        y1 = grdsearch(inputvec,'greenland_iv_500m_s1_20161223_20170227_v1_0.nc',{'land_ice_surface_velocity_magnitude',1,'x','y'});
    elseif xys == 'x'
        y1 = grdsearch(inputvec,'greenland_iv_500m_s1_20161223_20170227_v1_0.nc',{'land_ice_surface_easting_velocity',1,'x','y'});
    elseif xys == 'y';
        y1 = grdsearch(inputvec,'greenland_iv_500m_s1_20161223_20170227_v1_0.nc',{'land_ice_surface_northing_velocity',1,'x','y'});
    end
    y1 = y1*365.25;
end


end
