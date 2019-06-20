function [results_a results_b results_c] = find_curve_points(curve)
% (C) Nick Holschuh - Penn State University - 2013 (Nick.Holschuh@gmail.com)
% This script finds 0-crossings (1), local maxima and minima (2), and inflection
% points (3) for a given curve supplied to the function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% curve - A supplied data series, which you want the 0-crossings, local
% maxima and minima, and inflection points for.
%
% The OUTPUTS are as follows:
% results_a = The index value for 0 crossings
% results_b = The index value for maxima / minima (3 sample centered
% difference)
% results_c = The index value for inflection points (5 sample centered
% difference)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
if length(curve(:,1)) > 1
    curve = curve';
end

derivative_series = curve(3:end)-curve(1:end-2);
derivative2_series = ((curve(5:end)-curve(3:end-2))/2 - (curve(3:end-2)-curve(1:end-4))/2)/2;

d1_filler = [(derivative_series(1)) (derivative_series(end))];
d2_filler = [(derivative2_series(1)) (derivative2_series(end))];

derivative_series = [ones(1,1)*d1_filler(1) derivative_series ones(1,1)*d1_filler(2)];
derivative2_series = [ones(1,2)*d2_filler(1) derivative2_series ones(1,2)*d2_filler(2)];

counter1 = 1;
counter2 = 1;
counter3 = 1;

results_a = [];
results_b = [];
results_c = [];

for i = 4:length(curve)-3
    if curve(i)*curve(i+2) < 0
        if counter1 > 1
            if results_a(counter1-1) == i
                true_crossing = find_nearest(curve(i-3:i+3),0);
                results_a(counter1-1) = i-4+true_crossing;                
            else
                results_a(counter1) = i+1;
                counter1 = counter1+1;
            end
        else
            results_a(counter1) = i+1;
            counter1 = counter1+1;
        end
    end
    if derivative_series(i)*derivative_series(i+2) < 0
        if counter2 > 1
            if results_b(counter2-1) == i
                true_crossing = find_nearest(derivative_series(i-3:i+3),0);
                results_b(counter2-1) = i-4+true_crossing;                
            else
                results_b(counter2) = i+1;
                counter2 = counter2+1;
            end
        else
            results_b(counter2) = i+1;
            counter2 = counter2+1;
        end
    end
    if derivative2_series(i)*derivative2_series(i+2) < 0
        if counter3 > 1
            if results_c(counter3-1) == i
                true_crossing = find_nearest(derivative2_series(i-3:i+3),0);
                results_c(counter3-1) = i-4+true_crossing;                
            else
                results_c(counter3) = i+1;
                counter3 = counter3+1;
            end
        else
            results_c(counter3) = i+1;
            counter3 = counter3+1;
        end
    end    
end

end
    