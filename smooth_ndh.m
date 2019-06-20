function output = smooth_ndh(input,window_size,method);
% (C) Nick Holschuh - Penn State University - 2017 (Nick.Holschuh@gmail.com)
% This is an adaptable, 1D or 2D convolution filter that maintains the size
% of the input vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% input - the 1D or 2D data set you wish to filter
% window_size - the size (in samples) for the filter to be applied. For 2D
%               data, this is a square filter.
% method - 0 [average filter], 1 [gaussian filter], 2 [star filter], 3
% [median filter]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('method') == 0
    method = 0;
end

if method == 0 % Mean Filter
    output = convolve2(input,ones(window_size),'same')./convolve2(ones(size(input)),ones(window_size),'same');
    
elseif method == 1 % Gaussian Filter
    output = convolve2(input,gauss_window(window_size),'same')./convolve2(ones(size(input)),gauss_window(window_size),'same');
    
elseif method == 2 % Gaussian Filter
    filt_win = zeros(window_size);
    for i = 1:(window_size+1)/2;
        filt_win(i,((window_size+1)/2-i+1):((window_size+1)/2+i-1)) = 1;
        filt_win(window_size+1-i,((window_size+1)/2-i+1):((window_size+1)/2+i-1)) = 1;
    end
    output = convolve2(input,gauss_window(window_size),'same')./convolve2(ones(size(input)),gauss_window(window_size),'same');
elseif method == 3
    
    if mod(window_size,2) == 0
        window_size = window_size+1;
    end
    
    loops1 = length(input(1,:));
    loops2 = length(input(:,1));
    output = input;
    

    
    for i = 1:loops1
        for j = 1:loops2
            
            low_ind1 = max([i-(window_size-1)/2 1]);
            high_ind1 = min([i+(window_size-1)/2 length(input(1,:))]);
            low_ind2 = max([j-(window_size-1)/2 1]);
            high_ind2 = min([j+(window_size-1)/2 length(input(:,1))]);            
            
            output(j,i) = median(matrix_to_vector(input(low_ind2:high_ind2,low_ind1:high_ind1)));
        end
    end

end