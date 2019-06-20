function delete_lastline(num_to_delete)
% Deletes the last line plotted

if exist('num_to_delete') == 0
    num_to_delete = 1;
end

for i = 1:num_to_delete
    cds = get(gca,'Children');
    
    
    line_to_delete = [];
    counter = 1;
    
    for i = 1:length(cds)
        if length(cds(i).Type) == 4
            if min(cds(i).Type == 'line') == 1
                line_to_delete(counter) = i;
                counter = counter+1;
                break
            end
        end
        if length(cds(i).Type) == 7
            if min(cds(i).Type == 'scatter') == 1
                line_to_delete(counter) = i;
                counter = counter+1;
                break
            end
        end
    end
    
    if length(line_to_delete) > 0
        delete(cds(line_to_delete));
    end
end
end