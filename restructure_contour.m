function cs = restructure_contour(contour_out,outtype)
% (C) Nick Holschuh - U. of Washington - 2020 (Nick.Holschuh@gmail.com)
% This function takes in the default output of matlabs contour and contourc
% function, and converts it into a more sensible structure.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% contour_out - the default output from matlabs contourc function
% outtype - 0, a Nx2 vector with NaN's dividing the individual contour
%           lines (best for efficient replotting of contour data), or 1, a
%           cell array for each individual line.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% cs - the output lines
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if exist('outtype') == 0
    outtype = 0;
end

%%%%%%%%%%%%%%% This portion finds the contourline breaks
break_points = 1;

while break_points(end) < length(contour_out(1,:))
    break_points(end+1) = break_points(end)+contour_out(2,break_points(end))+1;
end

break_points = break_points(1:end-1);


if outtype == 0
    contour_out(:,break_points) = NaN;
    cs = contour_out';

elseif outtype == 1

    break_points = [1 break_points length(contour_out(1,:))+1];
    for i =1:length(break_points)-1
    cs{i} = contour_out(:,break_points(i)+1:break_points(i+1)-1)';
    end
end



