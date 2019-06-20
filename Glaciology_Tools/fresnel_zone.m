function output = fresnel_zone(reflector_depth,frequency,fresnel_number)

if exist('fresnel_number') == 0
    fresnel_number = 1;
end

cice_import;
lambda = cice/frequency;

output = sqrt(fresnel_number*lambda*reflector_depth^2/(2*reflector_depth));

end