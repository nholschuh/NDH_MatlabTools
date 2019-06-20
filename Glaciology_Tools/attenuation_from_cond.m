function att_rate = attenuation_from_cond(sigma,radar_frequency,method);
cice_import
cair_import
e_0 = 8.85418782 * 10^-12; 
e_prime = (cair/cice)^2;

if exist('method') == 0;
    method = 1;
end

if method == 1 % - From Wikipedia, Loss Tangent
%%% Equation - tan(d) = e''/e'
%%%            sigma = e'' * e_0 * ang_f
%%%
%%%            tan(d) = sigma/(e' * e_0 * ang_f)
%%%            e_0 = 8.85418782 * 10^-12
%%%            ang_f = 2*pi*f
%%%
%%%            LF = exp(-d * k * z)
%%%            log_10(LF) = -d * k * z * log_10(e)
%%%            LF_dB = -d * k * z * 10*log_10(e)
%%%
%%%            dB/m == -d * k * 10*log_10(e)
%%%            dB/km == -d * k * 10*log_10(e) * 1000
%%%
%%%            k = 2*pi / lamda
%%%            lamda = V / f
%%%            lamda = (C/sqrt(e')) / f


ang_f = 2*pi*radar_frequency;
lamda = cice/radar_frequency;
k = 2*pi / lamda;

d = atan(sigma/(e_prime*e_0*ang_f));

att_rate = d * k * 10*log10(exp(1))*1000;

elseif method == 2 % From MacGregor et al 2007, Skin Depth
    %%% Equation Att_Length = e_0 * sqrt(e') * c / sigma
    %%%          Target_Att = 1000 * 10*log10(exp(1)) * (1/Att_Length)
    %%%          sigma = 1000 * 10*log10(exp(1)) * e_0 * sqrt(e') * c
    %%%          sigma units = S/m
    %%%                        S = A/V
    %%%                        V = kg*m^2/(A*s^3)
    %%%          sigma units = A^2 * s^3 / (kg * m^3)
    att_rate =  sigma*(1000 * 10*log10(exp(1))/(e_0*sqrt(e_prime)*cair));
end

end