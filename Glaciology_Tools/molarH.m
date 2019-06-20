function [H_out] = molarH(Cl,Ca,Mg,Na,K,NO3,SO4_ss,SO4_xs,organic_acids1,organic_acids2)
% (C) Nick Holschuh - Penn State University - 2013 (Nick.Holschuh@gmail.com)
% Computes the effective charge balance based on the
% impurity content in the ice.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows, in microMols/L:
%
% Cl - Chlorine
% Ca - Calcium
% Mg - Magnesium
% Na - Sodium
% K - Potassium
% NO3 - Nitrate
% SO4_ss - Sulfate (Sea-salt)
% SO4_xs - Sulfate (Non Sea-Salt)
% organic_acids1 - Mesylate - CH3SO3
%                  Formate - CHOO
%                  Glycolate - C2H3O3 (-)
%                  Acetate - C2H3O2 (-)
% organic_acids2 - Oxalate - C2O4 (2-) 

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('organic_acids2') == 0
    organic_acids2 = 0;
end
if exist('organic_acids1') == 0
    organic_acids1 = 0;
end
if exist('SO4_xs') == 0
    SO4_xs = 0;
end

%%%%%%%%%%%%%%%%% Compute the Hydrogen Ions
H_out = Cl + NO3 + 2*SO4_ss + SO4_xs + organic_acids1 + 2*organic_acids2 - 2*Ca - K - 2*Mg - Na;

end

