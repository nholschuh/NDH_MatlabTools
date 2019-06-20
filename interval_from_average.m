function [interval_rates] = interval_from_average(averages,depth);
% Computes the interval values for a set of given depth averaged
% equivalents.

interval_rates(1) = averages(1);

for i = 2:length(averages);
    interval_rates(i) = (averages(i)*depth(i) - averages(i-1)*depth(i-1))/(depth(i)-depth(i-1));
end


    
    