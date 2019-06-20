function grdintensity(grid1,factor)
% Reduces the values of an intensity grid by factor 'factor'

[x y z] = grdread(grid1);

z = z*factor;

if max(max(z)) > 1
    z = z/(max(max(z)));
end

grdwrite(x,y,z,grid1);