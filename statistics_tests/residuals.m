function results = residuals(series,coef)
% Calculates the residuals of a polyfit series.

calc = [series(:,1) ones(length(series),1)];
results = series(:,2) - calc*coef';
end