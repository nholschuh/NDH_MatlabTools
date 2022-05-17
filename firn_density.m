function p_z = firn_density(zs,p_0,A,T)

% Herron and Langway

reasonable_A = 0.3;
reasonable_p_0 = 0.45;
reasonable_T = -5+273;

if exist('A') == 0
    A = reasonable_A;
else
    if A == 0
        A = reasonable_A;
    end
end
if exist('p_0') == 0
    p_0 = reasonable_p_0;
else
    if p_0 == 0
        p_0 = reasonable_p_0;
    end
end
if exist('T') == 0
    T = reasonable_T;
else
    if T == 0
        T = reasonable_T;
    end
end


p_i = 0.917;
R = 8.314;

if p_0 > 1
    p_0 = p_0/1000;
end

% Stage 1 Densification: 0.3 kg/m^3 - 0.55 kg/m^3

k_0 = 11*exp(-10160/(R*T)); % Rate Constant
z0 = exp(p_i*k_0*zs+log(p_0/(p_i - p_0)));
p_z = p_i*(z0)./(1+z0); % Finds Density as a function of depth

p_z(find(isnan(p_z))) = Inf;


%%%%%%%%%% Set density above the surface to zero
pre_surf_inds = find(zs < 0);
p_z(pre_surf_inds) = 0;

indexes = find(p_z > 0.55);

if length(indexes) > 1;
    
    z_s1 = zs(indexes(1));
    p_top = real(p_z(indexes(1)));
    
    % Stage 1 Densification: 0.3 kg/m^3 - 0.55 kg/m^3
    
    k_1 = 575*exp(-21400/(R*T));
    z1 = exp(p_i*k_1*(zs-z_s1)/A^0.5 + log(p_top/(p_i - p_top)));
    p_z(indexes) = p_i*(z1(indexes))./(1+z1(indexes));
end

p_z(find(p_z== Inf | isnan(p_z))) = p_i;

end



