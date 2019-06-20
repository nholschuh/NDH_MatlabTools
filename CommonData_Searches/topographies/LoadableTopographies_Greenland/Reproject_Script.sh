#!/bin/bash

f_name=./GreenlandThick_Bamber
OnePath=/mnt/d/Users/Nick/Google_Drive

gdal_translate -of GTiff $f_name.nc $f_name.tiff

gdalwarp -s_srs $OnePath/GMT_Code/GDAL_Utilities/Arctic_39.proj4 -t_srs $OnePath/GMT_Code/GDAL_Utilities/Arctic_45.proj4 $f_name.tiff $f_name"2".tiff

gdal_translate -of GMT $f_name"2".tiff $f_name.nc

rm $f_name"2".tiff $f_name.tiff







