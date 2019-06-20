function outline = make_angleline(input_line,seg_length,angle);
% (C) Nick Holschuh - Penn State University - 2013 (Nick.Holschuh@gmail.com)
% Takes an input line and generates a line orthogonal to it.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% input_line - 2x2 input line
% seg_length - The length of the orthogonal line
% angle - 0-360, angle from the original vector.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%



if exist('seg_length') == 0
    dists = distance_vector(input_line(:,1),input_line(:,2));
    seg_length = max(dists);
end
if seg_length == 0;
    dists = distance_vector(input_line(:,1),input_line(:,2));
    seg_length = max(dists);    
end

if exist('r_or_l') == 0
    r_or_l = 0;
end

input_line_2 = input_line;

diffline = 2*input_line(1,:)-input_line(2,:);
input_line_2 = input_line_2 - [diffline; input_line_2(1:end-1,:)];


out_point = points_rotate(input_line_2,angle);


op_length = sqrt(out_point(:,1).^2+out_point(:,2).^2);
out_point = out_point./repmat(op_length,1,2)*seg_length;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% This will either output the coordinates that
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% define an orthogonal line (ie, the original
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% point, and the original point plus the
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% orthogonal vector), or just the orthogonal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% vector if a string of points are provided
if length(out_point(:,1)) == 2
    outline = [input_line(1,:); out_point+input_line(1,:)];
else
    outline = [out_point];
end





