function [results] = firn_profile(acc,temp,rho_0)
% Using the empirical relationships derived in Herron and Langway (1980) I
% defined this function to produce firn density profiles. Provide
% surface temperature in celsius, accumulation rate in m of water per year,
% and density in kg/m^3.

% Default values are:
% Accumulation: 0.3 m / year 
if acc == 0
    acc = 0.3;
end
% Temperature: -20 C
if temp == 0
    temp = -20;
end
% Surface Density: 0.3 Mg/m^3
if rho_0 == 0
    rho_0 = 350;
end

% Calculation of the first and second rate constants from the arrhenius
% relationships:

T = temp+273;
R = 8.314;
rho_i = 0.917;
rho_0 = rho_0 / 1000;  % Convert to Mg/m^3 (g/cc)

k0 = 11*exp(-10160/(R*T));
k1 = 575*exp(-21400/(R*T));

depth = 1:6000;

for i = 1:length(depth)
    z0 = exp(rho_i*k0*depth(i)+log(rho_0/(rho_i-rho_0)));
    rho(i) = rho_i*z0/(1+z0);
end

if z0 == Inf
    rho = ones(size(rho))*0.917;
else
    cutoff = find_nearest(rho,0.55);
    for i = cutoff:6000
        z1 = exp(rho_i*k1*(depth(i)-depth(cutoff))/acc^0.5 + log(0.55/(rho_i-0.55)));
        rho(i) = rho_i*z1/(1+z1);
    end
end



results = [depth; rho*1000]';
end