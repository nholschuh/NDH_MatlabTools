function [float_ind HAF] = floating(surface,bed);
%%%%%%%%%%% This function takes a surface elevation grid and a bed
%%%%%%%%%%% elevation grid and determines which grid cells are at
%%%%%%%%%%% floatation.

rho_i = 0.917;
rho_w = 1.024;
firnAir_T = 17;
thresh = 5;

T = surface-bed;

HAF = surface - T*(1-rho_i/rho_w) - (rho_i/rho_w)*firnAir_T;
HAF(find(surface <= 0)) = -10000;

float_ind = [HAF > thresh];

end