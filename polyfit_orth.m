function [p,p_err,resid] = polyfit_orth(xdata, ydata)
% LINORTFIT2  Fit a line to data by ORTHOGONAL least-squares.
%    P = LINORTFIT2(X,Y) finds the coefficients of a 1st-order polynomial
%    that best fits the data (X,Y) in an ORTHOGONAL least-squares sense.
%    Consider the line P(1)*t + P(2), and the minimum (Euclidean) distance
%    between this line and each datapoint [X(i) Y(i)] -- LINORTFIT2 finds
%    P(1) and P(2) such that the sum of squared distances is minimized.

if length(xdata(1,:)) > 1
    xdata = xdata';
    ydata = ydata';
end

if ~isequal(size(xdata), size(ydata))
    error('linortfit2:XYSizeMismatch',...
          'X and Y vectors must be the same size.');
end

[N,C] = linortfitn([xdata(:) ydata(:)]);

% The hyperplane given by N * [x; y] + C == 0 is optimal.
% Convert to the form  y = p(1)*x + p(2), just like polyfit(xdata,ydata,1).
p = - [N(1)  C] / N(2);

for i = 1:length(xdata)
    resid(i) = point_line_distance([xdata(i) ydata(i) 0],[min(xdata) polyval(p,min(xdata)) 0],[max(xdata) polyval(p,max(xdata)) 0]);
end

%%% Method 1
%standard_error = resid*resid'/(length(resid)-2);
%Qxx = (xdata)'*xdata;
%p_err = sqrt(standard_error^2*inv(Qxx));

cov = inv([xdata ones(size(xdata))]'*[xdata ones(size(xdata))])/length(xdata(:,1));
p_err = diag(sqrt(cov));

end
