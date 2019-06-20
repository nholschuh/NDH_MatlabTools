function gmt_to_qgis_colormap(filein,fileout)
% Converts a gmt_colormap to a QGIS Colormap


fid = fopen(filein);
data = textscan(fid,'%s','Delimiter','\n');

include_rows = [];

for i = 1:length(data{1})
    if max(isstrprop(data{1}{i},'alpha')) == 0 & length(data{1}{i}) > 8
        include_rows = [include_rows; i];
    end
end

fclose(fid);
colors = dlmread(filein,'\t',[min(include_rows)-1 0 max(include_rows)-1 7]);

if isdir('C:\Users\Nick\OneDrive\Matlab_Code\GIS_Data\Defined_Colormaps') == 1
    prefix = ['C:\Users\Nick\OneDrive\Matlab_Code\GIS_Data\Defined_Colormaps'];
else
    prefix = ['.\'];
end

fid2 = fopen([prefix,fileout],'w');
fprintf(fid2,'%s \n','# Generated using Matlab Code Written by NDH');
fprintf(fid2,'%s \n','INTERPOLATION:INTERPOLATED');

if colors(2:4) ~= colors(6:8)
    fprintf(fid2,'%.0f,%.0f,%.0f,%.0f,%.0f,%.1f \n',[colors(1,1:4) 255 colors(1,1)]);
end

for i = 1:length(colors(:,1))
    fprintf(fid2,'%.0f,%.0f,%.0f,%.0f,%.0f,%.1f \n',[colors(i,5:8) 255 colors(i,5)]);
end

fclose(fid2);

end
    




        

