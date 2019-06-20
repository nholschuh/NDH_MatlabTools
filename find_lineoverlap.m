function [new_line1 new_line2 new_dist1 new_dist2] = find_lineoverlap(line1,line2,dist_thresh)


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

%%%%%%%%%%%%%%%% If the start of line2 falls within line1;
if d1 < d3 & d1 < dist_thresh
    si1 = ind1;
    si2 = 1;
    nearpoint2 = pos1;
    %%%%%%%%%%% Sets the new distance axis so it is - before start l2
    new_dist1 = dist1-dist1(ind1);
    new_dist2 = dist2+dist1(ind1);
elseif d3 < d1 & d3 < dist_thresh  %%%%%%%%%% Otherwise
    si1 = 1;
    si2 = ind3
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
elseif d4 < d2 & d4 < dist_thresh
    ei1 = length(line1(:,1));
    ei2 = ind4;
    nearpoint2 = pos4;
else
    kill_flag = 1;
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
end

debug_flag = 0;
if debug_flag == 1
    hold off
   plot(line1(:,1),line1(:,2),'o','Color','blue')
   hold all
   plot(line2(:,1),line2(:,2),'.','Color','red')
end

end