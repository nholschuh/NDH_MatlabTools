function correction = focusing_radioglaciology(H,h,v0,v1,p)
% (C) Nick Holschuh - Penn State University - 2016 (Nick.Holschuh@gmail.com)
% Computes the refractive focusing correction (in dB) for a given set of
% survey parameters using equation (3.8) from Bogorodsky (page 43)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% H - Thickness of the first transmission medium
% h - Thickness of the second transmission medium
% v0 - Velocity of the first transmission medium
% v1 - Velocity of the second transmission medium
% p - Ray Parameter (horizontal slowness, or sin(theta)/v)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


theta1 = asin(p*v0);
theta2 = asin(p*v1);

r_over_r = ((H./h) + 1)./((H./h) + (tan(theta2)./tan(theta1)));

correction = lp(r_over_r.^2);

end




