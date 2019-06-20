function [CData map] = get_colormap_and_index()

childs = get(gca,'Children');

for i = 1:length(childs)
    if length(childs(i).Type) == 5
        if childs(i).Type == 'image'
        ci = i;
        break
        end
    end
end


CData = childs(ci).CData;
map = colormap;
cvals = caxis;

[CData] = get_index_from_colormap(CData,cvals,map);

end