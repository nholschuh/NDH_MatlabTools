function result = magnitude(xs,ys);
% Computes the magnitude of two orthogonal vectore;

ys = ys*sqrt(-1);

result = abs(xs+ys);