function out_component = directional_component(dx,dy,azimuth);
% (C) Nick Holschuh - UW - 2017 (Nick.Holschuh@gmail.com)
% This takes in a vector field (dx/dy) and computes the component of that
% field in a particular direction. Useful for taking the directional
% derivative of a field given a "gradient()" output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% dx - the x component of the vector field
% dy - the y component of the vector field
% azimuth - degrees (counter-clockwise from the horizontal axis) for the
%           directional derivative
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%



unit_vec = [cos(deg2rad(-azimuth)) sin(deg2rad(-azimuth))];

out_component = dx*unit_vec(1)+dy*unit_vec(2);

