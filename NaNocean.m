function NaNOcean(grid1,outgrid)
% If the ocean values around the grid are all set to 0, converts them to
% NANs

[x y z] = grdread(grid1);

ztemp = z./z;

for i = 1:length(x)-2
    for j = 1:length(y) - 2
        if ztemp(j+1,i) == 1 & ztemp(j+1,i+2) == 1 & ztemp(j,i+1) == 1 & ztemp(j+2,i+1) == 1
            ztemp(j+1,i+1) = 1;
        end
    end
end

zfinal = ztemp.*z;

grdwrite(x,y,zfinal,outgrid);

end
