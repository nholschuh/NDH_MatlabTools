function [indecies_s1 indecies_s2 series_num] = find_overlap(series1,series2)
% (C) Nick Holschuh - Penn State University - 2013 (Nick.Holschuh@gmail.com)
% In two sequential series, finds the overlapping sections.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are:
%
% series1 - One of the two series
% series2 - The other series
%
%%%%%%%%%%%%%%%
% The outputs are:
%
% indecies = The start and stop indecies for the overlapping section
%
% series_num = Indicator for which of the two series contains the other
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


length1 = length(series1);
length2 = length(series2);

l1 = find_nearest(series2,min(series1));
l2 = find_nearest(series1,min(series2));
r1 = find_nearest(series2,max(series1));
r2 = find_nearest(series1,max(series2));

if l1 == 1 & r1 == length(series2);
    series_num = 1;
elseif l2 == 1 & r2 == length(series1);
    series_num = 2;
else
    series_num = 3;
end

indecies_s1 = l2:r2;
indecies_s2 = l1:r1;


end


