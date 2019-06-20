timeslice = 11;


[x y z] = grdread('fort.92.nc','logcrhmel',timeslice);
grdwrite(x,y,z,'sliding_coefficient.nc')
[x y z] = grdread('fort.92.nc','frozfac',timeslice);
grdwrite(x,y,z,'frozen_fraction.nc')
grdregrid('frozen_fraction.nc',1,'frozen_mask.nc')

%% Create a mask for the frictions according to where the bed is frozen

[x y z] = grdread('frozen_mask.nc');
fmask = zeros(length(y),length(x))*NaN;
fmask(z>(0.3)) =  5;
grdwrite(x,y,fmask,'frozen_mask.nc');

%% Pull out ice surface, and compute the difference from bedmap ice surface

[x y z] = grdread('fort.92.nc','hs',timeslice);
grdwrite(x*1000,y*1000,z,'ice_surface.nc');
grdextract2('Bedmap2_surface.grd','ice_surface.nc','b2_small')
grdmath('ice_surface.nc','b2_small',2,'difference.nc')

%% Return the axes to km
[x y z] = grdread('ice_surface.nc');
grdwrite(x/1000,y/1000,z,'ice_surface.nc')
[x y z] = grdread('difference.nc');
grdwrite(x/1000,y/1000,z,'difference.nc')

%% Delete the temporary grids
delete b2_small