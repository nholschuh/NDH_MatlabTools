function prefactor_value = prefactor(temp,depth)
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Calculate the typical ice viscosity value for a given temperature
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% temperature - t value in kelvin
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% prefactor_value - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


Ao = 3.5*10^-25; % Cuffey and Patterson 74
T0 = 273.15;
R = 8.314;% J/mol-K

Qc_low = 60000;
Qc_high = 115000;

if length(temp) ~= length(depth)
    if length(depth) > length(temp)
        temp = ones(size(depth))*temp;
    else
        depth = ones(size(depth))*depth;
    end
end


for i = 1:length(temp)
    if temp(i) > 263.15
        prefactor_value(i) = Ao*exp(-Qc_high./R.*(1./temp(i) - 1/(T0-10)));
    else
        prefactor_value(i) = Ao*exp(-Qc_low./R.*(1./(temp(i)+7*10^-8*9.8*917*depth(i)) - 1/(T0-10+7*10^-8*9.8*917*depth(i))));
    end
end


end











