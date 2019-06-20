#!/bin/sh

gmtset MEASURE_UNIT m 
 LABEL_FONT_SIZE 12

gmtset PAPER_MEDIA Custom_7.5ix7.5i
gmtset HEADER_OFFSET 0.35i HEADER_FONT_SIZE 12 HEADER_FONT 4 LABEL_FONT 4


#############################################
#   Sets up Consistent Plotting Parameter   #
#############################################


J=-JX5i/5i				# Cartesian Projection, 5inches on each side
JS=-JS0/-90/5i
Rkm=-R-2300/2300/-2300/2300
Rm=-R-2300000/2300000/-2300000/2300000
RS=-R-146.3099/-76.7435/-180/-86.3087r
C=-Cgray				# Color Palette Ranges



grid=./Dropbox/Matlab_Code/NDH_Tools/velocities/Ant_ice_speed.grd

mapname=ant_vel.ps


#############################################
#   Plotting of the map                     #
#############################################

# Write the colormap for the satellite image



# Plot the image and the x/y scales

gmtset TICK_LENGTH 0.1i GRID_PEN_PRIMARY black TICK_PEN black
psbasemap $J $Rkm -X1.25i -Y1.25i -K -Ba100:"Easting (km)":/a100:"Northing (km)":/:."Siple Coast":WneS > $mapname

grdimage $grid -Cvelocity.cpt $J -Q -O -K $Rm >> $mapname

psscale -B500 -Cvelocity.cpt -E -O -Q -D5.25i/2.5i/5i/0.125i >> $mapname

for i in *.ps
do
	ps2pdf $i 
done








