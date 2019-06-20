function output = find_local_max(d_series_orig,z_axis_ind,z_axis,conv_window,shifter,method,plotter)
% (C) Nick Holschuh - Penn State University - 2015 (Nick.Holschuh@gmail.com)
% This calculates local maxima in a data series
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% d_series_orig - The original data (can be NxMxO data), computes local
%               maxima along a preferred orientation
% z_axis_ind - The index of the preferred orientation
%                   1 - Max of a Row
%                   2 - Max of a Column
%                   3 - Max along the third dimension
% z_axis - The values that correspond to indecies along the preferred axis
% conv_window - The area used for averaging
% shifter - ?
% method - scaling of the values to find maxima (0 - squared, 1 - no
%                   scaling)
% plotter - flag with a [0] or a 1 to show the process and result
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('plotter') == 0
    plotter = 0;
end
if exist('method') == 0
    method = 0;
end
if exist('shifter') == 0
    shifter = 0;
end


correction = min(min(min(d_series_orig)));

if z_axis_ind == 1
    series = d_series_orig-min(min(min(d_series_orig)));
elseif z_axis_ind == 2
    series = permute(d_series_orig-min(min(min(d_series_orig))),[2 1 3]);
elseif z_axis_ind == 3
    series = permute(d_series_orig-min(min(min(d_series_orig))),[3 1 2]);
end

ss = size(series);
if length(ss) < 3
    ss(3) = 1;
end
if length(shifter) > 1
    shifter = repmat(reshape(shifter,size(series(:,1,1))),1,ss(2));
end


if method == 0
    temp_series = series.^2;
else
    temp_series = series;
end
for i = 1:ss(3)
    if conv_window == 0
        thresh_series(:,:,i) = zeros(size(temp_series(:,:,i)));
    else
        thresh_series(:,:,i) = conv2(ones(conv_window,1),1,temp_series(:,:,i),'same')./conv2(ones(conv_window,1),1,ones(size(temp_series(:,:,i))),'same');
    end
    if method == 0
        thresh_series(:,:,i) = sqrt(thresh_series(:,:,i))+shifter;
    else
        thresh_series(:,:,i) = thresh_series(:,:,i)+shifter;
    end
end

output = {};
plotoutput = {};

for i = 1:ss(2)
    for j = 1:ss(3)
        
        indecies = find(series(:,i,j) > thresh_series(:,i,j));
        index_dif = indecies(2:end)-indecies(1:end-1);
        separators = find(index_dif > 1);
        separators = [0; separators; length(indecies)];
        counter = 1;
        output{i,j} = [];
        if length(separators) > 2
            for k = 1:length(separators)-1;
                temp_index = indecies(separators(k)+1:separators(k+1));
                max_ind = find(max(series(temp_index,i,j)) == series(temp_index,i,j));
                output{i,j}(counter,:) = [z_axis(temp_index(max_ind(1))) series(temp_index(max_ind(1)),i,j)+correction temp_index(max_ind(1))];
                if plotter == 1
                    plotoutput{i,j}(counter,:) = [z_axis(temp_index(max_ind(1))) series(temp_index(max_ind(1)),i,j) temp_index(max_ind(1))];
                end
                counter = counter+1;
            end
        end
        
        if i == 1 & j == 1 & plotter == 1
            plot(z_axis,series(:,i,j),'Color','black')
            hold all
            plot(z_axis,thresh_series(:,i,j),'Color','blue')
            if length(plotoutput{i,j}) > 0
                plot(plotoutput{i,j}(:,1),plotoutput{i,j}(:,2),'o','Color','red')
            end
            pause(1)
        end
        
    end
end
end