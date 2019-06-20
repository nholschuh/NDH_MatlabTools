function output = outlier_removal(data,filt_window,threshold)

%%%%%%%%%%%% This computes the local average excluding the current point
smooth_data = conv2(data,ones(filt_window),'same');
smooth_data = smooth_data - data;
smooth_data = smooth_data./(conv2(ones(size(data)),ones(filt_window),'same')-ones(size(data)));


sd = std(removeNaN(matrix_to_vector(smooth_data)));
swap_ind = find(abs(smooth_data - data) > sd*threshold);
output = data;
output(swap_ind) = smooth_data(swap_ind);
end
