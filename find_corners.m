function output = find_corners(input_matrix,bg_val,x,y);
% (C) Nick Holschuh - University of Washington (2017 - Nick.Holschuh@gmail.com)
% This function takes an image matrix that contains a rectangle of real
% information and finds the corners
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% input_matrix - the image matrix
% bg_val - the value that defines non-data cells (default = NaN)
% x - [optional] the xaxis for the image (default is indecies)
% y - [optional] the yaxis for the image (default is indecies)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%
% output - Nx2 vector containing the corners of the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


if exist('bg_val') == 0
    method = 1;
elseif isnan(bg_val) == 1
    method = 1;
else
    method = 2;
end

if exist('x') == 0
    x = 1:length(input_matrix(1,:));
end
if exist('y') == 0
    y = 1:length(input_matrix(:,1));
end

%%%%%%%%%%% Find xlims then ylims

if method == 1
    indicator_mat = isnan(input_matrix);
elseif method == 2
    indicator_mat = [input_matrix == bg_val];
end

vertical_collapse = max(indicator_mat);
horizontal_collapse = max(indicator_mat,[],2);

vert_edges = find(horizontal_collapse == 1);
vert_edges = vert_edges([1 length(vert_edges)]);
hor_edges = find(vertical_collapse == 1);
hor_edges = hor_edges([1 length(hor_edges)]);



%%%%%%%%%% Find the horizontal edges on the vert edges
output = [];

ind_opts = find(indicator_mat(vert_edges(1),:) == 0);
output(1,:) = [x(ind_opts(1)) y(vert_edges(1))];
output(2,:) = [x(ind_opts(end)) y(vert_edges(1))];   

ind_opts = find(indicator_mat(:,hor_edges(1)) == 0);
output(3,:) = [x(hor_edges(1)) y(ind_opts(1))];
output(4,:) = [x(hor_edges(1)) y(ind_opts(end))]; 

ind_opts = find(indicator_mat(vert_edges(2),:) == 0);
output(5,:) = [x(ind_opts(1)) y(vert_edges(2))];
output(6,:) = [x(ind_opts(end)) y(vert_edges(2))];   

ind_opts = find(indicator_mat(:,hor_edges(2)) == 0);
output(7,:) = [x(hor_edges(2)) y(ind_opts(1))];
output(8,:) = [x(hor_edges(2)) y(ind_opts(end))]; 

output(end+1,:) = output(1,:);
end
    
    
    
    
    





