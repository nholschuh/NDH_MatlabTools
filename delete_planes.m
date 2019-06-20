function delete_planes()
% Deletes the last line plotted
cds = get(gca,'Children');

for i = 1:length(cds)
    if length(cds(i).Type) == 7
        if min(cds(i).Type == 'surface') == 1
            delete(cds(i));
            break
        end
    elseif length(cds(i).Type) == 5
        if min(cds(i).Type == 'image') == 1
            delete(cds(i));
            break
        end
    end
end

end