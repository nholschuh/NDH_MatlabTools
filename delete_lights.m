function delete_lights()

cs = get(gca,'Children');

lf = [];
for i = 1:length(cs);
    if length(cs(i).Type) == 5
        if cs(i).Type == 'light'
            lf = [lf i];
        end
    end
end

for i = 1:length(lf)
delete(cs(lf(end+1-i)))
end
end