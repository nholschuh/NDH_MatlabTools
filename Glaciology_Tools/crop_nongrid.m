function [include_index dir1 dir2] = crop_nongrid(Data,xcol,ycol,within_threshold)
% (C) Nick Holschuh - Penn State University - 2015 (Nick.Holschuh@gmail.com)
% Determines the two dominant flight directions, and eliminates all data
% not included in the flight orientations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% Data - Vector containing columns of the x and y data
% xcol - the index indicating the column containing the x values
% ycol - the index indicating the column containing the y values
% within_threshold - the angle range to allow in the data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

method = 2;
%%%%% Method 1 - This was the originally coded method, looks at adjacent
%%%%% samples, computes the changes in angle between samples, and uses that
%%%%% as a thresholding tool
%%%%%
%%%%% Method 2 - This uses the reduce line complexity functions to cut down
%%%%% the lines, determines the two dominant orientations, and then selects
%%%%% only those lines that apply


if method == 1
    angle1 = [];
    
    for i = 1:length(Data(2:length(Data(:,1)),:))
        angle1(i) = segment_angle([0 0;1 0],[Data(i,xcol) Data(i,ycol); Data(i+1,xcol) Data(i+1,ycol)]);
    end
    
    [results bins] = hist(angle1,20);
    
    [trash ind] = sort(results);
    ind = ind(17:20);
    
    for i = 1:3
        difbin(i) = bins(ind(4)) + bins(ind(i));
    end
    
    difbin = abs(difbin - 90);
    angles = [bins(ind(4)) bins(ind(find(min(difbin) == difbin)))];
    
    include_index = [];
    dir1 = [];
    dir2 = [];
    for i = 1:length(angle1)
        if angle1(i) > angles(1)-within_threshold & angle1(i) < angles(1)+within_threshold
            include_index = [include_index i];
            dir1 = [dir1 i];
        end
        
        if (angle1(i) > angles(2)-within_threshold & angle1(i) < angles(2)+within_threshold)
            include_index = [include_index i];
            dir2 = [dir2 i];
        end
    end
elseif method == 2
    
    [lines line_inds] = reduce_linecomplexity(Data(:,[xcol ycol]),within_threshold,0);
    [outlines outlines_inds inds] = reduce_linecomplexity_downselect(lines,line_inds,Data(:,[xcol ycol]),5000,1000);
    
    for i = 1:length(outlines)
        angle1(i) = segment_angle([0 0;1 0],[outlines{i}(1,xcol) outlines{i}(1,ycol); outlines{i}(end,xcol) outlines{i}(end,ycol)]);
    end
    
    %%%%%%% Here we determine the optimum angles
    [results bins] = hist(angle1,20);
    
    [trash ind] = sort(results);
    ind = ind(17:20);
    for i = 1:3
        difbin(i) = bins(ind(4)) + bins(ind(i));
    end
    difbin = abs(difbin - 90);
    angles = [bins(ind(4)) bins(ind(find(min(difbin) == difbin)))];

    
    include_index = [];
    dir1 = [];
    dir2 = [];    
    for i = 1:length(angle1)
        if angle1(i) > angles(1)-within_threshold & angle1(i) < angles(1)+within_threshold
            include_index = [include_index outlines_inds{i}];
            dir1 = [dir1 outlines_inds{i}];
        end
        
        if (angle1(i) > angles(2)-within_threshold & angle1(i) < angles(2)+within_threshold)
            include_index = [include_index outlines_inds{i}];
            dir2 = [dir2 outlines_inds{i}];
        end
    end    
    
    
    
end





