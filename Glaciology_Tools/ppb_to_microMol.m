function output = ppb_to_microMol(ppm_in,molar_mass)
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Converts from parts-per-million (which is a mass fraction) to micro-mols
% per liter (assuming the solvent is water).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ppm_in - this is the mass fraction in parts per billion
% molar_mass - the molar mass of the material in g/mol, or an integer value
%               for some of the common chemicals:
%               0 - Prompt with a list
%               1 - Cl
%               2 - Ca
%               3 - Mg
%               4 - Na
%               5 - K
%               6 - NH4
%               7 - NO3
%               8 - SO4
%               9 - Mesylate - CH3SO3
%               10 - Formate - CHOO
%               11 - Glycolate - C2H3O3 (-)
%               12 - Acetate - C2H3O2 (-)
%               13 - Oxalate - C2O4 (2-) 
%               
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% output - The concentration in microMol/L
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


if molar_mass == 0
    molar_mass = listdlg('ListString',{'Cl','Ca','Mg','Na','K','NH4','NO3','SO4','Mesylate - CH3SO3','Formate - CHOO','Glycolate - C2H3O3','Acetate - C2H3O2','Oxalate - C2O4'});
end

%%%%%%%%%%%%%%%%%% MolarMasses (g/mol)
p_water = 18.01528;
p_Cl = 35.453;
p_NO3 = 62.0049;
p_SO4 = 96.06;
p_CH3SO3 = 95.0977;
p_Ca = 40.078;
p_K = 39.0983;
p_Mg = 24.305;
p_Na = 22.9898;
p_glycolate = 75.05;
p_acetate = 59.04;
p_oxalate = 88.018;

if molar_mass == 1      % Cl
    molar_mass = p_Cl;
elseif molar_mass == 2  % Ca
    molar_mass = p_Ca;    
elseif molar_mass == 3  % Mg
    molar_mass = p_Mg;    
elseif molar_mass == 4  % Na
    molar_mass = p_Na;    
elseif molar_mass == 5  % K
    molar_mass = p_K;    
elseif molar_mass == 6  % NH4
    molar_mass = p_Cl;    
elseif molar_mass == 7  % NO3
    molar_mass = p_NO3;    
elseif molar_mass == 8  % SO4
    molar_mass = p_SO4;    
elseif molar_mass == 9  % Mesylate - CH3SO3
    molar_mass = p_CH3SO3;
elseif molar_mass == 10  % Formate - CHOO'
    molar_mass = p_SO4;
elseif molar_mass == 11  % Glycolate - C2H3O3
    molar_mass = p_glycolate;
elseif molar_mass == 12  % Acetate - C2H3O2
    molar_mass = p_acetate;
elseif molar_mass == 13  % Oxalate - C2O4 (2-)
    molar_mass = p_oxalate;
end

output = ppm_in/molar_mass;

end









