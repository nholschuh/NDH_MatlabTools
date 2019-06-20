function potential = hydropotential_grid(Surfacegrid,Bedgrid);
%Calculates the Hydraulic Potential Given data for the Ice Surface
%Elevation and Ice Bed Elevation. Results are in MPa

[SurfaceX SurfaceY SurfaceZ] = grdread(Surfacegrid);
[BedX BedY BedZ] = grdread(Bedgrid);

rhoi = 917;
rhow = 1000;
g=9.8;
h = SurfaceZ - BedZ;

potential = rhoi*g*h+rhow*g*BedZ/(10^6);

grdwrite(BedX,BedY,potential,'Hydropotential.nc');

end