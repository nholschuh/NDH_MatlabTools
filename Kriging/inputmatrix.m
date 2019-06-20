function input = inputmatrix(matrix,dx,dy)

% creates a matrix of the form 'input' = [x1 y1 value1;x2 y2 value2; ...]
% from a matrix of the form 'matrix' = [value11 value12 ...; value21
% value22...;...]. dx and dy describe the distance between two values in x
% or y direction.
%
% usage:    input = inputmatrix(matrix,dx,dy)

% 16.6.2003 Rolf Sidler

% variables
k = 0;x = 0; y = 0;
maximum = size(matrix);
input = zeros((maximum(1)*maximum(2)),3);

for i = 1:maximum(1)
    for j = 1:maximum(2)
        k = k+1;
        input(k,1) = x;
        input(k,2) = y;
        input(k,3) = matrix(i,j);
        x = x+dx;
    end
    y = y+dy;
    x = 0;
end