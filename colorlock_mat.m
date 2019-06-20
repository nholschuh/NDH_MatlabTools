function output = colorlock_mat(input,colormap_str,colorrange);
% (C) Nick Holschuh - Penn State University - 2016 (Nick.Holschuh@gmail.com)
% Converts an NxMx1 matrix to an RGB NxMx3 matrix with a fixed colormap,
% either provided using the colormap_str and colorrange inputs or using the
% current, default colormap
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are:
%
% input - matrix of values that correspond to specific colors in a colormap
% colormap_str - string, the name of the prescribed colormap, or an Nx3
%               matrix containing the numeric values of the colormap
% colorrange - the caxis limits to impose when generating the rgb-matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are:
%
% output - n x m x 3 matrix containing rgb values for the input matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nan_ind = find(isnan(input));
inf_ind = find(input == Inf);
input(inf_ind) = max(max(input(find(input ~= Inf))));
n_inf_ind = find(input == -Inf);
input(n_inf_ind) = min(min(input(find(input ~= -Inf))));

if exist('colormap_str') == 0
    cmap = colormap;
    if length(get(gca,'Children')) > 0 & exist('colorrange') == 0;
        colorrange = caxis;
    end
else
    if isstr(colormap_str) == 1
        cmap = eval(colormap_str);
    else
        cmap = colormap_str;
    end
end


if exist('colorrange') == 0
    colorrange = [min(min(input)) max(max(input))];
end
if colorrange == 0
    
end


color_opts = linspace(colorrange(1),colorrange(2),length(cmap(:,1)));
dc = color_opts(2)-color_opts(1);
mincol = color_opts(1);
input2 = input-mincol;

input2 = round_to(input2,dc);
input2 = round(input2/dc)+1;

output = ind2rgb(input2,cmap);
t1 = output(:,:,1);
t2 = output(:,:,2);
t3 = output(:,:,3);

%%%%%%% White_or_NaN?
white_or_nan = 1;
if white_or_nan == 0
t1(nan_ind) = 1;
t2(nan_ind) = 1;
t3(nan_ind) = 1;
else
t1(nan_ind) = NaN;
t2(nan_ind) = NaN;
t3(nan_ind) = NaN;    
end
output(:,:,1) = t1;
output(:,:,2) = t2;
output(:,:,3) = t3;

end


function output = round_to(input,rt_value)
%% Rounds to a prescribed degree of precision (can be any value)

scaler = 1/rt_value;
output = round(input*scaler)/scaler;

end

