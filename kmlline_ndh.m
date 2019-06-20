function kmlline_ndh(lat,lon,linenames,outfile_name,line0_poly1_point2,colors)
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Takes input lat/lon data and writes them to a kml
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% lat - vector or cell containing line latitudes
% lon - vector or cell containing line longitudes
% linenames - vector or cell containing line object names
% outfile_name - output filename
% colors - colors for the individual lines
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('colors') == 0
    colors = 'blue';
end
if exist('line0_poly1_point2') == 0;
    line0_poly1_point2 = 0;
end

outshape = geoshape(lat,lon,'Name',linenames);
if line0_poly1_point2 == 0
    outshape.Geometry = 'line';
elseif line0_poly1_point2 == 1
    outshape.Geometry = 'polygon';
elseif line0_poly1_point2 == 2
    outshape.Geometry = 'point';
end

kmlwrite(outfile_name,outshape,'Color',colors);




