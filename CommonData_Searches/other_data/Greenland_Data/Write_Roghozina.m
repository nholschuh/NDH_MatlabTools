data = dlmread('Martos_2018_Geothermal_Heat_Flux_Greenland.xyz');

xs = sort(unique(data(:,1)));
ys = sort(unique(data(:,2)));




for i = 1:length(xs)
    for j = 1:length(ys);
    ind = find(data(:,1) == xs(i) & data(:,2) == ys(j));
    if length(ind) > 0
    hf(j,i) = data(ind,3);
    end
    end
end

imagesc(xs,ys,hf)
set(gca,'YDir','normal')
groundingline()

grdwrite(xs,ys,hf,'Martos.mc');

