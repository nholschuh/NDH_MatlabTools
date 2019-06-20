function [index result] = find_vector_in_vector(vector_2_search,vector_2_find);
% This finds all the values of one vector inside a second vector

index = [];
for i = 1:length(vector_2_find)
    index_temp = find(vector_2_search == vector_2_find(i));
    index = [index index_temp];
end
result = vector_2_search(index);
end