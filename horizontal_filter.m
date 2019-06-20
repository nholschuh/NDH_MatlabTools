function [outdata removal_mat] = horizontal_filter(inputdata,window_size,vertical_range,transition_width)
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This function removes values horizontally averaged across an image, to
% reduce scan-line style noise.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% inputdata - The data image
% window_size - The number of samples (or fraction of the total window
%               size) in the horizontal dimension to average over
% vertical_range - The number of samples (or fraction of the total window
%               size) in the vertical dimension to remove
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% outdata - The filtered image
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if mod(window_size,1) == 0
    ws = window_size;
else
    ws = round(length(inputdata(1,:))*window_size);
end

if mod(vertical_range,1) == 0
    vr = vertical_range;
else
    vr = round(length(inputdata(:,1))*vertical_range);
end

if exist('transition_width') == 0
    trans_size = 50;
else
    trans_size = transition_width;
end

%%%%%%%%%%% Define the single column filter
filt_col = ones(length(inputdata(:,1)),1);
filt_col(vr:end) = 0;
filt_col(vr-trans_size:vr+trans_size) = fliplr(sin(linspace(-pi/2,pi/2,trans_size*2+1))/2+0.5);

removal_mat = zeros(size(inputdata));

for i = 1:vr+trans_size-1;
    removal_mat(i,:) = conv(inputdata(i,:),ones(ws,1)*filt_col(i),'same')./ ...
        conv(ones(size(inputdata(i,:))),ones(ws,1),'same');
end

outdata = inputdata - removal_mat;


debug_flag = 0;
if debug_flag == 1
    aa = subplot(2,1,1);
    imagesc(lp(inputdata))
    colormap(gray)
    
    bb = subplot(2,1,2);
    imagesc(lp(inputdata-removal_mat));
    colormap(gray)
    
    linkaxes([aa bb],'xy');
end














