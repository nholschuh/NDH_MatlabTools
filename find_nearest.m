function [index result distance] = find_nearest(vector_2_search,value,how_many,exclude_area)
% (C) Nick Holschuh - Penn State University - 2013 (Nick.Holschuh@gmail.com)
% In the way that the find commands finds values in a vector identical to
% the search value, this command finds the nearest entry in a given vector.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are:
%
% vector_2_search = The set of data that you want to search
% value = The value you want to find within "vector_2_search"
% how_many = The function will find the x nearest values to "value", where
%               x is an integer defined by "how_many"
%
% exclude_area = This defines the number of samples (centered on the
%                   nearest one found) to disallow from the search once one
%                   of the nearest values has been selected. This is to
%                   help foster the selection of different peaks, instead
%                   of multiple samples from the same peaks, when using a
%                   value > 1 for the "how_many" variable to find local
%                   maxima (or other similar searches).
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

if length(value) == 1
    method = 1;
else
    method = 2;
end


if method == 1
    
    %%%%%%%%%%% Find the nearest sample
    vector_2_search_temp = abs(vector_2_search - value);
    temp_index = find(vector_2_search_temp == min(vector_2_search_temp));
    index(1) = temp_index(1);
    result(1) = vector_2_search_temp(index);
    
    if exist('how_many') == 0
        how_many = 1;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%% Everything through here just finds the NEXT
    %%%%%%%%%%%%%%%%%%%%%%%%%%% nearest samples, based on how many are
    %%%%%%%%%%%%%%%%%%%%%%%%%%% requested
    if how_many > 1
        temp = vector_2_search_temp;
        
        for i = 2:(how_many)
            if exist('exclude_area') == 1
                temp = exclude(temp,index(i-1),exclude_area);
            else
                temp = exclude(temp,index(i-1));
            end
            temp_index = find(temp == min(temp));
            index(i) = temp_index(1);
            result(i) = temp(index(i));
        end
        
        
        index2 = [];
        
        for i = 1:length(result);
            temp2 = find(abs(vector_2_search - value) == result(i));
            temp3 = find(abs(temp2-index(i)) == min(abs(temp2-index(i))));
            if length(temp3) > 1
                if temp2(temp3(1)) == index2(i-1)
                    temp3 = temp3(2);
                else
                    temp3 = temp3(1);
                end
            end
            index2(i) = temp2(temp3);
        end
        
        result = [];
        
        for i = 1:length(index2)
            result(i) = vector_2_search(index2(i));
        end
    else
        result(1) = vector_2_search(index);
    end
    
    if exist('index2') == 1
        index = index2;
    end
    
    distance = abs(result - value);
    
elseif method == 2
    
        ss = size(value);
        if max(ss) > 1 & ss(1) >= ss(2)
           value2 = value;
        elseif ss(1) == 1
            value2 = value';
        end
        
        ss2 = size(vector_2_search);
        if ss2(2) == 1
            vector_2_search = vector_2_search';
        end
        dists = abs(vector_2_search - value2);
        [minval ind] = min(dists');
        index = ind';
        distance = minval';
        result = vector_2_search(index);        
   
end



end
  