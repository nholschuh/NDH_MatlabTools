function axis_equal(aspect_ratio)
% (C) Nick Holschuh - University of Washington - 2016 (Nick.Holschuh@gmail.com)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are:
% aspect_ratio - this sets the vertical exaggeration of the data. Higher
% numbers mean more verticaly stressed (0.1 is all axes equal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if length(aspect_ratio) == 1
    set(gca,'cameraviewanglemode','manual')
    set(gca, 'DataAspectRatio', [0.1 0.1 aspect_ratio]) 
elseif length(aspect_ratio) == 3
    set(gca,'cameraviewanglemode','manual')
    set(gca, 'DataAspectRatio', [aspect_ratio])     
end