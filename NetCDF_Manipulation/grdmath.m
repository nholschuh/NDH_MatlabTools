function grdmath(grid1,grid2,operation,name)
%% Outputs the result of math between two grids. (1 = add, 2 = subtract)

[gridx1 gridy1 gridz1] = grdread(grid1);
[gridx2 gridy2 gridz2] = grdread(grid2);

xspacing1 = abs(gridx1(2)-gridx1(1));
yspacing1 = abs(gridy1(2)-gridy1(1));

xspacing2 = abs(gridx2(2)-gridx2(1));
yspacing2 = abs(gridy2(2)-gridy2(1));


if xspacing1 < xspacing2
    gridxa = gridx1;
    gridya = gridy1;
    gridza = gridz1;
    gridxb = gridx2;
    gridyb = gridy2;
    gridzb = gridz2;
    t = 1;
    grida = grid1;
    gridb = grid2;
else
    gridxa = gridx2;
    gridya = gridy2;
    gridza = gridz2;
    gridxb = gridx1;
    gridyb = gridy1;
    gridzb = gridz1;
    t = 2;
    grida = grid2;
    gridb = grid1;
end



if length(gridxa) < length(gridxb)
    grdextract(gridb,grida,'math_temp1');
    [gridxb gridyb gridzb] = grdread('math_temp1');
elseif length(gridxb) < length(gridxa)
    grdextract(grida,gridb,'math_temp1');
    [gridxa gridya gridza] = grdread('math_temp1');
end

grdregrid(gridb,grida,'math_temp');
[gridxb gridyb gridzb] = grdread('math_temp');


if operation == 1
    gridzfinal = gridza + gridzb;
end

if operation == 2
    if t == 1
        gridzfinal = gridza - gridzb;
    elseif t == 2
        gridzfinal = gridzb - gridza;
    end
end

delete math_temp
delete math_temp1

grdwrite(gridxb,gridyb,gridzfinal,name);


