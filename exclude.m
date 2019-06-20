function result = exclude(vector,indecies,exclude_area)
% (C) Nick Holschuh - Penn State University - 2013 (Nick.Holschuh@gmail.com)
% removes the selected index values from a vector. Used as a subroutine in
% other functions.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% vector - The data you want values excluded from.
%
% indecies - The index values for the entries you want removed.
%
% exclude_area - This sets the number of samples around each index that
% will be removed (ie, if indecies = 5, and exclude_area = 3, the series
% 1:10 would be [1 2 3 7 8 9 10];
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
include_vec = [];

if exist('exclude_area') == 1
    exclude_vec = [];
    range_num = floor((exclude_area - 1)/2);
    for i = 1:length(indecies)
        exclude_vec = [exclude_vec (indecies(i)-range_num):(indecies(i)+range_num)];
    end
else
    exclude_vec = indecies;
end



for i = 1:length(indecies)
    
    if i == 1
        include_vec = [include_vec 1:(exclude_vec(1)-1)];
    end
    if i > 1
        if exclude_vec(i)-exclude_vec(i-1) > 1
                include_vec = [include_vec (exclude_vec(i-1)+1):(exclude_vec(i)-1)];

        end
    end
    
end

include_vec = [include_vec (exclude_vec(length(exclude_vec))+1):length(vector)];


result = vector(include_vec);
end