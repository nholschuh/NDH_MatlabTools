function output = density_to_conductivity(rho_p,init_sigma,method)
% (C) Nick Holschuh - UW - 2017 (Nick.Holschuh@gmail.com)
% This function uses a mixing model to compute the dielectric conductivity
% of snow or firn based on its density. The input and output value is in
% microsiemens/meter (compatible with units for MacGregors model of
% attenuation rate).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% rho_p - Density (or densities) used to calculate velocity
% init_sigma - Conductivity of glacial ice [default - ]
% method - [1] Glen and Peren (1975)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


if exist('method') == 0
    method = 1;
end

if exist('init_sigma') == 0
    init_sigma_opts = [4.5 ... % Camplin and Glen [1973]
        9.2 ... %                Johari and Charette [1975]
        12.7 ...%                Takei and Maeno [1987]
        6.1 ... %                Moore et al [1997]
        6 ...   %                Matsuoka et al. [1996]
        4.9 ... %                Barnes et al [2002]
        7.2 ... %                MacGregor et al [2007] - all references are found here
        6.6];   %
    init_sigma = init_sigma_opts(end);
else
    init_sigma = init_sigma*10^6;
end


if method == 1
    output = init_sigma.*(rho_p./0.917).*(0.68+0.32*rho_p/0.917).^2;
end











