function delete_children()

cs = get(gcf,'Children');

for i = 1:length(cs)
    delete(cs);
end

