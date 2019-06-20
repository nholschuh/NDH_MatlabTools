function [trend plunge] = trend_plunge(xyz);
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% Compute the trend and plunge. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% xyz - the x/y/z components of the pointing vector
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% trend - The trend (orientation in horizontal) relative to 0
% plunge - The plunce (vertical angle from the horizontal plane)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
trend = rad2deg(atan2(xyz(1),xyz(2)));

hor_mag = sqrt(xyz(1).^2+xyz(2).^2);
plunge = rad2deg(atan2(xyz(3),hor_mag));

end


