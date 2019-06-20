function lightgrid = light_ndh(grid_data,orientation,truncate_frac,diffuse,smooth_wind,lin_or_log)
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This function is designed to apply lighting to a gridded data set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% grid - 
% orientation - 
% truncate_frac - 
% diffuse - 
% smooth_wind - 
% transparency - 
% plotter - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% out1 - 
% out2 - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('truncate_frac') == 0
    truncate_frac = 1;
end
if exist('diffuse') ~= 1
    diffuse = 0;
end
if exist('smooth_wind') == 0
    smooth_wind = 1;
end
if exist('lin_or_log') == 0
    lin_or_log = 1;
end

[bs by] = gradient(grid_data);
orientation = orientation/sqrt(orientation(1).^2+orientation(2).^2);

o_grid(:,:,1) = ones(size(grid_data))*orientation(1);
o_grid(:,:,2) = ones(size(grid_data))*orientation(2);
tg(:,:,1) = bs;
tg(:,:,2) = by;

bgrad = dot(tg,o_grid,3);

if lin_or_log == 1
bgrad = sign(bgrad).*log10(abs(bgrad));
end

if smooth_wind > 1
    bgrad = smooth_ndh(bgrad,smooth_wind);
end
bgrad = bgrad / (max(max(abs(bgrad)))/truncate_frac)/2;
bgrad(find(abs(bgrad) > 0.5)) = 0.5*sign(bgrad(find(abs(bgrad) > 0.5)));
bgrad = bgrad+0.5;
diffuse_light = diffuse;

bgrad(find(bgrad > 1-diffuse_light)) = 1-diffuse_light;
bgrad = bgrad+diffuse_light;


lightgrid(:,:,1) = bgrad;
lightgrid(:,:,2) = bgrad;
lightgrid(:,:,3) = bgrad;

