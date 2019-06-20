function [series1_removed removal_index] = remove_overlap(series1);
% Takes a single series of data that has a section repeated and removes the
% repeated section.

if length(series1(1,:)) == 1
    series1_removed = [];
    removal_index = [];
    
    still_overlap = 1;
    while still_overlap > 0
        
        for i = 1:length(series1)
            test = find_nearest(series1,series1(i),2);
            if abs(test(1)-test(2)) > 1
                markers = test;
                still_overlap = 1;
                break
            else
                still_overlap = 0;
            end
            
        end
        
        if exist('markers') == 0
            markers = [2 2];
        end
        removal_index = [removal_index ((markers(1)+1):markers(2))];
        series1_removed = series1([1:markers(1) (markers(2)+1):end]);
        series1 = series1_removed;
        clear markers
    end
    
else
    
    series1_removed = [];
    removal_index = [];
    
    still_overlap = 1;
    while still_overlap > 0
        
        for i = 1:length(series1(:,1))
            
            test = find_nearest_xy(series1,series1(i,:),2);
            if abs(test(1)-test(2)) > 1
                markers = test;
                still_overlap = 1;
                break
            else
                still_overlap = 0;
            end
            
        end
        
        if exist('markers') == 0
            markers = [2 2];
        end
        removal_index = [removal_index ((markers(1)+1):markers(2))];
        series1_removed = series1([1:markers(1) (markers(2)+1):end],:);
        series1 = series1_removed;
        clear markers
    end
    
    
end

