function [outlines outlines_inds od_line_inds] = reduce_linecomplexity_downselect(ds_lines,ds_line_inds,original_data,length_thresh,gap_thresh);
%%%%%%%%% This function excludes downsampled lines less than a minimum
%%%%%%%%% length, and containing jumps longer than a maximum gap


distances = distance_vector(original_data(:,1),original_data(:,2),1);
distances2 = distance_vector(ds_lines(:,1),ds_lines(:,2),1);

max_internal_dist = [];
for i = 1:length(ds_line_inds)-1
    max_internal_dist(i) = max(distances(ds_line_inds(i):(ds_line_inds(i+1)-1)));
end


%%%%%% Then we downselect to only those simplified lines which are longer
%%%%%% than 3km and don't contain any significant jumps
start_inds = find(distances2 > length_thresh & max_internal_dist < gap_thresh);


od_line_inds = zeros(size(original_data(:,1)));
for i = 1:length(start_inds)
    outlines{i} = [original_data(ds_line_inds(start_inds(i)):ds_line_inds(start_inds(i)+1),1) original_data(ds_line_inds(start_inds(i)):ds_line_inds(start_inds(i)+1),2)];
    outlines_inds{i} = ds_line_inds(start_inds(i)):ds_line_inds(start_inds(i)+1);
    od_line_inds(ds_line_inds(start_inds(i)):ds_line_inds(start_inds(i)+1)) = i;
end

end