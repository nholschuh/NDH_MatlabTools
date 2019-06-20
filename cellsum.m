function [sumvalue counterfinal] = cellsum(cellnum,object,radius)
% (C) Nick Holschuh - University of Washington - 2016 (Nick.Holschuh@gmail.com)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are:
%
% ________ - 
% ________ - 
% ________ - 
% ________ - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are:
%
% ________ - 
% ________ - 
% ________ - 
% ________ - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Dependencies are:
%
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Provides the sum of all the cells within radius of a grid cell

xmax = length(object(1,:))+1;
ymax = length(object(:,1))+1;

for k = 1:length(cellnum(:,1))

    xrange = (cellnum(k,1) - floor(radius)*2):(cellnum(k,1) + floor(radius)*2);
    yrange = (cellnum(k,2) - floor(radius)*2):(cellnum(k,2) + floor(radius)*2);

    xrange = find(xrange > 0 & xrange < xmax);
    yrange = find(yrange > 0 & yrange < ymax);
    
    counterfinal(k,2) = length(xrange)*length(yrange);
    
    sumvalue(k,1) = sum(sum(object(yrange,xrange)));

end

end