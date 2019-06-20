function sle = icevolume2sle(iv,km_or_m)
% Converts values for ice volume to the melted sea level equivalent.
% Assumes all ice is above flotation. Density of glacial ice assumed to be
% 917 kg/m^3, water 1000 kg/m^3, and the surface area of the ocean to be
% 361*10^6 km^2. The km_or_m flag requires a 0(vol in km^3) or 1(m^3).
if km_or_m == 0
    divisor = 1;
else
    divisor = 10^9;
end

H20_mass = iv*10^9*917/divisor;  %In kg
water_volume = H20_mass/1000;           %In m^3
sle = water_volume/361/10^12;

end

