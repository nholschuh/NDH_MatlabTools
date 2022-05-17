function out_rectangle = rectangles_ndh(x_center,y_center,r_length,r_width);
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% x_center - 
% y_center - 
% r_length - 
% r_width - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% out_rectangle - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% First separate the lines
dist = distance_vector(x_center,y_center,1);
mv = mean(dist);
std_v = std(dist);

if mv/std_v > 5
    nan_inds = find(dist > mv+std_v*3);
    nan_counter = 0;
    nan_vec = NaN;
    %%%%%%%% Add in a NaN after all of the points that exceed your std
    %%%%%%%% thresh
    for j = 1:length(nan_inds)
        x_center = [x_center(1:nan_inds(j)+nan_counter); nan_vec; x_center(nan_inds(j)+nan_counter+1:end)];
        y_center = [y_center(1:nan_inds(j)+nan_counter); nan_vec; y_center(nan_inds(j)+nan_counter+1:end)];
        nan_counter = nan_counter+1;
    end
end

for i = 1:length(x_center)-1
    r_opt = make_ortholine([x_center(i:i+1) y_center(i:i+1)],r_width/2,0);
    r_opt = r_opt(2,:) - r_opt(1,:);
    l_opt = make_ortholine([x_center(i:i+1) y_center(i:i+1)],r_width/2,1);
    l_opt = l_opt(2,:) - l_opt(1,:);
    
    f_opt = [x_center(i+1)-mean(x_center(i:i+1)) y_center(i+1)-mean(y_center(i:i+1))];
    f_opt = f_opt/sqrt(f_opt(1).^2+f_opt(2).^2)*r_length/2;
    out_rectangle(i).xy = [x_center(i+1)+f_opt(1)+r_opt(1) y_center(i+1)+f_opt(2)+r_opt(2) ;...
        x_center(i+1)+f_opt(1)+l_opt(1) y_center(i+1)+f_opt(2)+l_opt(2) ;...
        x_center(i+1)-f_opt(1)+l_opt(1) y_center(i+1)-f_opt(2)+l_opt(2) ;...
        x_center(i+1)-f_opt(1)+r_opt(1) y_center(i+1)-f_opt(2)+r_opt(2) ; ...
        x_center(i+1)+f_opt(1)+r_opt(1) y_center(i+1)+f_opt(2)+r_opt(2) ];
        
end

if exist('out_rectangle') == 0;
    out_rectangle(1).xy = [];
end


