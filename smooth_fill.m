function out_data = smooth_fill(data,window,thresh,method)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function is designed to find points that disagree significantly
%%% with their neighbors and force them to be a smoothed value instead.

method = 3;

if mod(window,2) == 0
    window = window+1;
end

if method == 1

elseif method == 2
    
    
elseif method == 3;
    
    empt_range = 1;
    
    data(find(isnan(data))) = 0;
    
    filter = ones(window);
    filter(ceil(window/2)-empt_range:ceil(window/2)+empt_range,:) = 0;
    filter(:,ceil(window/2)-empt_range:ceil(window/2)+empt_range) = 0;
    
    filt_data = conv2(data,filter,'same')./conv2(ones(size(data)),filter,'same');
    
    swap_inds = find(abs(filt_data - data) > 200);
    out_data = data;
    out_data(swap_inds) = filt_data(swap_inds);
    out_data(find(out_data == 0)) = NaN;
end
    
    
    