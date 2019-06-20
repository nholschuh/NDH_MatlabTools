function [index result distance] = find_nearest_xyz(vector_2_search,value,how_many,radius)
% (C) Nick Holschuh - Penn State University - 2013 (Nick.Holschuh@gmail.com)
% In the way that the find commands finds values in a matrix identical to
% the search vector, this command finds the nearest entry.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are:
%
% vector_2_search = The set of data that you want to search. Each entry
%                   should be a row. This also works with a n x m x 2
%                   matrix to search, with x y pairs in the 3rd dimension.
% value = The value you want to find within "vector_2_search" (row vector)
% how_many = The function will find the x nearest values to "value", where
%               x is an integer defined by "how_many"
%
%
%%%%%%%%%%%%%%%
% The outputs are:
%
% index = the index values for the location within "vector_2_search" where
% the nearest possible values are stored.
%
% results = the values themselves within the vector.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('how_many') == 0
    how_many = 1;
end



        vector_2_search_temp(:,1) = vector_2_search(:,1) - value(:,1);
        vector_2_search_temp(:,2) = vector_2_search(:,2) - value(:,2);
        vector_2_search_temp(:,3) = vector_2_search(:,3) - value(:,3);
        
        
        vector_2_search_temp2 = (vector_2_search_temp(:,1).^2+vector_2_search_temp(:,2).^2+vector_2_search_temp(:,3).^2).^0.5;
        vector_2_search_temp2(:,2) = 1:length(vector_2_search(:,1));
        
        if how_many > 1
            vector_2_search_temp3 = sortrows(vector_2_search_temp2,1);
            index = vector_2_search_temp3(1:how_many,2);
            distance = vector_2_search_temp3(1:how_many,1);
            result = vector_2_search(index,:);
        else
            index = find(vector_2_search_temp2(:,1) == min(vector_2_search_temp2(:,1)));
            index = index(1);
            distance = vector_2_search_temp2(index,1);
            result = vector_2_search(index,:);
        end
    


end






  