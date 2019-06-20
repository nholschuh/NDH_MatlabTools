function [y1,y2,y3] = bedmap(x1,x2,y1,y2)
% Generates a bed elevation map using data from BedMap, with the
% size specifications set according to bedmap(x1,x2,y1,y2)

bedmapdata = textread('groundbed1.txt');
bedmapdata = bedmapdata(2:length(bedmapdata(:,1)),1:(length(bedmapdata(1,:))-1));

xsteps = 1068;
ysteps = 869;
celldim = 5000;

lxvalue = -2661600;
lyvalue = -2149967;
hxvalue = ((xsteps-1)*celldim+lxvalue);
hyvalue = ((ysteps-1)*celldim+lyvalue);


if exist('x1','var') == 1
    if  x1 == 'w'
    x1 = lxvalue;
    x2 = 0;
    y1 = lyvalue;
    y2 = hyvalue;
    
    elseif x1 == 'e'
    x1 = 0;
    x2 = hxvalue;
    y1 = lyvalue;
    y2 = hyvalue;
    else

             x1 = x1 ;


        if exist('x2','var') == 0
             x2 = hxvalue;
        else
                x2 = x2 ;
        end

        if exist('y1','var') == 0
            y1 = lyvalue;
        else
            y1 = y1 ;
        end

        if exist('y2','var') == 0
            y2 = hyvalue;
        else
            y2 = y2 ;
        end
    end
else
    
    x1 = lxvalue;

if exist('x2','var') == 0
    x2 = hxvalue;
else
    x2 = x2 ;
end

if exist('y1','var') == 0
    y1 = lyvalue;
else
    y1 = y1 ;
end

if exist('y2','var') == 0
    y2 = hyvalue;
else
    y2 = y2 ;
end
end

x1index = round((x1-lxvalue)/celldim)+1;
x2index = round((x2-lxvalue)/celldim);
y1index = round((y1-lyvalue)/celldim)+1;
y2index = round((y2-lyvalue)/celldim);

lowx = x1index*celldim+lxvalue;
lowy = y1index*celldim+lyvalue;
highx = x2index*celldim+lxvalue;
highy = y2index*celldim+lyvalue;

xscale = lowx:celldim:highx;
yscale = lowy:celldim:highy;

for i = 1:length(bedmapdata(:,1))
    for j = 1:length(bedmapdata(1,:))
        if bedmapdata(i,j) == -9999
            bedmapdata(i,j) = NaN;
        end
    end
end

for i = 1:length(bedmapdata(:,1))
    bedmap2(i,:) = bedmapdata((length(bedmapdata(:,1))+1-i),:);
end

bedmapdata = bedmap2(y1index:y2index,x1index:x2index);


mesh(xscale,yscale,bedmapdata)

y1 = xscale;
y2 = yscale;
y3 = bedmapdata;

end



