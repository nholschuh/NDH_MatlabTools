function [sigma sigma_components] = IceConductivity(temp_k,H,Cl,NH4,parameterset,frequency,param_override);
% (C) Nick Holschuh - University of Washington - 2017 (holschuh@uw.edu)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This fonction computes attenuation rates from temperature and impurity
% values taken from a variety of relationships in the literature. The
% different relationships are defined below.
%
% As a point of note, the MacGregor et al 07 and one that comes from Wolff
% et al 1997. Wolff yeilds lower attenuation rates.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% temp_k - Temperature in Kelvin (273.15 = 0C)
% H - Hydrogen Ion Concentration (microMol/L, output from molarH)
% Cl - Sea-salt Chlorine Ion Concentration (from ppb_to_microMol)
% NH4 - Ammonium Chlorine Ion Concentration (from ppb_to_microMol)
% parameterset - Choice of conductivity model
%                   0 - Gudmensen, only T, Greenland
%                   1 - MacGregor 2007 (Siple Dome)
%                   2 - MacGregor 2015 (Greenland)
%                   [3] - Wolff 1997 (can accomodate F dependence)
% frequency - If parameterset = 3, frequency of the instrument, if you want
%           to take into account relaxation determined from MacGregor 2015.
%           Otherwise leave blank
% param_override - Allows you to replace a value for one of the input
%               variables in the conductivity equations. I have used it to
%               replace the value for T_ref, but it can be used for: {mu_h,
%               EH, mu_Cl, ECl, mu_CH4, ECH4}. Provide a cell array with
%               the variable name followed by the value to replace it.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sigma - Total Conductivity of the Ice
% sigma_components - Each of the components of conductivity
%          Col 1 - Total Conductivity
%          Col 2 - Pure Ice Conductivity
%          Col 3 - H+ Conductivity
%          Col 4 - Cl Conductivity
%          Col 5 - NH4 Conductivity
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

%%%%%%%%%%%%%%%%%%%%%%%%% These are the pure-ice values that can be used
if exist('parameterset') == 0
    parameterset = 3;
end

debug = 0;
sigma_adjust = 0;

if parameterset == 0
    %%%%%%%% The best fit to the Gudmensen 1971 paper, outlined in
    %%%%%%%% MacGregor et al 2007
    sig_0 = 15.4; % microSimmons / m
    E0 = 0.33; % 0.33 eV
    T_ref = 251;
    
    mu_h = 0; %S/(m Mol)
    EH = 0; %eV
    
    mu_Cl = 0; %S/(m Mol)
    E_Cl = 0; %eV
    
    mu_NH4 = 0; %S/(m Mol)
    E_NH4 = 0; %eV
    
    if debug == 1
        disp(['Using Gudmensen 1971 Mean Values for Conductivity Calculation'])
    end
    
elseif parameterset == 1
    %%%%%%%%  Macgregor et al 07 mean values
    sig_0 = 7.2; % microSimmons / m
    E0 = 0.55; % 0.33 eV
    T_ref = 273.15-21;     %%%%%%%%%%%%% The original paper says 251, but that disagrees with the 2015 paper?
    
    mu_h = 3.2; %S/(m Mol)
    EH = 0.20; %eV
    
    mu_Cl = 0.43; %S/(m Mol)
    E_Cl = 0.19; %eV
    
    mu_NH4 = 0.8; %S/(m Mol)
    E_NH4 = 0.23; %eV
    
    if debug == 1
        disp(['Using MacGregor et al 07 Mean Values for Conductivity Calculation'])
    end
    
elseif parameterset == 2
    %%%%%%%%  Macgregor et al 07 parameters in his greenland attenuation
    %%%%%%%%  paper, but seem to come from Johari and Carette 1973?
    sig_0 = 9.2; % microSimmons / m
    E0 = 0.51; % eV
    T_ref = 273.15-21;
    
    mu_h = 3.2; %S/(m Mol)
    EH = 0.21; %eV
    
    mu_Cl = 0.43; %S/(m Mol)
    E_Cl = 0.19; %eV
    
    mu_NH4 = 0.8; %S/(m Mol)
    E_NH4 = 0.23; %eV
    
    if debug == 1
        disp(['Using MacGregor et al 15 Mean Values for Conductivity Calculation'])
    end
    
elseif parameterset == 3
    %%%%%%%% Wolff et al 97 parameters
    sig_0 = 9; % microSimmons / m
    E0 = 0.58; % eV
    T_ref = 273.15-15;
    
    mu_h = 4; %S/(m Mol)
    EH = 0.21; %eV
    
    mu_Cl = 0.55; %S/(m Mol)
    E_Cl = 0.23; %eV
    
    mu_NH4 = 1; %S/(m Mol)
    E_NH4 = 0.23; %eV
    
    if debug == 1
        disp(['Using Wolff et al 15 Mean Values for Conductivity Calculation'])
    end
    
    %%%%%%%%%%%%%%% Based on some analysis of Stilman et al. 2013,
    %%%%%%%%%%%%%%% MacGregor et al 2015 showed that there may be
    %%%%%%%%%%%%%%% non-Debeye relaxations in ice, which would introduce a
    %%%%%%%%%%%%%%% frequency term. That is factored in here if a frequency
    %%%%%%%%%%%%%%% term is provided. This can only be done with the Wolff
    %%%%%%%%%%%%%%% model, which was derived for 300kHz:
    
    if exist('frequency')
        if length(frequency) == 1
            if frequency ~= 0
                sigma_adjust = 1;
            end
        end
    end
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%% Parameter values for the other ion constituents
%%%%%%%%%%%%%%%%%%%%%%%%%% (These are the means taken from MacG 2007 + MacG 2015)

k = 8.6173324*10^-5; % eV/K - Boltzmann constant


if exist('param_override') == 1
    if mod(length(param_override),2) == 1
        disp(['Must supply an even number of arguments to param_override'])
    else
        for i = 1:length(param_override)/2
            param_string = [param_override{2*i-1},' = ',num2str(param_override{2*i}),';'];
            eval(param_string)
        end
    end
end


%%% Can be taken from MacGregor et al 2007

pure_sig = (sig_0.*exp((E0./k).*((1./T_ref) - (1./temp_k))))./10^6;
H_sig = (mu_h.*H.*exp((EH./k).*((1./T_ref) - (1./temp_k))))./10^6;
CL_sig = (mu_Cl.*Cl.*exp((E_Cl./k).*((1./T_ref) - (1./temp_k))))./10^6;
NH4_sig = (mu_NH4.*NH4.*exp((E_NH4./k).*((1./T_ref) - (1./temp_k))))./10^6;

if sigma_adjust == 0
    sigma = pure_sig + H_sig + CL_sig + NH4_sig;
    
    sigma_components = [sigma,pure_sig,H_sig,CL_sig,NH4_sig];
else
    
    %%%%% Values from Stilman, see in MacGregor 2015 pg. 1003 (the plots)
    omega = 2*pi*frequency;
    base_omega = 2*pi*300000;
    tau = 8*10^-4;
    alpha = 0.15;
    E0 = 8.854187817*10^-12;
    scale_fac = omega*E0*imag((100/(1+(sqrt(-1)*omega*tau)^(1-alpha))))/(base_omega*E0*imag((100/(1+(sqrt(-1)*base_omega*tau)^(1-alpha)))));
    sigma = pure_sig + H_sig + CL_sig + NH4_sig;
    
    sigma_components = [sigma,pure_sig,H_sig,CL_sig,NH4_sig]*scale_fac;
    sigma = sigma*scale_fac;
end


end





