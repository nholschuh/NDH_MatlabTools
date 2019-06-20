
function [matrix] = matrixdisplay(input,length,heigth)

% creates a image of a input matrix in the form:
% input = [x1 y1 value1;x2 y2 value2;...]
%
% usage:    [matrix] = matrixdisplay(input,length,heigth)

% 13.6.2003 Rolf Sidler

k = 0;
x = input(1:heigth:end,1);
y = input(1:heigth,2);
for i = 1:length
    for j = 1:heigth
        k = k+1;
        matrix(i,j) = input(k,3);
    end
end
% figure
% surface(x,y,matrix)
figure
imagesc(matrix)
% figure
% contour(matrix)