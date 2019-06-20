%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Flip_2017Files
%%%%%%%%%%%%%%%%%%%%%%%%%%

files = dir('*2017*.nc');

for i = 1:length(files)
    [x y z] = grdread(files(i).name);
    y = fliplr(y);
    z = flipud(z);
   
    grdwrite(x,y,z,files(i).name);
end



