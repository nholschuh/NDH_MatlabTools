function grdfilter(grid,output,x_window_length,y_window_length,order)
% Takes an input gridded data set and filters it according to the
% SavitzkyGolay method. Default window sizes are 9 and 9, with a second
% order polynomial fit.

[x y z] = grdread(grid);
figure(1)
grdplot(grid)

if exist('x_window_length') == 0
    x_window_length = 9;
end
if exist('y_window_length') == 0
    y_window_length = 9;
end
if exist('order') == 0
    order = 2;
end

z_filt = savitzkyGolay2D_rle_coupling(length(x),length(y),z,x_window_length,y_window_length,order);

grdwrite(x,y,z_filt,output)
figure(2)
grdplot(output)

end

