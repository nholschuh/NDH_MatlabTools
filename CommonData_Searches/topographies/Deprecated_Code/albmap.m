function [y1,y2,y3] = albmap(x1,x2,y1,y2,varname)
% Generates a bed elevation map using data from BedMap, with the
% size specifications set according to bedmap(x1,x2,y1,y2)

if exist('varname') == 0
    [x y z] = grdread('ALBMAP.nc');
else
    [x y z] = grdread('ALBMAP.nc',varname);
end
    

x = double(x);
y = double(y);

xsteps = length(x);
ysteps = length(y);
celldim = x(2)-x(1);

lxvalue = min(x);
lyvalue = min(y);
hxvalue = max(x);
hyvalue = max(y);


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


albmapdata = z(y1index:y2index,x1index:x2index);


mesh(xscale,yscale,albmapdata)

y1 = xscale;
y2 = yscale;
y3 = albmapdata;

end

