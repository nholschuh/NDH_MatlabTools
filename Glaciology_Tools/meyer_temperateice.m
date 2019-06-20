function temperate_thickness = meyer_temperateice(thickness,strainrate,Tsurf,accumulation)

% Meyer, C. R., & Minchew, B. M. (2018).
% Temperate ice in the shear margins of the Antarctic Ice Sheet: Controlling processes and preliminary locations.
% Earth and Planetary Science Letters, 498, 17–26.
% https://doi.org/10.1016/j.epsl.2018.06.028

if exist('accumulation') == 0
diffusion0_or_advectiondiffusion1 = 0;
else
    
diffusion0_or_advectiondiffusion1 = 1;
end

strainrate = strainrate / 3.154e+7; % convert to per/seconds
if exist('accumulation') == 1
    accumulation = accumulation / 3.145e+7; %convert to m/s
end

A = 2.4e-24;
rho = 917;
cp = 2050;
Tm = 273;
K = 2.1;
n = 3;

Br = 2*thickness.^2./(K.*(Tm-Tsurf)).*(strainrate.^(n+1)./A).^(1/n);
Br(find(Br < 0.01)) = 0.01;

if diffusion0_or_advectiondiffusion1 == 0
    crit_strainrate = (K.*(Tm-Tsurf)./(A.^(-1/n).*thickness.^2)).^(n/(n+1));
else
    pe = rho*cp.*accumulation.*thickness/K;
    %%%%lamda = l.*H.^2/(K*(Tm-Tsurf)); Ignoring Lateral Advection
    lamda = 0;
    exp_value = -exp(-((pe.^2)./(Br-lamda))-1);
    
    %%%%%%%%%%%%%% this is done for efficiency in the lambertw calculation
    mean_exp_value = mean(matrix_to_vector(exp_value));
    std_exp_value = std(matrix_to_vector(exp_value));
    
    min_opt = mean_exp_value-3*std_exp_value;
    opts = linspace(min_opt,0,10000);
    dopt = opts(2)-opts(1);
    
    exp_value(find(exp_value < min_opt)) = min_opt;
    exp_value_ind = ceil((exp_value-min_opt)/dopt);
    exp_value_ind(find(exp_value_ind == 0)) = 1;
    
    lambertw_translate = lambertw(opts);
    
    exp_value = lambertw_translate(exp_value_ind);
    
    
    crit_strainrate = 1 - (pe./(Br - lamda)) - (1./pe).*(1+ exp_value);
end

inds = find(strainrate < crit_strainrate);

temperate_thickness = (1-sqrt(2./Br)).*thickness;
temperate_thickness(inds) = 0;

end