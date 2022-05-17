function [new_line1 new_line2 new_dist1 new_dist2 inds1_of_original2 inds2_of_original1] = find_lineoverlap(line1,line2,dist_thresh)
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% This function takes two line inputs with their x and y coordinates in the
% first two columns, finds any sections that are overlapping, and
% interpolates them onto the same axes to produce an output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% line1 - An Nx2 [or NxM] matrix containing the x, y, and additional
%           variable fields of a line that may overlap with line2
% line2 - An Nx2 [or NxM] matrix containing the x, y, and additional
%           variable fields of a line that may overlap with line1
% dist_thresh - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% new_line1 - The x and y coordinates and subsequent fields of line 1, 
%             interpolated onto the original positions of line 2 
% new_line2 - The x and y coordinates and subsequent fields of line 2,
%             interpolated onto the original positions of line 1
% new_dist1 - The along-line distance axis for new_line1, relative to the
%             original along-line distances of line2
% new_dist2 - The along-line distance axis for new_line2, relative to the
%             original along-line distances of line1
% inds1_of_original2 - The indecies of input line2 that correspond to the
%                       positions of new_line1 
% inds2_of_original1 - The indecies of input line1 that correspond to the
%                       positions of new_line2
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

kill_flag = 0;

%%%%%%%%%% This identifies if the start or end of line2 fall within
%%%%%%%%%% line1
[ind1 pos1 d1] = find_nearest_xy(line1(:,1:2),line2(1,1:2));
[ind2 pos2 d2] = find_nearest_xy(line1(:,1:2),line2(end,1:2));

%%%%%%%%%% This identifies if the start or end of line1 fall within
%%%%%%%%%% line2
[ind3 pos3 d3] = find_nearest_xy(line2(:,1:2),line1(1,1:2));
[ind4 pos4 d4] = find_nearest_xy(line2(:,1:2),line1(end,1:2));

dist1 = distance_vector(line1(:,1),line1(:,2));
dist2 = distance_vector(line2(:,1),line2(:,2));

if exist('dist_thresh') == 0;
    dist_thresh = nanmean(diff(dist1))*3;
end

%%%%%%%%%%%%%%%% If the start of line2 falls within line1;
if d1 < d3 & d1 < dist_thresh
    si1 = ind1;
    si2 = 1;
    nearpoint2 = pos1;
    %%%%%%%%%%% Sets the new distance axis so it is - before start l2
    new_dist1 = dist1-dist1(ind1);
    new_dist2 = dist2+dist1(ind1);
elseif d3 <= d1 & d3 < dist_thresh  %%%%%%%%%% Otherwise
    si1 = 1;
    si2 = ind3;
    nearpoint2 = pos3;
    nearpoint2 = pos1;
    new_dist1 = dist1+dist2(ind3);
    new_dist2 = dist2-dist2(ind3);
else
    kill_flag = 1;
end

%%%%%%%%%%%%%%%% If the end of line2 falls within line1;
if d2 < d4 & d2 < dist_thresh
    ei1 = ind2;
    ei2 = length(line2(:,1));
    nearpoint2 = pos2;
elseif d4 <= d2 & d4 < dist_thresh
    ei1 = length(line1(:,1));
    ei2 = ind4;
    nearpoint2 = pos4;
else
    kill_flag = 1;
end

if kill_flag == 0
    if ei1-si1 <= 1 | ei2-si2 <= 1
        kill_flag = 1;
    end
end

if kill_flag == 0
    %%%%%%%%%%%%%%%% We then interpolate onto their respective distance axes
    for i = 1:length(line1(1,:));
        new_line1(:,i) = interp1(new_dist1(si1:ei1),line1(si1:ei1,i),dist2);
    end
    for i = 1:length(line2(1,:));
        new_line2(:,i) = interp1(new_dist2(si2:ei2),line2(si2:ei2,i),dist1);
    end
    
    %%%%%%%%%%%%%%%% Now we remove data that fall outside the overlapping
    %%%%%%%%%%%%%%%% region
    inds2_of_original1 = find(~isnan(new_line2(:,1)));
    inds1_of_original2 = find(~isnan(new_line1(:,1)));
    
    rm_inds1 = find(isnan(new_line1(:,1)));
    rm_inds2 = find(isnan(new_line2(:,1)));

    new_line1(rm_inds1,:) = [];
    new_line2(rm_inds2,:) = [];

    new_dist1 = dist2;
    new_dist2 = dist1;
    new_dist1(rm_inds1) = [];
    new_dist2(rm_inds2) = [];
else
    new_line1 = NaN;
    new_line2 =  NaN;
    new_dist1 =  NaN;
    new_dist2 = NaN;
    inds1_of_original2 = NaN;
    inds2_of_original1 = NaN;
end

debug_flag = 0;
if debug_flag == 1
    hold off
   plot(line1(:,1),line1(:,2),'o','Color','blue')
   hold all
   plot(line2(:,1),line2(:,2),'.','Color','red')
end

end