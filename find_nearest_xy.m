function [index result distance] = find_nearest_xy(vector_2_search,value,how_many)
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


sd = size(vector_2_search);

%%%%% The two column, vector search case
if length(sd) == 2
    

    if min(size(value)) == 1 %& how_many < Inf
        method = 1;
    else
        method = 2;
    end
    
    %%%%% originally implemented method, only good if the search domain and
    %%%%% number of points to search are both huge (it takes a lot of
    %%%%% memory)
    
    if method == 1
        vector_2_search_temp(:,1) = vector_2_search(:,1) - value(:,1);
        vector_2_search_temp(:,2) = vector_2_search(:,2) - value(:,2);
        
        
        vector_2_search_temp2 = (vector_2_search_temp(:,1).^2+vector_2_search_temp(:,2).^2).^0.5;
        vector_2_search_temp2(:,2) = 1:length(vector_2_search(:,1));
        
        if how_many > 1
            vector_2_search_temp3 = sortrows(vector_2_search_temp2,1);
            index = vector_2_search_temp3(1:how_many,2);
            distance = vector_2_search_temp3(1:how_many,1);
            result = vector_2_search(index,:);
        else
            index = find(vector_2_search_temp2(:,1) == min(vector_2_search_temp2(:,1)));
            if length(index) == 0
                index = Inf;
                distance = Inf;
                result = Inf;
            else
                index = index(1);
                distance = vector_2_search_temp2(index,1);
                result = vector_2_search(index,:);
            end
        end
        
    %%%%% This method is more efficient, and can handle multiple input
    %%%%% values.

    elseif method == 2
        comp_vec = vector_2_search(:,1) + vector_2_search(:,2)*sqrt(-1);
        ss = size(value);
        if max(ss) > 1 & ss(1) >= ss(2)
           value2 = value';
        elseif ss(1) == 1
            value2 = value';
        else
            value2 = value;
        end
        value_search = [value2(1,:) + value2(2,:)*sqrt(-1)];

        dists = abs(comp_vec - value_search);
        
        if how_many == 1
            %%%%%%%%%%% Most efficient method for looking for an individual
            %%%%%%%%%%% value
            [minval ind] = min(dists);
            index = ind';
            distance = minval';
            result = vector_2_search(index,:);            
        else
            %%%%%%%%%%% Method that includes a loop, but can find the
            %%%%%%%%%%% distance and indecies of multiple points
            for i = 1:length(value(:,1));
                [distance(i,:) index(i,:)] = sort(dists(:,i));
                result(i,:) = vector_2_search(index(i,:));
            end
            
            distance = distance(:,1:how_many);
            index = index(:,1:how_many);
            result = result(:,1:how_many);
        end
        
    end

%%%%% The m x n x 2, matrix search case
elseif sd(3) == 2
    vector_2_search_temp(:,:,1) = vector_2_search(:,:,1) - value(:,1);
    vector_2_search_temp(:,:,2) = vector_2_search(:,:,2) - value(:,2);   
    
    vector_2_search_temp2 = (vector_2_search_temp(:,:,1).^2+vector_2_search_temp(:,:,2).^2).^0.5;
    
    counter = 1;
    while counter <= how_many
        temp_index = find(min(min(vector_2_search_temp2)) == vector_2_search_temp2);
        [index_r index_c] = find(min(min(vector_2_search_temp2)) == vector_2_search_temp2);
        for i = 1:length(temp_index)
            index(counter) = temp_index(i); 
            distance(counter) = min(min(vector_2_search_temp2));
            result(counter,:) = [vector_2_search(index_r(i),index_c(i),1) vector_2_search(index_r(i),index_c(i),2)];
            
            %%%% This sets the distance to the recently selected point to
            %%%% max, so it is not chosen again.
            vector_2_search_temp2(index(counter)) = max(max(vector_2_search_temp2));
            counter = counter+1;
           
            if counter > how_many
                break
            end
        end
    end


end






  