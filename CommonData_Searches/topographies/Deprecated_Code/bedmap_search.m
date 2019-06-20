function [y1] = bedmap_search(x)
% Takes polar stereographic elevation and locates the corresponding cell in 
% bedmap, and provides the elevation.

x1 = x(:,1);
x2 = x(:,2);

bedmapdata = textread('groundbed1.txt');
bedmapdata = bedmapdata(2:length(bedmapdata(:,1)),1:(length(bedmapdata(1,:))-1));

for i = 1:length(bedmapdata(:,1))
    bedmap2(i,:) = bedmapdata((length(bedmapdata(:,1))+1-i),:);
end

bedmapdata = bedmap2;

importedx = x1;
importedy = x2;

diffvec = zeros(length(importedx),1);
bedmapelevationatpoint = zeros(length(importedx),1);
dataelevationatpoint = zeros(length(importedx),1);

lxvalue = -2661600;
lyvalue = -2149967;
celldim = 5000;

%ysivec = zeros(length(importedx),1);
%xsivec = zeros(length(importedx),1);

for i = 1:length(importedx)
        xsearch = importedx(i);
        ysearch = importedy(i);
    
        xsi = floor((xsearch-lxvalue)/celldim)+1;
        ysi = floor((ysearch-lyvalue)/celldim)+1;
        
       %xsivec(i) = xsi;
       %ysivec(i) = ysi;
        
        bedmapelevation = bedmapdata(ysi,xsi);
        bedmapelevationatpoint(i) = bedmapelevation;
end


%xsivec = xsivec*celldim+lxvalue;
%ysivec = ysivec*celldim+lyvalue;


y1 = bedmapelevationatpoint;

        