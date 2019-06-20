function indecies = time2index(values,time_vec);
% Calculates the data index value given a pick time and a vector of time
% values.

indecies = round(((values - time_vec(1))/(time_vec(2)-time_vec(1)))+1);
indecies(find(indecies > length(time_vec))) = length(time_vec);
indecies(find(indecies < 1)) = 1;
end