function vec = matrix_to_vector_withindecies(x,y,mat)
% Converts a 2d matrix into a 1d vector with the coordinates of each value
% stored
vec = [];

if length(y(1,:)) > 1
    y = y';
end

for i = 1:length(x)
    vec = [vec ; [ones(length(y),1)*x(i) y mat(:,i)] ones(length(y),1)*i [1:length(y)]'];
end
end