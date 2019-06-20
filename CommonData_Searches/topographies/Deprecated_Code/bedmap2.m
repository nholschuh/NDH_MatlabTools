function [y1,y2,y3] = bedmap2(x1,x2,y1,y2,plotter,m0_km1_flag)
% Generates a bed elevation map using data from BedMap, with the
% size specifications set according to bedmap(x1,x2,y1,y2)

if exist('plotter') == 0
    plotter = 1;
end
if exist('m0_km1_flag') == 0
    m0_km1_flag = 0;
end

[x y z] = grdread('Bedmap2_bed.grd');



x = double(x);
y = double(y);

if m0_km1_flag == 1
    x = x/1000;
    y = y/1000;
end

xsteps = length(x);
ysteps = length(y);
celldim = abs(x(2)-x(1));

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
        
    elseif x1 == 'a',
        x1 = lxvalue;
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

%% Corrects for the fact that the y data is backward
temp = length(y) - y1index;
y1index = length(y) - y2index;
y2index = temp;

%%
z = flipud(z);
bedmap2data = z(y1index:y2index,x1index:x2index);
bedmap2data = flipud(bedmap2data);

if plotter == 1
    imagesc(xscale,yscale,bedmap2data)
    set(gca,'YDir','Normal')
end

y1 = xscale;
y2 = yscale;
y3 = bedmap2data;

end

