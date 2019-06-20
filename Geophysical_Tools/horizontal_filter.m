function out_data = horizontal_filter(data,window,data_window,taper_width,taper_type);
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This function horizontally filters radar data, removing any obvious
% banding from the signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are:
%
% data - The input radargrams
% window - The horizontal window width used to calculate the average trace
% data_window - matrix, with paired rows indicating the top and bottom
%               index to filter
% taper_width - The width of the tapering into the included window
% taper_type - (0) linear (1) gaussian
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are:
%
% out_data - Horizontally filtered data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


inp_filter = ones(1,window);
%%%% Horizontal averaging
filt_data = conv2(data,inp_filter,'same');
filt_scale = conv2(ones(size(data)),inp_filter,'same');

% %%%% Make sure the initial traces are the average of the same number of
% %%%% traces
% for i = 1:round(window/2)
%     filt_scale(:,i) = filt_scale(:,round(window/2));
% end
% for i = (length(data(1,:))-round(window/2)):length(data(1,:))
%     filt_scale(:,i) = filt_scale(:,length(data(1,:))-round(window/2));
% end


matched_data = filt_data./filt_scale;

%%
%%%%%%% Taper into the prescribed window
if exist('data_window') == 1
    if exist('taper_width') == 0
        taper_width = 1;
    end
    
    if exist('taper_type') == 0 | taper_width == 1
        taper1 = 1;
        taper_type = -1;
    end
    
    %%% Define the tapering function
    if taper_type == 0
        taper1 = [1:taper_width]/taper_width;
    elseif taper_type == 1
        taper1 = gauss_window(taper_width*2,2);
        taper1 = taper1(round(length(taper1(:,1))/2),1:taper_width);
        taper1 = taper1/max(taper1);
    end
    
    taper2 = fliplr(taper1);
    
    %%% Create the tapering filter
    taper_filt = zeros(size(filt_data));
    for j = 1:floor(length(data_window(:,1))/2)
        min_ind = find(min(data_window(j:2*j,1)) == data_window(j:2*j,1));
        max_ind = find(max(data_window(j:2*j,1)) == data_window(j:2*j,1));
        for i = 1:length(data_window(1,:))
            taper_filt(data_window((j-1)*2+min_ind,i):data_window((j-1)*2+max_ind),i) = 1;
            
            %%%% Add in the tapers on the edges
            taper_filt(data_window((j-1)*2+min_ind,i):(data_window((j-1)*2+min_ind,i)+taper_width-1),i) = taper1;
            taper_filt((data_window((j-1)*2+max_ind,i)-taper_width+1):data_window((j-1)*2+max_ind,i),i) = taper2;
        end
    end
else
    taper_filt = ones(size(matched_data));
end

matched_data = matched_data.*taper_filt;

out_data = data-matched_data;




