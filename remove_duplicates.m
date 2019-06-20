function [result indecies] = remove_duplicates(series,entry_num);
%% Removes identical entries from a data series of arbitrary row# or column #
%% the indeces value is what indexes remain after removal

method =2;
if exist('entry_num') == 0
    entry_num = 1;
end

if length(series) == 0
    result = [];
    indecies = [];
else
    
    % This checks to see if the data is stored in rows or columns, and if in
    % rows, converts to columns for processing.
    if length(series(:,1)) < length(series(1,:))
        series = series';
        marker = 1;
    else
        marker = 0;
    end
    
    % This adds original row indecies to the data, so that you know which rows
    % were removed when the process is complete
    
 
    
    if method == 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% This is all deprecated - Matlab has a better
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% built in function
%         series = [series [1:length(series(:,1))]'];
%         
%         % This sorts the data according to each column, such that identical entries
%         % should end up adjacent when the process is complete.
%         for i = 1:(length(series(1,:))-1)
%             series = sortrows(series,length(series(1,:))-i);
%         end
%         
%         % This checks all adjacent pairs of data to see if they are identical, and
%         % indexes the ones that are.
%         counter = 1;
%         for i = 1:(length(series(:,1))-1)
%             if min(series(i+1,1:end-1) == series(i,1:end-1)) == 1
%                 remove_vec(counter) = i+1;
%                 counter = counter+1;
%             end
%         end
%         
%         % Here we remove one of each of the identical pairs.
%         if exist('remove_vec') == 1
%             series = removerows(series,'ind',remove_vec);
%         end
%         
%         % Now we return the data to its original order.
%         series = sortrows(series,length(series(1,:)));
%         indecies = series(:,length(series(1,:)));
%         series = series(:,1:end-1);       

    elseif method == 2
        remaining_indecies = 1:length(series(:,1));
        for i = 1:entry_num-1
            [series2 indecies] = unique(series,'rows');
            
            series(indecies) = [];
            remaining_indecies(indecies) = [];
        end
        [series indecies] = unique(series,'rows');
    end

  
    if marker == 1
        series = series';
    end
    
    result = series;
end
end