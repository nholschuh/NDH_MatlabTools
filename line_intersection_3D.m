function [surfs surfs_meta intersection_info] = line_intersection_3D(lines_xy,lines,int_start,line_names)

thresh = 10;

%%%%%%%%%%%%%%%%% This line determines how many possible line intersections
%%%%%%%%%%%%%%%%% there are, based on the plan-view intersections
total_nl = 0;
nl_end = 0;
for i = 1:length(lines)
    total_nl = total_nl + length(lines(i).picks.samp2(:,1));
    nl_end(i+1) = total_nl;
end
intersections = zeros(total_nl);

%%%%%%%%%%%%%%%%% Here we break down the plan-view lines into all of their
%%%%%%%%%%%%%%%%% internal reflectors. Intersections now has flagged all
%%%%%%%%%%%%%%%%% the possible intersecting internal reflections.
prev_nl_counter = 1;
nl_counter = 1;
for i = 1:length(lines)
    for j = 1:length(lines(i).picks.samp2(:,1))
        if isfield(lines(i).picks,'corrected_power_dB') == 1
            new_line{nl_counter} = [lines_xy{i} lines(i).picks.depth(j,:)' lines(i).picks.surf lines(i).picks.corrected_power_dB(j,:)' ones(size(lines(i).picks.power(j,:)'))*i ones(size(lines(i).picks.power(j,:)'))*j];
        else
            new_line{nl_counter} = [lines_xy{i} lines(i).picks.depth(j,:)' lines(i).picks.surf lines(i).picks.power(j,:)' ones(size(lines(i).picks.power(j,:)'))*i ones(size(lines(i).picks.power(j,:)'))*j];
        end
        nl_counter = nl_counter+1;
    end
    
    fills = find(int_start(i,:) == 1);
    for j = fills
        intersections(nl_end(i)+1:nl_end(i+1),nl_end(j)+1:nl_end(j+1)) = 1;
        intersections(nl_end(j)+1:nl_end(j+1),nl_end(i)+1:nl_end(i+1)) = 1;
    end
end

clearvars -except new_line* intersections nl_end lines_xy lines int_start thresh
    


%%%%%%%%%%%%%%%%% Here we do the distance searching through the matrix to
%%%%%%%%%%%%%%%%% identify 3D intersections
intersections_3d = zeros(size(intersections));
min_dist = zeros(size(intersections));
for i = 1:nl_end(end-1)
    temp_lineind = new_line{i}(1,6);
    crossings = find(intersections(i,nl_end(temp_lineind)+1:end) == 1);
    crossings = crossings+nl_end(temp_lineind);
    for j = crossings
        l1x = new_line{i}(:,1);
        l2x = new_line{j}(:,1);
        l1y = new_line{i}(:,2);
        l2y = new_line{j}(:,2);
        l1z = new_line{i}(:,3);
        l2z = new_line{j}(:,3);
        xd = l1x-l2x';
        yd = l1y-l2y';
        zd = l1z-l2z';
        dists = (xd.^2+yd.^2+zd.^2).^(0.5);
        [line_i_min line_j_min] = find(dists == min(min(dists)));
        min_dist(i,j) = min(min(dists));
        min_dist(j,i) = min(min(dists));
        if dists(line_i_min,line_j_min) < thresh
            intersections_3d(i,j) = 1;
            intersections_3d(j,i) = 1;
            intersections_3d_ind{i,j} = [line_i_min line_j_min];
            intersections_3d_ind{j,i} = [line_j_min line_i_min];
            intersections_3d_dist(i,j) = min(min(dists));
            intersections_3d_dist(j,i) = min(min(dists));
        end
    end
end
intersection_info.intersections = intersections_3d;
intersection_info.int_index = intersections_3d_ind;
intersection_info.int_dist = intersections_3d_dist;
intersection_info.min_dist = min_dist;
disp('-----Completed 3D intersection analysis - grouping by surfaces')

%%%%%%%%%%%%%%%%% Here we take the 3D intersections and derive surfaces
%%%%%%%%%%%%%%%%% based on the crossovers

s_counter = 1; %%% This counts through identified unique surfaces
for i = 1:length(new_line)
   cross_lines = find(intersections_3d(i,:) == 1); 
   if length(cross_lines) == 0
       include_flag = 0;
   end
   
   included_lines{s_counter} = i;
   intersections_3d(:,i) = 0;
   surface_points{s_counter} = [new_line{i}];
   
   while length(cross_lines) > 0
       
       include_flag = 1;
       new_cross_lines = [];
       
       for j = 1:length(cross_lines);
           intersections_3d(:,cross_lines(j)) = 0;
       end
       
       for j = 1:length(cross_lines);
           new_cross_lines = [new_cross_lines find(intersections_3d(cross_lines(j),:) == 1)];
           surface_points{s_counter} = [surface_points{s_counter}; new_line{cross_lines(j)}];
           
           for k = 1:length(new_cross_lines)
               intersections_3d(:,new_cross_lines(k)) = 0;
           end
           
           intersections_3d(cross_lines(j),:) = 0;
       end
       
       included_lines{s_counter} = [included_lines{s_counter} cross_lines];
       remove_duplicates(new_cross_lines);
       new_cross_lines = sort(new_cross_lines);
       cross_lines = new_cross_lines;
   end   
   
   if include_flag == 1
       included_lines{s_counter} = sort(included_lines{s_counter});
       s_counter = s_counter+1;
   end

end

surfs = surface_points;
if isfield(lines(i).picks,'corrected_power_dB') == 1
    surfs_meta = {'X coordinate','Y coordinate','Z coordinate','Surface Elevation','Attenuation and Spreading Corrected Reflection Power','Line Index','Pick Index'};
else
    surfs_meta = {'X coordinate','Y coordinate','Z coordinate','Surface Elevation','Reflection Power','Line Index','Pick Index'};    
end
end












