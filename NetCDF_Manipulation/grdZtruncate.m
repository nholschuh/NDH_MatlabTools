function grdZtruncate(grid1,value,gorl,outputname)
% Either enters NaN's into all cells with values < (0) the absolute value
% provided in "value" or > (1)

[x y z] = grdread(grid1);

for i = 1:length(x)
    for j = 1:length(y)
        if gorl == 1
        if abs(z(j,i)) > value
            z(j,i) = NaN;
        end
        end
        if gorl == 0
        if abs(z(j,i)) < value
            z(j,i) = NaN;
        end
        end
    end
end

grdwrite(x,y,z,outputname);