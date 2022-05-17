function output = combvec(vec1,vec2);
% (C) Nick Holschuh - Amherst College - 2020 (Nick.Holschuh@gmail.com)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% vec1 - 
% vec2 - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% output - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


s1 = size(vec1);
s2 = size(vec2);

if s1(2) == 1 & s2(2) == 1 %%%%%% The vertical case
    nvec1 = matrix_to_vector((vec1*ones(size(vec2))')');
    nvec2 = repmat(vec2,length(vec1),1);
    
    output = [nvec1 nvec2];
elseif s1(1) == 1 & s2(1) == 1  %%%%%%%% The horizontal case
    nvec1 = matrix_to_vector((vec1'*ones(size(vec2)))');
    nvec2 = repmat(vec2',length(vec1),1);
    
    output = [nvec1'; nvec2'];
end