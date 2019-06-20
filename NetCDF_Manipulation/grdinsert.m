function grdinsert(grid1,grid2,name)
% Inserts the data from grid 1 into grid 2

grdregrid(grid1,grid2,'temp_insert');


[gridx1 gridy1 gridz1] = grdread('temp_insert');
[gridx2 gridy2 gridz2] = grdread(grid2);

for i = 1:length(gridx2)
        if gridx1(1) == gridx2(i)
            startx = i;
            break
        end
end

for i = 1:length(gridy2)
    if gridy1(1) == gridy2(i)
        starty = i;
        break
    end
end


for i = 1:length(gridx1)
    for j = 1:length(gridy1)
        if isnan(gridz1(j,i)) == 0
        gridz2(starty-1+j,startx-1+i) = gridz1(j,i);
        end
    end
end

delete temp_insert

grdwrite(gridx2,gridy2,gridz2,name);