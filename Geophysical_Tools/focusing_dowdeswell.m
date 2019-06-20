function correction = focusing_dowdeswell(H,h,v1)
% (C) Nick Holschuh - Penn State University - 2016 (Nick.Holschuh@gmail.com)
% Computes the refractive focusing correction (in dB) for nadir traveling
% wave through the air/ice interface
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% H - Thickness of the air column
% h - Thickness of the ice column
% v1 - Velocity of the second transmission medium
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cair_import;

q = ((H+h)./(H+(h./(cair/v1)))).^2;

correction = lp(q);

end