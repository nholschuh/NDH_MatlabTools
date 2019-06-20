function transparency(factor,minimum_opaque)



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

if exist('minimum_opaque')
    set(childs(ci),'Alphadata',[CData > minimum_opaque]*factor/100);
else 
    set(childs(ci),'Alphadata',factor/100);
end

end