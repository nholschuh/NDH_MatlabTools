function T = PureIce_Temperature(sigma);


k = 8.6173324*10^-5; % eV/K - Boltzmann constant

%%% Can be taken from MacGregor et al 2007
sig_0 = 7.2; % microSimmons / m 
E0 = 0.55; % 0.33 eV
T = 1./((1/251) - (log(sigma*10^6) - log(sig_0))*k/E0);

end