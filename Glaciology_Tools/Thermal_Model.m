function [T z] = thermal_model(thickness,T_atm,a,shear)

%%%%%% 1-D thermal solution (Perol, Rice, Platt, and Suckale - 2015)

debug = 0;
if debug == 1
    shear = 0.058;
    thickness = 888;
    T_atm = 247;
    a = 0.1
end

spy = 3.154e+7;

z = 1:1:thickness;
rho_ice = 917;
R = 8.314; % J/molK

%%% Quantities needed to approximate the integral:
dlamda = 0.01;
lamda = dlamda/2:dlamda:1-dlamda/2;

P = rho_ice*9.8*thickness;%Pressure
T_melt = 273.16 - 7.42*10^-8*P; %Pressure Melting Point (Cuffey and Patterson, pg 406)
T_avg = (T_atm + T_melt)/2;

%%% These Values come from Cuffey and Patterson (pg 400)
C = 152.5+7.122*T_avg; %Specific Heat Capacity
K = 9.828*exp(-5.7*10^-3*T_avg); %Thermal Conductivity, evaluated at an average value
Pe = a*thickness*rho_ice*C/K/spy; %Peclet Number

%%%%% Required Variables
% T_melt = Pressure melting point (Celsius)
% T_atm = Surface Temperature (Celsius)
% z = vertical position (measured from the base of the ice column)
% H = ice thickness
% tau_lat = shear stress
% gamma_lat = shear strain-rate
% tg_prod = tau_lat*gamma_lat;


T_h = T_avg + (273.15-T_melt);

A_star = 3.5*10^-25;
if T_h < 263
    Q = 60000;
else
    Q = 115000;    
end

% Creep Relation Prefactor (Cuffey and Patterson pg 72)
A = A_star*exp((-Q/R)*((1/(T_avg+7*10^-8*P)) - (1/T_h)));
tg_prod = (2*A.^(-1/3))*(shear/2/spy)^(4/3);


for i = 1:length(z)
    diffusion_advection_scaler(i) = erf(sqrt(Pe/2).*(z(i)/thickness))./erf(sqrt(Pe/2));
    
    T_noshear(i) = T_melt + (T_atm - T_melt)*diffusion_advection_scaler(i);
    
    scaler(i) = sum( (1-exp(-1*lamda*Pe.*z(i).^2./(2.*thickness.^2))) ./ (2.*lamda.*sqrt(1-lamda))).*dlamda - ...
       erf(sqrt(Pe./2).*(z(i)./thickness)) ./(erf(sqrt(Pe./2))) .*sum((1-exp(-1.*lamda.*Pe./2))./(2*lamda.*sqrt(1-lamda))).*dlamda;
    
    T(i) = T_melt + (T_atm - T_melt).*erf(sqrt(Pe/2).*(z(i)/thickness))./erf(sqrt(Pe/2)) - ...
       tg_prod.*thickness.^2./(K*Pe).*scaler(i);
   
    shear_heat_prod(i) = tg_prod*spy/rho_ice/C;
    dT(i) = T_noshear(i)-T(i);
    dx = 1000;
    advective_heat_loss(i) = dT(i)/dx;
   
    if T(i) > T_melt;
        T(i) = T_melt;
    end
end
    
 

end
    
    
    
    
    
    
    
    
    
    
    
    