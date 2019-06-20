function [lambda] = minimizing2(C,c)

% minimizing2 calculates the factors 'lambda' by minimizing the variances.
%
% usage:    [lambda] = minimizing2(C,c)

% minimizing the variances for the point that is to interpolate
lambdavector = C\c';
% putting lambda in a matrix
% k = 1;
% for i = 1:sqrt(points)
%     for j = 1:sqrt(points)
%         lambdamatrix(i,j) = lambdavector(k);
%         k = k+1;
%     end
% end
lambda = lambdavector;