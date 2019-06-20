function [rgb_data] = getRGB_imagesc(data,plotter);
% Extracts individual R, G, and B matricies so that multiple colormaps can
% be plotted together.

if exist('plotter') == 0
    plotter = 0;
end

cvals = colormap;
c_inds = caxis;
c_inds = linspace(c_inds(1),c_inds(2),length(cvals(:,1)));

rgb_data = zeros([size(data) 3]);

for i = 1:length(data(:,1))
        rgb_data(i,:,1) = interp1(c_inds,cvals(:,1),data(i,:));
        rgb_data(i,:,2) = interp1(c_inds,cvals(:,2),data(i,:));
        rgb_data(i,:,3) = interp1(c_inds,cvals(:,3),data(i,:));
end

if plotter == 1
    imagesc(rgb_data);
end
end
