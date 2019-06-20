function [output] = remove_duplicates_char(entry)


%%
counter = 1;
removed_rows = [];

while counter < length(entry(:,1))
    comparator = repmat(entry(counter,:),length(entry(counter+1:end,1)),1);
    remove_ind = find(min([comparator == entry(counter+1:end,:)],[],2)) + counter;
    
    entry(remove_ind,:) = [];
    
    %%%%%%% This next line should always be 0, assuming there are no bugs
    %%%%%%% in the code...
    counter_adjust = sum([remove_ind < counter]); % This accounts for entries removed above the current value
    
    counter = counter+1-counter_adjust;
end

output = entry;