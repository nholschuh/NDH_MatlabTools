function outmat = flipud_3d(inmat);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This function takes an NxMx3 matrix and flips the top and bottom rows in
% each slice.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% inmat - NxMx3 matrix to flip up/down
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% outmat - The flipped matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

inclass = class(inmat);

outtemp = zeros(size(inmat));

for i = 1:length(inmat(1,1,:));
    outtemp(:,:,i) = flipud(inmat(:,:,i));
end

reclass_str = ['outmat = ',inclass,'(outtemp);'];
eval(reclass_str);
end













