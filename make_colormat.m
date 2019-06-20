function color_out = make_colormat(matrix_template,color_in);
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This function creates a matrix with a size equal to the matrix_template,
% containing values for the desired color;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% matrix_template - matrix with size of interest
% color - either a string or vector containing the colorval
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


matsize = size(matrix_template);
color_in = color_call(color_in)/255;

color_out = zeros([matsize 3]);
color_out(:,:,1) = color_in(1);
color_out(:,:,2) = color_in(2);
color_out(:,:,3) = color_in(3);
end
















